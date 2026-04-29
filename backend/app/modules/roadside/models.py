"""
app/modules/roadside/models.py
──────────────────────────────────────────────────────────────────
SQLAlchemy models for Roadside Assistance Emergencies.
"""
import uuid
from sqlalchemy import String, Numeric, Text, ForeignKey, DateTime
from sqlalchemy.orm import Mapped, mapped_column
from geoalchemy2 import Geometry

from app.db.base import Base, UUIDPrimaryKeyMixin, TimestampMixin, SoftDeleteMixin

class RoadsideRequest(Base, UUIDPrimaryKeyMixin, TimestampMixin, SoftDeleteMixin):
    __tablename__ = "roadside_requests"

    customer_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id"), index=True, nullable=False)
    provider_id: Mapped[uuid.UUID | None] = mapped_column(ForeignKey("providers.user_id"), index=True, nullable=True)

    issue_type: Mapped[str] = mapped_column(Text, nullable=False) # e.g. FLAT_TIRE, BATTERY_JUMP, TOWING
    
    location = mapped_column(Geometry('POINT', srid=4326), nullable=False)
    address: Mapped[str] = mapped_column(Text, nullable=False)
    
    status: Mapped[str] = mapped_column(Text, index=True, server_default="SEARCHING", nullable=False)
    
    notes: Mapped[str | None] = mapped_column(Text, nullable=True)
    
    started_at: Mapped[DateTime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    completed_at: Mapped[DateTime | None] = mapped_column(DateTime(timezone=True), nullable=True)
