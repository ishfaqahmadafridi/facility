"""
app/modules/ratings/repository.py
──────────────────────────────────────────────────────────────────
Database operations for Ratings.
"""
import uuid
from typing import Optional, Tuple
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession

from app.modules.ratings.models import Rating

class RatingRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def create_rating(self, rating: Rating) -> Rating:
        self.session.add(rating)
        await self.session.flush()
        return rating

    async def get_rating_by_reference(self, reviewer_id: uuid.UUID, reference_id: uuid.UUID) -> Optional[Rating]:
        stmt = select(Rating).where(
            Rating.reviewer_id == reviewer_id,
            Rating.reference_id == reference_id
        )
        result = await self.session.execute(stmt)
        return result.scalar_one_or_none()

    async def get_aggregated_rating(self, user_id: uuid.UUID) -> Tuple[float, int]:
        """Returns (average_score, total_reviews) for a user."""
        stmt = select(
            func.coalesce(func.avg(Rating.score), 0.0),
            func.count(Rating.id)
        ).where(Rating.reviewee_id == user_id)
        
        result = await self.session.execute(stmt)
        row = result.first()
        return (float(row[0]), int(row[1])) if row else (0.0, 0)
