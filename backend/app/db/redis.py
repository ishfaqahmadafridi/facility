"""
app/db/redis.py
──────────────────────────────────────────────────────────────────
Async Redis client with graceful fallback.

Exposes:
    redis_client  — the raw async Redis instance
    get_redis()   — FastAPI dependency
    RedisService  — higher-level typed helpers used across modules
"""
from typing import Any, Optional

import redis.asyncio as aioredis

from app.core.config import settings

# ── Client singleton ───────────────────────────────────────────────
redis_client: aioredis.Redis = aioredis.from_url(
    settings.REDIS_URL,
    encoding="utf-8",
    decode_responses=True,
)


# ── FastAPI dependency ─────────────────────────────────────────────
async def get_redis() -> aioredis.Redis:
    return redis_client


# ── Health check ───────────────────────────────────────────────────
async def ping_redis() -> bool:
    try:
        return await redis_client.ping()
    except Exception:
        return False
