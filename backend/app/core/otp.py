"""
app/core/otp.py
──────────────────────────────────────────────────────────────────
Async OTP generation and Redis-backed storage.
"""
import random
from app.db.redis import redis_client
from app.common.constants import OTPConstants

async def generate_otp() -> str:
    """Generates a random N-digit OTP."""
    # Ensure it's exactly the length specified, padding with leading zeros if necessary
    otp = "".join([str(random.randint(0, 9)) for _ in range(OTPConstants.LENGTH)])
    return otp

async def save_otp_async(phone: str, otp: str) -> None:
    """Saves OTP to Redis with a TTL."""
    key = f"{OTPConstants.REDIS_PREFIX}{phone}"
    await redis_client.setex(key, OTPConstants.EXPIRE_SECONDS, otp)

async def get_otp_async(phone: str) -> str | None:
    """Retrieves OTP from Redis."""
    key = f"{OTPConstants.REDIS_PREFIX}{phone}"
    return await redis_client.get(key)

async def delete_otp_async(phone: str) -> None:
    """Deletes OTP from Redis after successful verification."""
    key = f"{OTPConstants.REDIS_PREFIX}{phone}"
    await redis_client.delete(key)

async def check_rate_limit(phone: str) -> bool:
    """
    Checks if an OTP was requested too recently.
    Returns True if allowed, False if rate limited.
    """
    rl_key = f"rl:otp:{phone}"
    exists = await redis_client.exists(rl_key)
    if exists:
        return False
    # Set a rate limit key for the window duration
    await redis_client.setex(rl_key, OTPConstants.RATE_LIMIT_WINDOW, "1")
    return True
