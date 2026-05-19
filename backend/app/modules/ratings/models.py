"""
app/modules/ratings/models.py
──────────────────────────────────────────────────────────────────
SQLAlchemy models for Ratings & Reviews.
"""
import uuid
from sqlalchemy import String, Numeric, Text, ForeignKey, Integer, CheckConstraint
from sqlalchemy.orm import Mapped, mapped_column

from app.db.base import Base, UUIDPrimaryKeyMixin, TimestampMixin

class Rating(Base, UUIDPrimaryKeyMixin, TimestampMixin):
    """
    Stores ratings for both Providers (by Customers) and Customers (by Providers).
    """
    __tablename__ = "ratings"

    reviewer_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id"), index=True, nullable=False)
    reviewee_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id"), index=True, nullable=False)
    
    reference_id: Mapped[uuid.UUID] = mapped_column(index=True, nullable=False) # e.g. Ride ID, Booking ID
    reference_type: Mapped[str] = mapped_column(String(50), nullable=False) # RIDE, BOOKING, ROADSIDE
    
    score: Mapped[int] = mapped_column(Integer, nullable=False)
    feedback: Mapped[str | None] = mapped_column(Text, nullable=True)

    __table_args__ = (
        CheckConstraint('score >= 1 AND score <= 5', name='check_valid_score'),
    )
