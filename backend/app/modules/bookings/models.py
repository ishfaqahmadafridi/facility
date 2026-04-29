"""
app/modules/bookings/models.py
──────────────────────────────────────────────────────────────────
SQLAlchemy models for Home Services Bookings (Nurse, Repairs).
"""
import uuid
from sqlalchemy import String, Numeric, Text, ForeignKey, DateTime
from sqlalchemy.orm import Mapped, mapped_column
from geoalchemy2 import Geometry

from app.db.base import Base, UUIDPrimaryKeyMixin, TimestampMixin, SoftDeleteMixin

class Booking(Base, UUIDPrimaryKeyMixin, TimestampMixin, SoftDeleteMixin):
    __tablename__ = "bookings"

    customer_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id"), index=True, nullable=False)
    provider_id: Mapped[uuid.UUID | None] = mapped_column(ForeignKey("providers.user_id"), index=True, nullable=True)

    vertical: Mapped[str] = mapped_column(Text, index=True, nullable=False) # e.g. MEDICAL, HOME_REPAIR
    service_type: Mapped[str] = mapped_column(Text, nullable=False) # e.g. IV_DRIP, PLUMBING
    
    location = mapped_column(Geometry('POINT', srid=4326), nullable=False)
    address: Mapped[str] = mapped_column(Text, nullable=False)
    
    status: Mapped[str] = mapped_column(Text, index=True, server_default="SEARCHING", nullable=False)
    
    scheduled_for: Mapped[DateTime | None] = mapped_column(DateTime(timezone=True), nullable=True) # If null, ASAP
    
    price: Mapped[float] = mapped_column(Numeric(10, 2), nullable=False) # Fixed price or agreed quote
    
    notes: Mapped[str | None] = mapped_column(Text, nullable=True)
    
    started_at: Mapped[DateTime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    completed_at: Mapped[DateTime | None] = mapped_column(DateTime(timezone=True), nullable=True)
