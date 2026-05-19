"""
app/modules/wallet/service.py
──────────────────────────────────────────────────────────────────
Business logic for Wallet operations and Kafka ledger syncing.
"""
import uuid
from typing import List

from app.modules.wallet.repository import WalletRepository
from app.modules.wallet.models import Wallet, Transaction
from app.services.kafka_service import KafkaService
from app.common.exceptions import ConflictException

class WalletService:
    def __init__(self, repo: WalletRepository):
        self.repo = repo

    async def get_or_create_wallet(self, user_id: uuid.UUID) -> Wallet:
        wallet = await self.repo.get_wallet_by_user(user_id)
        if not wallet:
            wallet = await self.repo.create_wallet(user_id)
        return wallet

    async def get_transactions(self, user_id: uuid.UUID) -> List[Transaction]:
        wallet = await self.get_or_create_wallet(user_id)
        return await self.repo.get_transactions(wallet.id)

    async def top_up(self, user_id: uuid.UUID, amount: float, method: str) -> Transaction:
        if amount <= 0:
            raise ConflictException("Amount must be greater than zero")
            
        wallet = await self.get_or_create_wallet(user_id)
        
        tx = await self.repo.apply_transaction(
            wallet_id=wallet.id,
            amount=amount,
            t_type="TOP_UP",
            description=f"Top up via {method}"
        )
        
        # Publish event to Kafka for the immutable ledger
        await KafkaService.publish_ledger_event("wallet.transactions", {
            "transaction_id": str(tx.id),
            "wallet_id": str(wallet.id),
            "user_id": str(user_id),
            "amount": amount,
            "type": "TOP_UP",
            "method": method,
            "timestamp": tx.created_at
        })
        
        return tx

    async def process_payment(self, customer_id: uuid.UUID, provider_id: uuid.UUID, amount: float, reference_id: uuid.UUID, description: str):
        """
        Transfers funds from Customer to Provider.
        Takes a 10% platform commission from the provider.
        """
        customer_wallet = await self.get_or_create_wallet(customer_id)
        provider_wallet = await self.get_or_create_wallet(provider_id)
        
        if customer_wallet.balance < amount:
            raise ConflictException("Insufficient balance")
            
        commission = amount * 0.10
        provider_net = amount - commission
        
        # 1. Deduct from Customer
        await self.repo.apply_transaction(
            customer_wallet.id, -amount, "PAYMENT", reference_id, f"Payment for {description}"
        )
        
        # 2. Add to Provider
        await self.repo.apply_transaction(
            provider_wallet.id, amount, "PAYMENT_RECEIVED", reference_id, f"Received for {description}"
        )
        
        # 3. Deduct Commission from Provider
        await self.repo.apply_transaction(
            provider_wallet.id, -commission, "COMMISSION", reference_id, "Platform Fee (10%)"
        )
        
        # Publish to Kafka
        await KafkaService.publish_ledger_event("wallet.payments", {
            "reference_id": str(reference_id),
            "customer_id": str(customer_id),
            "provider_id": str(provider_id),
            "amount_paid": amount,
            "commission": commission,
            "provider_net": provider_net
        })
