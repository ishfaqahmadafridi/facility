from pydantic_settings import BaseSettings
from typing import List


class Settings(BaseSettings):
    # ── App ────────────────────────────────────────────────────────
    PROJECT_NAME: str = "SUPERAPP Pakistan"
    ENVIRONMENT: str = "development"
    DEBUG: bool = True
    API_V1_PREFIX: str = "/api/v1"

    # ── PostgreSQL ─────────────────────────────────────────────────
    DATABASE_URL: str                       # asyncpg URL
    DATABASE_URL_SYNC: str                  # used by Alembic only

    # ── Redis ──────────────────────────────────────────────────────
    REDIS_URL: str

    # ── JWT Auth ───────────────────────────────────────────────────
    SECRET_KEY: str
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 1440
    REFRESH_TOKEN_EXPIRE_DAYS: int = 30

    # ── SMS / OTP ──────────────────────────────────────────────────
    SMS_PROVIDER: str = "console"           # "console" | "twilio"
    TWILIO_ACCOUNT_SID: str = ""
    TWILIO_AUTH_TOKEN: str = ""
    TWILIO_PHONE_NUMBER: str = ""

    # ── Storage ────────────────────────────────────────────────────
    STORAGE_BACKEND: str = "local"          # "local" | "s3"
    S3_BUCKET_NAME: str = ""
    S3_REGION: str = "ap-south-1"
    AWS_ACCESS_KEY_ID: str = ""
    AWS_SECRET_ACCESS_KEY: str = ""
    LOCAL_UPLOAD_DIR: str = "uploads"

    # ── CORS ───────────────────────────────────────────────────────
    ALLOWED_ORIGINS: str = "http://localhost:3000"

    def get_allowed_origins(self) -> List[str]:
        return [o.strip() for o in self.ALLOWED_ORIGINS.split(",")]

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"
        extra = "ignore"

settings = Settings()
