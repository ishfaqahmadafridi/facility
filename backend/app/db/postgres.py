"""
app/db/postgres.py
──────────────────────────────────────────────────────────────────
Async SQLAlchemy engine, session factory, and FastAPI dependency.

Usage in a route:
    async def my_route(db: AsyncSession = Depends(get_db)):
        ...
"""
from contextlib import asynccontextmanager
from typing import AsyncGenerator

from sqlalchemy.ext.asyncio import (
    AsyncSession,
    async_sessionmaker,
    create_async_engine,
)

from app.core.config import settings

# ── Engine ─────────────────────────────────────────────────────────
engine = create_async_engine(
    settings.DATABASE_URL,
    echo=settings.DEBUG,       # logs SQL in development
    pool_size=10,
    max_overflow=20,
    pool_pre_ping=True,        # detect stale connections
    pool_recycle=3600,         # recycle connections after 1 hour
)

# ── Session factory ────────────────────────────────────────────────
AsyncSessionLocal = async_sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False,    # keep objects usable after commit
    autoflush=False,
    autocommit=False,
)


# ── FastAPI dependency ─────────────────────────────────────────────
async def get_db() -> AsyncGenerator[AsyncSession, None]:
    """
    Yields an async database session.
    Always rolls back on exception; always closes after request.
    """
    async with AsyncSessionLocal() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
        finally:
            await session.close()


# ── Context manager (for background tasks / scripts) ───────────────
@asynccontextmanager
async def get_db_context() -> AsyncGenerator[AsyncSession, None]:
    """Use this outside of FastAPI routes (e.g. Celery tasks)."""
    async with AsyncSessionLocal() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
        finally:
            await session.close()
