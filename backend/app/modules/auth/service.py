"""
app/modules/auth/service.py
──────────────────────────────────────────────────────────────────
Business logic for Authentication.
"""
import uuid
import hashlib
import secrets
from datetime import datetime, timedelta, timezone

from app.core.config import settings
from app.core import otp
from app.core import security
from app.services import sms_service
from app.modules.auth.repository import AuthRepository
from app.modules.auth.schemas import TokenResponse, UserPayload
from app.common.exceptions import (
    InvalidOTPException, 
    OTPRateLimitException, 
    InvalidCredentialsException,
    TokenExpiredException
)


class AuthService:
    def __init__(self, repo: AuthRepository):
        self.repo = repo

    async def request_otp(self, phone: str) -> None:
        """Generates an OTP, checks rate limit, and sends via SMS."""
        allowed = await otp.check_rate_limit(phone)
        if not allowed:
            raise OTPRateLimitException()

        code = await otp.generate_otp()
        await otp.save_otp_async(phone, code)
        
        # In a real app, you might want a localized template
        message = f"Your SUPERAPP verification code is: {code}. Do not share this with anyone."
        
        success = await sms_service.send_sms(phone, message)
        if not success:
            # Handle SMS failure (e.g., logging or alerting)
            pass

    async def verify_otp(self, phone: str, code: str) -> TokenResponse:
        """Verifies the OTP and issues JWT tokens."""
        saved_code = await otp.get_otp_async(phone)
        
        # Note: in dev, we might want a magic OTP "000000" for Apple/Google review accounts
        is_magic_otp = (settings.ENVIRONMENT != "production" and code == "000000")
        
        if not saved_code and not is_magic_otp:
            raise InvalidOTPException()
            
        if saved_code != code and not is_magic_otp:
            raise InvalidOTPException()

        # Valid OTP. Delete it.
        if saved_code:
            await otp.delete_otp_async(phone)

        # Get or create user
        user = await self.repo.get_user_by_phone(phone)
        if not user:
            user = await self.repo.create_user(phone)

        return await self._generate_tokens(user)

    async def refresh_token(self, refresh_token_str: str) -> TokenResponse:
        """Validates a refresh token and issues new tokens."""
        # Check signature and expiry
        payload = security.verify_token(refresh_token_str)
        if not payload or payload.get("type") != "refresh":
            raise InvalidCredentialsException()

        user_id_str = payload.get("sub")
        if not user_id_str:
            raise InvalidCredentialsException()
            
        user_id = uuid.UUID(user_id_str)

        # Check against DB
        token_hash = hashlib.sha256(refresh_token_str.encode()).hexdigest()
        rt_record = await self.repo.get_refresh_token(token_hash)
        
        if not rt_record or not rt_record.is_valid:
            raise TokenExpiredException()

        # Revoke old refresh token (rotate)
        rt_record.revoked_at = datetime.now(timezone.utc)
        
        # Get user
        user = await self.repo.get_user_by_id(user_id)
        if not user or user.status != "ACTIVE":
            raise ForbiddenException("User account is not active.")

        return await self._generate_tokens(user)

    async def _generate_tokens(self, user) -> TokenResponse:
        """Helper to generate access + refresh tokens and save refresh token to DB."""
        user_payload = UserPayload(
            id=user.id,
            phone=user.phone,
            roles=user.roles,
            status=user.status,
            preferred_lang=user.preferred_lang,
        )

        access_token = security.create_access_token(
            data={"sub": str(user.id), "phone": user.phone, "roles": user.roles}
        )

        # Generate a secure random string for refresh token (or use JWT)
        # We'll use a JWT for the refresh token so it's self-contained with an expiry
        refresh_token = security.create_refresh_token(data={"sub": str(user.id)})
        
        # Hash it before saving to DB
        token_hash = hashlib.sha256(refresh_token.encode()).hexdigest()
        expires_at = datetime.now(timezone.utc) + timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS)
        
        await self.repo.save_refresh_token(user.id, token_hash, expires_at)

        return TokenResponse(
            access_token=access_token,
            refresh_token=refresh_token,
            user=user_payload
        )
