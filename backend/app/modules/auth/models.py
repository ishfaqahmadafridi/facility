"""
app/modules/auth/models.py
──────────────────────────────────────────────────────────────────
SQLAlchemy models for OTP sessions and Refresh Tokens.
"""
import uuid
from datetime import datetime

from sqlalchemy import String, DateTime, SmallInteger, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column

from app.db.base import Base, UUIDPrimaryKeyMixin


class OTPSession(Base, UUIDPrimaryKeyMixin):
    __tablename__ = "otp_sessions"

    phone: Mapped[str] = mapped_column(String(20), index=True, nullable=False)
    attempts: Mapped[int] = mapped_column(SmallInteger, default=0, nullable=False)
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    verified_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)


class RefreshToken(Base, UUIDPrimaryKeyMixin):
    __tablename__ = "refresh_tokens"

    user_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), index=True, nullable=False)
    token_hash: Mapped[str] = mapped_column(String(256), unique=True, nullable=False)
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    revoked_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)

    @property
    def is_valid(self) -> bool:
        return self.revoked_at is None and self.expires_at > datetime.utcnow()
