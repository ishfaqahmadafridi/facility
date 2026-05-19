"""
app/modules/providers/schemas.py
──────────────────────────────────────────────────────────────────
Pydantic schemas for Provider API.
"""
import uuid
from typing import List, Optional
from datetime import datetime
from pydantic import BaseModel, Field


class ProviderProfileBase(BaseModel):
    user_id: uuid.UUID
    cnic: str
    vertical: str
    is_verified: bool
    approval_status: str
    rating: float
    total_jobs: int
    is_online: bool
    last_online: Optional[datetime] = None
    skills: Optional[List[str]] = None
    geo_hash: Optional[str] = None
    created_at: datetime
    
    class Config:
        from_attributes = True


class ProviderRegistrationRequest(BaseModel):
    cnic: str = Field(..., description="13-digit CNIC format")
    vertical: str = Field(..., description="RIDE, MEDICAL, ROADSIDE, or HOME_REPAIR")
    skills: Optional[List[str]] = None


class ProviderStatusUpdate(BaseModel):
    is_online: bool


class LocationUpdate(BaseModel):
    latitude: float
    longitude: float
