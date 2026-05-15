from fastapi import APIRouter, Depends, HTTPException, status
from app.db.mongodb import get_database
from app.schemas.user import User, ProfileData, ProviderVerificationGate
from app.core.security import verify_token
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from typing import Optional

router = APIRouter(prefix="/users", tags=["users"])
auth_scheme = HTTPBearer()

async def get_current_user(token: HTTPAuthorizationCredentials = Depends(auth_scheme), db = Depends(get_database)):
    payload = verify_token(token.credentials)
    if not payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
    email: str = payload.get("sub")
    user = await db.users.find_one({"email": email})
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.get("/me", response_model=User)
async def read_users_me(current_user: User = Depends(get_current_user)):
    return current_user

@router.put("/profile")
async def update_profile(
    profile: ProfileData, 
    role: Optional[str] = None,
    current_user = Depends(get_current_user),
    db = Depends(get_database)
):
    update_data = {"profile_data": profile.dict()}
    if role and role in ["Customer", "Worker", "Mechanic", "Nurse"]:
        update_data["role"] = role
        
        # If transitioning to a provider role, initialize verification gate
        if role != "Customer":
            update_data["verification_gate"] = {
                "hcs_verified": False,
                "pnmc_id": None,
                "experience_years": 0
            }

    await db.users.update_one({"email": current_user["email"]}, {"$set": update_data})
    return {"message": "Profile updated successfully"}

@router.put("/verify-provider")
async def verify_provider(
    gate_data: ProviderVerificationGate,
    current_user = Depends(get_current_user),
    db = Depends(get_database)
):
    if current_user["role"] == "Customer":
        raise HTTPException(status_code=400, detail="Only providers can submit verification data")
    
    await db.users.update_one(
        {"email": current_user["email"]}, 
        {"$set": {"verification_gate": gate_data.dict()}}
    )
    return {"message": "Verification data submitted. Profile is under review."}
