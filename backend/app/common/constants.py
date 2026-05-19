"""
app/common/constants.py
──────────────────────────────────────────────────────────────────
System-wide constants. Never use magic numbers in service files.
"""


class OTPConstants:
    LENGTH           = 6
    EXPIRE_SECONDS   = 300     # 5 minutes
    MAX_ATTEMPTS     = 5
    RATE_LIMIT_WINDOW = 60     # 1 minute between new OTP requests
    REDIS_PREFIX     = "otp:"


class JWTConstants:
    TOKEN_TYPE       = "Bearer"
    REFRESH_PREFIX   = "refresh:"


class LocationConstants:
    UPDATE_INTERVAL_SECONDS  = 4       # how often provider sends GPS
    BROADCAST_INTERVAL_SECONDS = 4    # how often server sends to customer
    DRIVER_CACHE_TTL_SECONDS = 30     # Redis TTL for driver location
    GEO_KEY                  = "driver:locations"  # Redis geo set key


class MatchingConstants:
    DEFAULT_RADIUS_KM     = 5.0
    BROADCAST_TOP_N       = 10
    BID_TIMEOUT_SECONDS   = 30    # provider must respond within 30s

    # Score weights (must sum to 100)
    WEIGHT_DISTANCE       = 40
    WEIGHT_RATING         = 30
    WEIGHT_RESPONSE_RATE  = 20
    WEIGHT_SKILL_MATCH    = 10

    # Emergency (Roadside) override weights
    EMERGENCY_WEIGHT_DISTANCE = 70
    EMERGENCY_RADIUS_START_KM = 3.0
    EMERGENCY_RADIUS_EXPAND_KM = 2.0   # expand every 30s
    EMERGENCY_EXPAND_INTERVAL  = 30    # seconds


class WalletConstants:
    MIN_TOPUP_AMOUNT      = 100    # PKR
    MAX_TOPUP_AMOUNT      = 50000  # PKR
    COMMISSION_RATE       = 0.10   # 10% platform commission


class PaginationConstants:
    DEFAULT_PAGE      = 1
    DEFAULT_PAGE_SIZE = 20
    MAX_PAGE_SIZE     = 100


class UploadConstants:
    MAX_FILE_SIZE_MB  = 5
    ALLOWED_TYPES     = ["image/jpeg", "image/png", "image/webp"]
    CNIC_PREFIX       = "cnic/"
    AVATAR_PREFIX     = "avatars/"
    RECEIPT_PREFIX    = "receipts/"
