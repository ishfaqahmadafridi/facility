"""
app/modules/ratings/schemas.py
──────────────────────────────────────────────────────────────────
Pydantic schemas for Ratings APIs.
"""
import uuid
from typing import Optional
from datetime import datetime
from pydantic import BaseModel, Field

class RatingCreateRequest(BaseModel):
    reviewee_id: uuid.UUID
    reference_id: uuid.UUID
    reference_type: str = Field(..., description="E.g., RIDE, BOOKING, ROADSIDE")
    score: int = Field(..., ge=1, le=5)
    feedback: Optional[str] = None

class RatingResponseSchema(BaseModel):
    id: uuid.UUID
    reviewer_id: uuid.UUID
    reviewee_id: uuid.UUID
    reference_id: uuid.UUID
    reference_type: str
    score: int
    feedback: Optional[str]
    created_at: datetime
    
    class Config:
        from_attributes = True

class AggregatedRatingSchema(BaseModel):
    user_id: uuid.UUID
    average_score: float
    total_reviews: int
