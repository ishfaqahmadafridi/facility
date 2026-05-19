"""
app/modules/providers/models.py
──────────────────────────────────────────────────────────────────
SQLAlchemy model for Provider Profile.
"""
import uuid
from datetime import datetime
from sqlalchemy import String, Boolean, Numeric, Integer, DateTime, Text, ForeignKey
from sqlalchemy.dialects.postgresql import ARRAY
from sqlalchemy.orm import Mapped, mapped_column, relationship
from geoalchemy2 import Geometry

from app.db.base import Base, TimestampMixin, SoftDeleteMixin


class ProviderProfile(Base, TimestampMixin, SoftDeleteMixin):
    __tablename__ = "providers"

    # We use user_id as the primary key for a 1:1 relationship
    user_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    
    cnic: Mapped[str] = mapped_column(String(20), unique=True, index=True, nullable=False)
    vertical: Mapped[str] = mapped_column(Text, index=True, nullable=False)  # RIDE, MEDICAL, ROADSIDE, HOME_REPAIR
    
    is_verified: Mapped[bool] = mapped_column(Boolean, server_default="false", nullable=False)
    approval_status: Mapped[str] = mapped_column(Text, index=True, server_default="PENDING", nullable=False)
    
    rating: Mapped[float] = mapped_column(Numeric(3, 2), server_default="5.00", nullable=False)
    total_jobs: Mapped[int] = mapped_column(Integer, server_default="0", nullable=False)
    
    # PostGIS Location
    location = mapped_column(Geometry('POINT', srid=4326), nullable=True)
    geo_hash: Mapped[str | None] = mapped_column(String(20), index=True, nullable=True)
    
    is_online: Mapped[bool] = mapped_column(Boolean, server_default="false", index=True, nullable=False)
    last_online: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    
    skills: Mapped[list[str] | None] = mapped_column(ARRAY(String), nullable=True)

    def __repr__(self) -> str:
        return f"<ProviderProfile(user_id={self.user_id}, vertical={self.vertical}, status={self.approval_status})>"
