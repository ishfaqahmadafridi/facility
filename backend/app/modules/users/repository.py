"""
app/modules/users/repository.py
──────────────────────────────────────────────────────────────────
Database queries for Users.
"""
import uuid
from typing import Optional
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.modules.users.models import User

class UserRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def get_by_id(self, user_id: uuid.UUID) -> Optional[User]:
        stmt = select(User).where(User.id == user_id, User.deleted_at.is_(None))
        result = await self.session.execute(stmt)
        return result.scalar_one_or_none()

    async def update(self, user: User, update_data: dict) -> User:
        for key, value in update_data.items():
            if value is not None:
                setattr(user, key, value)
        await self.session.flush()
        return user
