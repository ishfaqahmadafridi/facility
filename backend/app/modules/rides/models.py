"""
app/modules/rides/models.py
──────────────────────────────────────────────────────────────────
SQLAlchemy models for Rides and Negotiation Bids.
"""
import uuid
from sqlalchemy import String, Numeric, Text, ForeignKey, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship
from geoalchemy2 import Geometry

from app.db.base import Base, UUIDPrimaryKeyMixin, TimestampMixin, SoftDeleteMixin

class Ride(Base, UUIDPrimaryKeyMixin, TimestampMixin, SoftDeleteMixin):
    __tablename__ = "rides"

    customer_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id"), index=True, nullable=False)
    driver_id: Mapped[uuid.UUID | None] = mapped_column(ForeignKey("providers.user_id"), index=True, nullable=True)

    pickup_location = mapped_column(Geometry('POINT', srid=4326), nullable=False)
    dropoff_location = mapped_column(Geometry('POINT', srid=4326), nullable=False)
    
    pickup_address: Mapped[str] = mapped_column(Text, nullable=False)
    dropoff_address: Mapped[str] = mapped_column(Text, nullable=False)
    
    status: Mapped[str] = mapped_column(Text, index=True, server_default="REQUESTED", nullable=False)
    ride_type: Mapped[str] = mapped_column(Text, server_default="STANDARD", nullable=False) # e.g. MINI, AUTO, BIKE
    
    distance_km: Mapped[float] = mapped_column(Numeric(6, 2), nullable=False)
    estimated_price: Mapped[float] = mapped_column(Numeric(10, 2), nullable=False)
    final_price: Mapped[float | None] = mapped_column(Numeric(10, 2), nullable=True)
    
    started_at: Mapped[DateTime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    completed_at: Mapped[DateTime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    bids = relationship("RideBid", back_populates="ride", cascade="all, delete-orphan")


class RideBid(Base, UUIDPrimaryKeyMixin, TimestampMixin):
    __tablename__ = "ride_bids"

    ride_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("rides.id", ondelete="CASCADE"), index=True, nullable=False)
    driver_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("providers.user_id"), index=True, nullable=False)
    
    bid_amount: Mapped[float] = mapped_column(Numeric(10, 2), nullable=False)
    status: Mapped[str] = mapped_column(Text, server_default="PENDING", nullable=False) # PENDING, ACCEPTED, REJECTED
    
    ride = relationship("Ride", back_populates="bids")
