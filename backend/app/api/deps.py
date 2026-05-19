from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from app.db.mongodb import get_database
from app.core.security import verify_token
from app.services.governance_service import GovernanceService
from app.services.feed_service import FeedService

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

async def get_super_admin(current_user = Depends(get_current_user)):
    if current_user.get("role") != "SuperAdmin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Access restricted to Super-Admins only"
        )
    return current_user

async def get_gov_service(db = Depends(get_database)):
    return GovernanceService(db)

async def get_feed_service(db = Depends(get_database)):
    return FeedService(db)
