"""
app/modules/wallet/repository.py
──────────────────────────────────────────────────────────────────
Database operations for Wallet.
"""
import uuid
from typing import Optional, List
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.modules.wallet.models import Wallet, Transaction

class WalletRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def get_wallet_by_user(self, user_id: uuid.UUID) -> Optional[Wallet]:
        stmt = select(Wallet).where(Wallet.user_id == user_id)
        result = await self.session.execute(stmt)
        return result.scalar_one_or_none()

    async def create_wallet(self, user_id: uuid.UUID) -> Wallet:
        wallet = Wallet(user_id=user_id, balance=0.0)
        self.session.add(wallet)
        await self.session.flush()
        return wallet

    async def get_transactions(self, wallet_id: uuid.UUID, limit: int = 50) -> List[Transaction]:
        stmt = select(Transaction).where(Transaction.wallet_id == wallet_id).order_by(Transaction.created_at.desc()).limit(limit)
        result = await self.session.execute(stmt)
        return list(result.scalars().all())

    async def apply_transaction(self, wallet_id: uuid.UUID, amount: float, t_type: str, reference_id: Optional[uuid.UUID] = None, description: Optional[str] = None) -> Transaction:
        # Note: In a real high-concurrency app, we'd use SELECT FOR UPDATE to prevent race conditions.
        stmt = select(Wallet).where(Wallet.id == wallet_id).with_for_update()
        result = await self.session.execute(stmt)
        wallet = result.scalar_one()
        
        wallet.balance = float(wallet.balance) + amount
        
        tx = Transaction(
            wallet_id=wallet.id,
            amount=amount,
            transaction_type=t_type,
            reference_id=reference_id,
            description=description,
            status="COMPLETED"
        )
        self.session.add(tx)
        await self.session.flush()
        return tx
