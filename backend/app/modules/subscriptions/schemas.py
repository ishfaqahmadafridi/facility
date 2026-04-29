"""
app/modules/subscriptions/schemas.py
──────────────────────────────────────────────────────────────────
Pydantic schemas for Subscriptions.
"""
import uuid
from typing import Optional, List
from datetime import datetime
from pydantic import BaseModel

class SubscriptionPlanSchema(BaseModel):
    id: uuid.UUID
    name: str
    description: str
    vertical: str
    price: float
    visits_per_month: int
    duration_days: int
    
    class Config:
        from_attributes = True

class UserSubscriptionSchema(BaseModel):
    id: uuid.UUID
    user_id: uuid.UUID
    plan_id: uuid.UUID
    start_date: datetime
    end_date: datetime
    visits_remaining: int
    status: str
    
    class Config:
        from_attributes = True

class SubscribeRequest(BaseModel):
    plan_id: uuid.UUID
    # Payment details would be here or in a separate payment flow
