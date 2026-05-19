"""
app/modules/providers/service.py
──────────────────────────────────────────────────────────────────
Business logic for Providers.
"""
import uuid
from datetime import datetime, timezone
from app.modules.providers.repository import ProviderRepository
from app.modules.providers.models import ProviderProfile
from app.modules.providers.schemas import ProviderRegistrationRequest
from app.modules.users.service import UserService
from app.common.exceptions import ConflictException, NotFoundException

class ProviderService:
    def __init__(self, repo: ProviderRepository, user_service: UserService):
        self.repo = repo
        self.user_service = user_service

    async def register(self, user_id: uuid.UUID, data: ProviderRegistrationRequest) -> ProviderProfile:
        # Check if already exists
        existing = await self.repo.get_by_user_id(user_id)
        if existing:
            raise ConflictException("Provider profile already exists")

        # Create provider
        provider = ProviderProfile(
            user_id=user_id,
            cnic=data.cnic,
            vertical=data.vertical,
            skills=data.skills
        )
        provider = await self.repo.create(provider)
        
        # Ensure user has PROVIDER role
        await self.user_service.update_roles(user_id, ["CUSTOMER", "PROVIDER"])
        
        return provider

    async def get_profile(self, user_id: uuid.UUID) -> ProviderProfile:
        provider = await self.repo.get_by_user_id(user_id)
        if not provider:
            raise NotFoundException("Provider profile not found")
        return provider

    async def update_status(self, user_id: uuid.UUID, is_online: bool) -> ProviderProfile:
        provider = await self.repo.get_by_user_id(user_id)
        if not provider:
            raise NotFoundException("Provider profile not found")
            
        update_data = {
            "is_online": is_online,
        }
        if is_online:
            update_data["last_online"] = datetime.now(timezone.utc)
            
        return await self.repo.update(provider, update_data)
