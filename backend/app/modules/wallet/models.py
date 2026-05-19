"""
app/modules/wallet/models.py
──────────────────────────────────────────────────────────────────
SQLAlchemy models for Wallet and Ledger Transactions.
"""
import uuid
from sqlalchemy import String, Numeric, Text, ForeignKey, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base, UUIDPrimaryKeyMixin, TimestampMixin

class Wallet(Base, UUIDPrimaryKeyMixin, TimestampMixin):
    __tablename__ = "wallets"

    user_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id"), index=True, unique=True, nullable=False)
    balance: Mapped[float] = mapped_column(Numeric(12, 2), server_default="0.00", nullable=False)
    currency: Mapped[str] = mapped_column(String(3), server_default="PKR", nullable=False)
    
    transactions = relationship("Transaction", back_populates="wallet", cascade="all, delete-orphan")


class Transaction(Base, UUIDPrimaryKeyMixin, TimestampMixin):
    """
    Immutable ledger entry.
    """
    __tablename__ = "transactions"

    wallet_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("wallets.id"), index=True, nullable=False)
    
    amount: Mapped[float] = mapped_column(Numeric(10, 2), nullable=False) # Can be negative
    transaction_type: Mapped[str] = mapped_column(String(50), nullable=False) # TOP_UP, RIDE_PAYMENT, COMMISSION, WITHDRAWAL
    reference_id: Mapped[uuid.UUID | None] = mapped_column(ForeignKey("rides.id"), nullable=True) # e.g. Ride ID
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    
    status: Mapped[str] = mapped_column(String(20), server_default="COMPLETED", nullable=False) # PENDING, COMPLETED, FAILED

    wallet = relationship("Wallet", back_populates="transactions")
