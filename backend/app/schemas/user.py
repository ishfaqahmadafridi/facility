from typing import Optional, List
from pydantic import BaseModel, EmailStr, Field
from datetime import datetime

class UserBase(BaseModel):
    phone: Optional[str] = None
    email: EmailStr
    role: str = "Customer"
    is_verified: bool = False

class ProviderVerificationGate(BaseModel):
    hcs_verified: bool = False
    pnmc_id: Optional[str] = None
    experience_years: int = 0

class ProfileData(BaseModel):
    name: str
    avatar_url: Optional[str] = None
    location: Optional[dict] = None

class User(UserBase):
    id: str = Field(alias="_id")
    verification_gate: Optional[ProviderVerificationGate] = None
    profile_data: Optional[ProfileData] = None
    created_at: datetime = Field(default_factory=datetime.utcnow)

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    email: Optional[str] = None
    role: Optional[str] = None
