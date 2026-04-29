"""
app/modules/ratings/service.py
──────────────────────────────────────────────────────────────────
Business logic for Ratings.
"""
import uuid

from app.modules.ratings.repository import RatingRepository
from app.modules.ratings.models import Rating
from app.modules.ratings.schemas import RatingCreateRequest, AggregatedRatingSchema
from app.common.exceptions import ConflictException

class RatingService:
    def __init__(self, repo: RatingRepository):
        self.repo = repo

    async def submit_rating(self, reviewer_id: uuid.UUID, data: RatingCreateRequest) -> Rating:
        # Check if already rated
        existing = await self.repo.get_rating_by_reference(reviewer_id, data.reference_id)
        if existing:
            raise ConflictException("You have already rated this job/ride.")

        rating = Rating(
            reviewer_id=reviewer_id,
            reviewee_id=data.reviewee_id,
            reference_id=data.reference_id,
            reference_type=data.reference_type,
            score=data.score,
            feedback=data.feedback
        )
        
        # We could trigger Kafka event here to update provider_profiles avg_rating async
        # For now, we just save the rating.
        return await self.repo.create_rating(rating)

    async def get_user_rating_summary(self, user_id: uuid.UUID) -> AggregatedRatingSchema:
        avg_score, total = await self.repo.get_aggregated_rating(user_id)
        return AggregatedRatingSchema(
            user_id=user_id,
            average_score=round(avg_score, 1),
            total_reviews=total
        )
