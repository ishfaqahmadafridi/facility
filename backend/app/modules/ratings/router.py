"""
app/modules/ratings/router.py
──────────────────────────────────────────────────────────────────
REST endpoints for Ratings.
"""
import uuid
from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.postgres import get_db
from app.core.deps import get_current_user
from app.modules.users.models import User
from app.modules.ratings.schemas import RatingCreateRequest, RatingResponseSchema, AggregatedRatingSchema
from app.modules.ratings.repository import RatingRepository
from app.modules.ratings.service import RatingService

router = APIRouter(tags=["Ratings"])

def get_rating_service(session: AsyncSession = Depends(get_db)) -> RatingService:
    return RatingService(RatingRepository(session))

@router.post("/ratings", response_model=RatingResponseSchema, status_code=status.HTTP_201_CREATED)
async def submit_rating(
    data: RatingCreateRequest,
    current_user: User = Depends(get_current_user),
    service: RatingService = Depends(get_rating_service)
):
    return await service.submit_rating(current_user.id, data)

@router.get("/users/{user_id}/ratings/summary", response_model=AggregatedRatingSchema)
async def get_user_rating_summary(
    user_id: uuid.UUID,
    service: RatingService = Depends(get_rating_service)
):
    return await service.get_user_rating_summary(user_id)
