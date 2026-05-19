"""
app/modules/roadside/schemas.py
──────────────────────────────────────────────────────────────────
Pydantic schemas for Roadside Requests.
"""
import uuid
from typing import Optional
from datetime import datetime
from pydantic import BaseModel

class RoadsideCreateRequest(BaseModel):
    issue_type: str
    lat: float
    lng: float
    address: str
    notes: Optional[str] = None

class RoadsideResponseSchema(BaseModel):
    id: uuid.UUID
    customer_id: uuid.UUID
    provider_id: Optional[uuid.UUID] = None
    issue_type: str
    address: str
    status: str
    notes: Optional[str] = None
    created_at: datetime
    
    class Config:
        from_attributes = True

class RoadsideStatusUpdate(BaseModel):
    status: str
