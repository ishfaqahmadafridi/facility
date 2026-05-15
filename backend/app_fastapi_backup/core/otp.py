import random
import redis
from app.core.config import settings

# Memory fallback for environments without Redis
_memory_otp = {}

try:
    redis_client = redis.from_url(settings.REDIS_URL, decode_responses=True)
    redis_client.ping()
    USE_REDIS = True
except Exception:
    print("Warning: Redis not found. Using memory fallback for OTP.")
    USE_REDIS = False

def generate_otp():
    return "".join([str(random.randint(0, 9)) for _ in range(6)])

def save_otp(email: str, otp: str):
    if USE_REDIS:
        redis_client.setex(f"otp:{email}", 300, otp)
    else:
        _memory_otp[f"otp:{email}"] = (otp, __import__("time").time() + 300)

def get_otp(email: str):
    if USE_REDIS:
        return redis_client.get(f"otp:{email}")
    else:
        data = _memory_otp.get(f"otp:{email}")
        if data:
            val, expiry = data
            if __import__("time").time() < expiry:
                return val
            del _memory_otp[f"otp:{email}"]
        return None

def delete_otp(email: str):
    if USE_REDIS:
        redis_client.delete(f"otp:{email}")
    else:
        _memory_otp.pop(f"otp:{email}", None)
