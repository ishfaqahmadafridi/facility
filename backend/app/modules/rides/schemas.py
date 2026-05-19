"""
app/modules/rides/schemas.py
──────────────────────────────────────────────────────────────────
Pydantic schemas for Rides.
"""
import uuid
from typing import Optional, List
from datetime import datetime
from pydantic import BaseModel, Field

class LocationPoint(BaseModel):
    lat: float
    lng: float
    address: str

class RideCreateRequest(BaseModel):
    pickup: LocationPoint
    dropoff: LocationPoint
    ride_type: str = "STANDARD"
    estimated_price: float
    distance_km: float

class BidResponseSchema(BaseModel):
    id: uuid.UUID
    driver_id: uuid.UUID
    bid_amount: float
    status: str
    created_at: datetime
    
    class Config:
        from_attributes = True

class RideResponseSchema(BaseModel):
    id: uuid.UUID
    customer_id: uuid.UUID
    driver_id: Optional[uuid.UUID] = None
    status: str
    ride_type: str
    distance_km: float
    estimated_price: float
    final_price: Optional[float] = None
    pickup_address: str
    dropoff_address: str
    created_at: datetime
    
    bids: Optional[List[BidResponseSchema]] = []
    
    class Config:
        from_attributes = True

class BidCreateRequest(BaseModel):
    ride_id: uuid.UUID
    bid_amount: float

class RideStatusUpdate(BaseModel):
    status: str
