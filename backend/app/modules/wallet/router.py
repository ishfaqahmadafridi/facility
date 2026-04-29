"""
app/modules/wallet/router.py
──────────────────────────────────────────────────────────────────
REST endpoints for Wallet.
"""
from typing import List
from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.postgres import get_db
from app.core.deps import get_current_user
from app.modules.users.models import User
from app.modules.wallet.schemas import WalletResponseSchema, TransactionResponseSchema, TopUpRequest
from app.modules.wallet.repository import WalletRepository
from app.modules.wallet.service import WalletService

router = APIRouter(tags=["Wallet"])

def get_wallet_service(session: AsyncSession = Depends(get_db)) -> WalletService:
    return WalletService(WalletRepository(session))

@router.get("/wallet", response_model=WalletResponseSchema)
async def get_wallet(
    current_user: User = Depends(get_current_user),
    service: WalletService = Depends(get_wallet_service)
):
    return await service.get_or_create_wallet(current_user.id)

@router.get("/wallet/transactions", response_model=List[TransactionResponseSchema])
async def get_transactions(
    current_user: User = Depends(get_current_user),
    service: WalletService = Depends(get_wallet_service)
):
    return await service.get_transactions(current_user.id)

@router.post("/wallet/topup", response_model=TransactionResponseSchema)
async def top_up(
    data: TopUpRequest,
    current_user: User = Depends(get_current_user),
    service: WalletService = Depends(get_wallet_service)
):
    return await service.top_up(current_user.id, data.amount, data.payment_method)
