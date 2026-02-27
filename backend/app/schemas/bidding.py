from typing import List, Optional
from pydantic import BaseModel, Field
from datetime import datetime

class BidBase(BaseModel):
    request_id: str
    price: float
    eta: Optional[str] = None # Estimated Time of Arrival (useful for mechanics)
    message: Optional[str] = None

class Bid(BidBase):
    bid_id: str = Field(alias="_id")
    provider_id: str
    provider_name: str
    provider_experience: int
    status: str = "Pending" # Pending, Accepted, Rejected, Completed
    created_at: datetime = Field(default_factory=datetime.utcnow)

class ServiceRequestBase(BaseModel):
    category: str # Worker, Mechanic, Nurse
    sub_category: str # Painter, Car, Injection, etc.
    description: str
    budget: Optional[float] = None
    location: dict # GeoJSON Point

class ServiceRequest(ServiceRequestBase):
    request_id: str = Field(alias="_id")
    customer_id: str
    status: str = "Open" # Open, In-Progress, Completed, Cancelled
    created_at: datetime = Field(default_factory=datetime.utcnow)
