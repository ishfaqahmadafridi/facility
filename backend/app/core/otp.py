import random
import redis
from app.core.config import settings

redis_client = redis.from_url(settings.REDIS_URL, decode_responses=True)

def generate_otp():
    return "".join([str(random.randint(0, 9)) for _ in range(6)])

def save_otp(email: str, otp: str):
    # Store OTP in Redis with 5-minute expiration
    redis_client.setex(f"otp:{email}", 300, otp)

def get_otp(email: str):
    return redis_client.get(f"otp:{email}")

def delete_otp(email: str):
    redis_client.delete(f"otp:{email}")
