"""
app/modules/users/models.py
──────────────────────────────────────────────────────────────────
SQLAlchemy model for User.
"""
from sqlalchemy import String, Text, Numeric
from sqlalchemy.dialects.postgresql import ARRAY
from sqlalchemy.orm import Mapped, mapped_column

from app.db.base import Base, UUIDPrimaryKeyMixin, TimestampMixin, SoftDeleteMixin


class User(Base, UUIDPrimaryKeyMixin, TimestampMixin, SoftDeleteMixin):
    __tablename__ = "users"

    phone: Mapped[str] = mapped_column(String(20), unique=True, index=True, nullable=False)
    full_name: Mapped[str | None] = mapped_column(String(120), nullable=True)
    
    # roles array (CUSTOMER, PROVIDER, ADMIN)
    roles: Mapped[list[str]] = mapped_column(ARRAY(Text), server_default="{'CUSTOMER'}", nullable=False)
    
    status: Mapped[str] = mapped_column(Text, index=True, server_default="ACTIVE", nullable=False)
    wallet_balance: Mapped[float] = mapped_column(Numeric(12, 2), server_default="0.00", nullable=False)
    preferred_lang: Mapped[str] = mapped_column(Text, server_default="en", nullable=False)
    
    fcm_token: Mapped[str | None] = mapped_column(Text, nullable=True)
    avatar_url: Mapped[str | None] = mapped_column(Text, nullable=True)

    def __repr__(self) -> str:
        return f"<User(id={self.id}, phone={self.phone}, roles={self.roles})>"
