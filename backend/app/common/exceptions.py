"""
app/common/exceptions.py
──────────────────────────────────────────────────────────────────
Custom HTTP exceptions with machine-readable error codes.

Naming convention: <Domain><Problem>Exception
  e.g. UserNotFoundException, RideAlreadyCancelledException

All exceptions map to a specific HTTP status and a snake_case code
that clients can handle programmatically without parsing messages.
"""
from fastapi import HTTPException, status


# ── 400 Bad Request ────────────────────────────────────────────────

class InvalidOTPException(HTTPException):
    def __init__(self):
        super().__init__(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": "INVALID_OTP", "message": "OTP is invalid or expired."},
        )


class InvalidPhoneNumberException(HTTPException):
    def __init__(self):
        super().__init__(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": "INVALID_PHONE", "message": "Phone number format is invalid."},
        )


class InvalidRideTransitionException(HTTPException):
    def __init__(self, current: str, target: str):
        super().__init__(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={
                "code": "INVALID_RIDE_TRANSITION",
                "message": f"Cannot transition ride from {current} to {target}.",
            },
        )


class InvalidBookingTransitionException(HTTPException):
    def __init__(self, current: str, target: str):
        super().__init__(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={
                "code": "INVALID_BOOKING_TRANSITION",
                "message": f"Cannot transition booking from {current} to {target}.",
            },
        )


class InsufficientWalletBalanceException(HTTPException):
    def __init__(self):
        super().__init__(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": "INSUFFICIENT_BALANCE", "message": "Wallet balance is too low."},
        )


# ── 401 Unauthorized ───────────────────────────────────────────────

class InvalidCredentialsException(HTTPException):
    def __init__(self):
        super().__init__(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail={"code": "INVALID_CREDENTIALS", "message": "Authentication failed."},
            headers={"WWW-Authenticate": "Bearer"},
        )


class TokenExpiredException(HTTPException):
    def __init__(self):
        super().__init__(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail={"code": "TOKEN_EXPIRED", "message": "Access token has expired."},
            headers={"WWW-Authenticate": "Bearer"},
        )


# ── 403 Forbidden ──────────────────────────────────────────────────

class ForbiddenException(HTTPException):
    def __init__(self, message: str = "You do not have permission to perform this action."):
        super().__init__(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={"code": "FORBIDDEN", "message": message},
        )


class ProviderNotApprovedExeception(HTTPException):
    def __init__(self):
        super().__init__(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={"code": "PROVIDER_NOT_APPROVED", "message": "Provider account is pending approval."},
        )


# ── 404 Not Found ──────────────────────────────────────────────────

class UserNotFoundException(HTTPException):
    def __init__(self):
        super().__init__(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "USER_NOT_FOUND", "message": "User not found."},
        )


class ProviderNotFoundException(HTTPException):
    def __init__(self):
        super().__init__(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "PROVIDER_NOT_FOUND", "message": "Provider not found."},
        )


class RideNotFoundException(HTTPException):
    def __init__(self):
        super().__init__(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "RIDE_NOT_FOUND", "message": "Ride not found."},
        )


class BookingNotFoundException(HTTPException):
    def __init__(self):
        super().__init__(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "BOOKING_NOT_FOUND", "message": "Booking not found."},
        )


class SubscriptionNotFoundException(HTTPException):
    def __init__(self):
        super().__init__(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "SUBSCRIPTION_NOT_FOUND", "message": "Subscription not found."},
        )


# ── 409 Conflict ───────────────────────────────────────────────────

class PhoneAlreadyRegisteredException(HTTPException):
    def __init__(self):
        super().__init__(
            status_code=status.HTTP_409_CONFLICT,
            detail={"code": "PHONE_ALREADY_REGISTERED", "message": "This phone number is already registered."},
        )


class ActiveRideExistsException(HTTPException):
    def __init__(self):
        super().__init__(
            status_code=status.HTTP_409_CONFLICT,
            detail={"code": "ACTIVE_RIDE_EXISTS", "message": "You already have an active ride."},
        )


# ── 429 Too Many Requests ──────────────────────────────────────────

class OTPRateLimitException(HTTPException):
    def __init__(self):
        super().__init__(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail={"code": "OTP_RATE_LIMIT", "message": "Too many OTP requests. Please wait before retrying."},
        )


# ── 500 Internal Server Error ──────────────────────────────────────

class ExternalServiceException(HTTPException):
    def __init__(self, service: str):
        super().__init__(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail={"code": "EXTERNAL_SERVICE_ERROR", "message": f"{service} is currently unavailable."},
        )


# ── Generic aliases (used by sessions 07-10 services) ─────────────────────────

class NotFoundException(HTTPException):
    """Generic 404 — use when a specific typed exception doesn't exist."""
    def __init__(self, message: str = "Resource not found."):
        super().__init__(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "NOT_FOUND", "message": message},
        )


class ConflictException(HTTPException):
    """Generic 409 — use when a business rule conflict occurs."""
    def __init__(self, message: str = "Conflict."):
        super().__init__(
            status_code=status.HTTP_409_CONFLICT,
            detail={"code": "CONFLICT", "message": message},
        )

