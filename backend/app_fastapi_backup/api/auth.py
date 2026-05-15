from fastapi import APIRouter, Depends, HTTPException, status
from app.schemas.user import Token, UserBase
from app.services.auth_service import AuthService
from app.crud.repositories import UserRepository
from app.db.mongodb import get_database

router = APIRouter(prefix="/auth", tags=["auth"])

def get_auth_service(db = Depends(get_database)):
    user_repo = UserRepository(db)
    return AuthService(user_repo)

@router.post("/request-otp")
async def request_otp(email_data: UserBase, service: AuthService = Depends(get_auth_service)):
    await service.request_otp(email_data.email)
    return {"message": "OTP sent to your email"}

@router.post("/verify-otp", response_model=Token)
async def verify_otp(email: str, code: str, service: AuthService = Depends(get_auth_service)):
    token = await service.verify_otp(email, code)
    if not token:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired OTP",
        )
    return {"access_token": token, "token_type": "bearer"}
