"""
app/core/deps.py
──────────────────────────────────────────────────────────────────
FastAPI dependencies for Authentication and Authorization.
"""
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.ext.asyncio import AsyncSession
import uuid

from app.core import security
from app.db.postgres import get_db
from app.modules.users.models import User
from app.modules.users.repository import UserRepository

# We use standard OAuth2 schema for Swagger UI compatibility
oauth2_scheme = OAuth2PasswordBearer(tokenUrl=f"/api/v1/auth/request-otp")

async def get_current_user(
    token: str = Depends(oauth2_scheme),
    session: AsyncSession = Depends(get_db)
) -> User:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    payload = security.verify_token(token)
    if payload is None or payload.get("type") != "access":
        raise credentials_exception
        
    user_id_str: str = payload.get("sub")
    if user_id_str is None:
        raise credentials_exception
        
    try:
        user_id = uuid.UUID(user_id_str)
    except ValueError:
        raise credentials_exception

    repo = UserRepository(session)
    user = await repo.get_by_id(user_id)
    if user is None:
        raise credentials_exception
        
    if user.status != "ACTIVE":
        raise HTTPException(status_code=403, detail="Inactive user account")
        
    return user
