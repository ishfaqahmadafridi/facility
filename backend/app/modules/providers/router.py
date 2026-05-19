"""
app/modules/providers/router.py
──────────────────────────────────────────────────────────────────
REST endpoints for Providers.
"""
from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.postgres import get_db
from app.core.deps import get_current_user
from app.modules.users.models import User
from app.modules.users.repository import UserRepository
from app.modules.users.service import UserService
from app.modules.providers.schemas import ProviderRegistrationRequest, ProviderProfileBase, ProviderStatusUpdate
from app.modules.providers.repository import ProviderRepository
from app.modules.providers.service import ProviderService
from app.common.responses import success_response

router = APIRouter(tags=["Providers"])

def get_provider_service(session: AsyncSession = Depends(get_db)) -> ProviderService:
    user_repo = UserRepository(session)
    user_service = UserService(user_repo)
    provider_repo = ProviderRepository(session)
    return ProviderService(provider_repo, user_service)


@router.post(
    "/providers/register",
    response_model=ProviderProfileBase,
    status_code=status.HTTP_201_CREATED,
    summary="Register as a Provider"
)
async def register_provider(
    data: ProviderRegistrationRequest,
    current_user: User = Depends(get_current_user),
    service: ProviderService = Depends(get_provider_service)
):
    provider = await service.register(current_user.id, data)
    return provider


@router.get(
    "/providers/me",
    response_model=ProviderProfileBase,
    summary="Get Current Provider Profile"
)
async def get_my_provider_profile(
    current_user: User = Depends(get_current_user),
    service: ProviderService = Depends(get_provider_service)
):
    return await service.get_profile(current_user.id)


@router.patch(
    "/providers/me/status",
    response_model=ProviderProfileBase,
    summary="Go Online/Offline"
)
async def update_provider_status(
    data: ProviderStatusUpdate,
    current_user: User = Depends(get_current_user),
    service: ProviderService = Depends(get_provider_service)
):
    updated_provider = await service.update_status(current_user.id, data.is_online)
    return updated_provider
