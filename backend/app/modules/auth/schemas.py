"""
app/modules/auth/schemas.py
──────────────────────────────────────────────────────────────────
Pydantic schemas for Auth API.
"""
import uuid
from typing import List, Optional
from pydantic import BaseModel, Field, constr


class OTPRequest(BaseModel):
    # E.g. +923001234567
    phone: str = Field(..., description="Phone number in E.164 format", examples=["+923001234567"])


class OTPVerify(BaseModel):
    phone: str = Field(..., description="Phone number in E.164 format", examples=["+923001234567"])
    code: str = Field(..., min_length=6, max_length=6, description="6-digit OTP code")


class RefreshTokenRequest(BaseModel):
    refresh_token: str


class UserPayload(BaseModel):
    id: uuid.UUID
    phone: str
    roles: List[str]
    status: str
    preferred_lang: str


class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "Bearer"
    user: UserPayload
