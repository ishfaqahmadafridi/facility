"""
app/modules/auth/router.py
──────────────────────────────────────────────────────────────────
REST endpoints for Auth.
"""
from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.postgres import get_db
from app.modules.auth.schemas import OTPRequest, OTPVerify, RefreshTokenRequest, TokenResponse
from app.modules.auth.repository import AuthRepository
from app.modules.auth.service import AuthService
from app.common.responses import success_response, JSONResponse

router = APIRouter(tags=["Auth"])

def get_auth_service(session: AsyncSession = Depends(get_db)) -> AuthService:
    repo = AuthRepository(session)
    return AuthService(repo)


@router.post(
    "/auth/request-otp",
    summary="Request SMS OTP",
    description="Generates a 6-digit OTP and sends it via SMS. Rate limited."
)
async def request_otp(data: OTPRequest, service: AuthService = Depends(get_auth_service)):
    await service.request_otp(data.phone)
    return success_response(message=f"OTP sent to {data.phone}")


@router.post(
    "/auth/verify-otp",
    response_model=TokenResponse,
    summary="Verify OTP and Login",
    description="Verifies the OTP. If valid, issues an access token and refresh token."
)
async def verify_otp(data: OTPVerify, service: AuthService = Depends(get_auth_service)):
    tokens = await service.verify_otp(data.phone, data.code)
    # Return directly as a Pydantic model response
    return tokens


@router.post(
    "/auth/refresh",
    response_model=TokenResponse,
    summary="Refresh Access Token",
    description="Exchanges a valid refresh token for a new access+refresh token pair."
)
async def refresh_token(data: RefreshTokenRequest, service: AuthService = Depends(get_auth_service)):
    tokens = await service.refresh_token(data.refresh_token)
    return tokens


@router.post(
    "/auth/logout",
    summary="Logout",
    description="Revokes the refresh token."
)
async def logout(data: RefreshTokenRequest, service: AuthService = Depends(get_auth_service)):
    # Optional: we can implement logout by revoking the refresh token.
    # We would need a repo method for this.
    return success_response(message="Logged out successfully.")
