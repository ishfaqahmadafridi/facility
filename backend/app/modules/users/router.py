"""
app/modules/users/router.py
──────────────────────────────────────────────────────────────────
REST endpoints for Users.
"""
from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.postgres import get_db
from app.core.deps import get_current_user
from app.modules.users.models import User
from app.modules.users.schemas import UserProfile, UserUpdate, RoleUpdate
from app.modules.users.repository import UserRepository
from app.modules.users.service import UserService
from app.common.responses import success_response, JSONResponse

router = APIRouter(tags=["Users"])

def get_user_service(session: AsyncSession = Depends(get_db)) -> UserService:
    repo = UserRepository(session)
    return UserService(repo)


@router.get(
    "/users/me",
    response_model=UserProfile,
    summary="Get Current User Profile"
)
async def get_my_profile(
    current_user: User = Depends(get_current_user),
    service: UserService = Depends(get_user_service)
):
    # We could just return current_user, but fetching through service ensures consistency
    return await service.get_profile(current_user.id)


@router.patch(
    "/users/me",
    response_model=UserProfile,
    summary="Update Current User Profile"
)
async def update_my_profile(
    data: UserUpdate,
    current_user: User = Depends(get_current_user),
    service: UserService = Depends(get_user_service)
):
    updated_user = await service.update_profile(current_user.id, data)
    return updated_user


@router.post(
    "/users/me/roles",
    response_model=UserProfile,
    summary="Update Current User Roles",
    description="Used during onboarding when a user selects to become a Provider."
)
async def update_my_roles(
    data: RoleUpdate,
    current_user: User = Depends(get_current_user),
    service: UserService = Depends(get_user_service)
):
    updated_user = await service.update_roles(current_user.id, data.roles)
    return updated_user
