"""
app/modules/wallet/schemas.py
──────────────────────────────────────────────────────────────────
Pydantic schemas for Wallet APIs.
"""
import uuid
from typing import Optional, List
from datetime import datetime
from pydantic import BaseModel

class TransactionResponseSchema(BaseModel):
    id: uuid.UUID
    amount: float
    transaction_type: str
    reference_id: Optional[uuid.UUID]
    description: Optional[str]
    status: str
    created_at: datetime
    
    class Config:
        from_attributes = True

class WalletResponseSchema(BaseModel):
    id: uuid.UUID
    user_id: uuid.UUID
    balance: float
    currency: str
    
    class Config:
        from_attributes = True

class TopUpRequest(BaseModel):
    amount: float
    payment_method: str = "EASYPAISA" # EASYPAISA, JAZZCASH, CARD
