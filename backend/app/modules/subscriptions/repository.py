"""
app/modules/subscriptions/repository.py
──────────────────────────────────────────────────────────────────
Database operations for Subscriptions.
"""
import uuid
from typing import List, Optional
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.modules.subscriptions.models import SubscriptionPlan, UserSubscription

class SubscriptionRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def get_plans(self, vertical: Optional[str] = None) -> List[SubscriptionPlan]:
        stmt = select(SubscriptionPlan)
        if vertical:
            stmt = stmt.where(SubscriptionPlan.vertical == vertical)
        result = await self.session.execute(stmt)
        return list(result.scalars().all())

    async def get_plan_by_id(self, plan_id: uuid.UUID) -> Optional[SubscriptionPlan]:
        stmt = select(SubscriptionPlan).where(SubscriptionPlan.id == plan_id)
        result = await self.session.execute(stmt)
        return result.scalar_one_or_none()

    async def create_user_subscription(self, sub: UserSubscription) -> UserSubscription:
        self.session.add(sub)
        await self.session.flush()
        return sub

    async def get_user_subscriptions(self, user_id: uuid.UUID) -> List[UserSubscription]:
        stmt = select(UserSubscription).where(
            UserSubscription.user_id == user_id,
            UserSubscription.status == "ACTIVE"
        ).order_by(UserSubscription.start_date.desc())
        result = await self.session.execute(stmt)
        return list(result.scalars().all())
