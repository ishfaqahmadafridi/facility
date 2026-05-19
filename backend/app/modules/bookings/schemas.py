"""
app/modules/bookings/schemas.py
──────────────────────────────────────────────────────────────────
Pydantic schemas for Bookings.
"""
import uuid
from typing import Optional
from datetime import datetime
from pydantic import BaseModel

class BookingCreateRequest(BaseModel):
    vertical: str
    service_type: str
    lat: float
    lng: float
    address: str
    price: float
    notes: Optional[str] = None
    scheduled_for: Optional[datetime] = None

class BookingResponseSchema(BaseModel):
    id: uuid.UUID
    customer_id: uuid.UUID
    provider_id: Optional[uuid.UUID] = None
    vertical: str
    service_type: str
    address: str
    status: str
    price: float
    notes: Optional[str] = None
    scheduled_for: Optional[datetime] = None
    created_at: datetime
    
    class Config:
        from_attributes = True

class BookingStatusUpdate(BaseModel):
    status: str
