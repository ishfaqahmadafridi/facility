"""
app/modules/users/service.py
──────────────────────────────────────────────────────────────────
Business logic for Users.
"""
import uuid
from app.modules.users.repository import UserRepository
from app.modules.users.models import User
from app.modules.users.schemas import UserUpdate
from app.common.exceptions import NotFoundException

class UserService:
    def __init__(self, repo: UserRepository):
        self.repo = repo

    async def get_profile(self, user_id: uuid.UUID) -> User:
        user = await self.repo.get_by_id(user_id)
        if not user:
            raise NotFoundException(message="User not found")
        return user

    async def update_profile(self, user_id: uuid.UUID, data: UserUpdate) -> User:
        user = await self.repo.get_by_id(user_id)
        if not user:
            raise NotFoundException(message="User not found")
            
        update_data = data.model_dump(exclude_unset=True)
        return await self.repo.update(user, update_data)

    async def update_roles(self, user_id: uuid.UUID, roles: list[str]) -> User:
        user = await self.repo.get_by_id(user_id)
        if not user:
            raise NotFoundException(message="User not found")
        
        # Ensure 'CUSTOMER' is always included as a baseline role
        if "CUSTOMER" not in roles:
            roles.append("CUSTOMER")
            
        return await self.repo.update(user, {"roles": roles})
