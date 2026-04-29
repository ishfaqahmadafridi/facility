"""
app/modules/subscriptions/models.py
──────────────────────────────────────────────────────────────────
SQLAlchemy models for Subscriptions (e.g. Nurse Home Care Plans).
"""
import uuid
from sqlalchemy import String, Numeric, Text, ForeignKey, DateTime, Integer
from sqlalchemy.orm import Mapped, mapped_column

from app.db.base import Base, UUIDPrimaryKeyMixin, TimestampMixin

class SubscriptionPlan(Base, UUIDPrimaryKeyMixin, TimestampMixin):
    __tablename__ = "subscription_plans"

    name: Mapped[str] = mapped_column(String(100), nullable=False) # e.g. "Monthly Elderly Care"
    description: Mapped[str] = mapped_column(Text, nullable=False)
    vertical: Mapped[str] = mapped_column(String(50), nullable=False) # e.g. MEDICAL
    price: Mapped[float] = mapped_column(Numeric(10, 2), nullable=False)
    visits_per_month: Mapped[int] = mapped_column(Integer, nullable=False)
    duration_days: Mapped[int] = mapped_column(Integer, nullable=False, server_default="30")


class UserSubscription(Base, UUIDPrimaryKeyMixin, TimestampMixin):
    __tablename__ = "user_subscriptions"

    user_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id"), index=True, nullable=False)
    plan_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("subscription_plans.id"), index=True, nullable=False)
    
    start_date: Mapped[DateTime] = mapped_column(DateTime(timezone=True), nullable=False)
    end_date: Mapped[DateTime] = mapped_column(DateTime(timezone=True), nullable=False)
    
    visits_remaining: Mapped[int] = mapped_column(Integer, nullable=False)
    status: Mapped[str] = mapped_column(String(20), server_default="ACTIVE", nullable=False) # ACTIVE, EXPIRED, CANCELLED
