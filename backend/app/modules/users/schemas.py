"""
app/modules/users/schemas.py
──────────────────────────────────────────────────────────────────
Pydantic schemas for User API.
"""
import uuid
from typing import List, Optional
from datetime import datetime
from pydantic import BaseModel, Field

class UserProfile(BaseModel):
    id: uuid.UUID
    phone: str
    full_name: Optional[str] = None
    roles: List[str]
    status: str
    wallet_balance: float
    preferred_lang: str
    avatar_url: Optional[str] = None
    created_at: datetime
    
    class Config:
        from_attributes = True

class UserUpdate(BaseModel):
    full_name: Optional[str] = None
    preferred_lang: Optional[str] = None
    
class RoleUpdate(BaseModel):
    roles: List[str]
