"""
app/modules/subscriptions/service.py
──────────────────────────────────────────────────────────────────
Business logic for Subscriptions.
"""
import uuid
from datetime import datetime, timedelta, timezone
from typing import List

from app.modules.subscriptions.repository import SubscriptionRepository
from app.modules.subscriptions.models import UserSubscription
from app.modules.subscriptions.schemas import SubscriptionPlanSchema, UserSubscriptionSchema
from app.common.exceptions import NotFoundException

class SubscriptionService:
    def __init__(self, repo: SubscriptionRepository):
        self.repo = repo

    async def get_available_plans(self, vertical: str = None) -> List[SubscriptionPlanSchema]:
        plans = await self.repo.get_plans(vertical)
        return plans

    async def subscribe(self, user_id: uuid.UUID, plan_id: uuid.UUID) -> UserSubscriptionSchema:
        plan = await self.repo.get_plan_by_id(plan_id)
        if not plan:
            raise NotFoundException("Subscription plan not found")
            
        now = datetime.now(timezone.utc)
        end_date = now + timedelta(days=plan.duration_days)
        
        # Here we would normally charge the wallet or call payment gateway
        
        sub = UserSubscription(
            user_id=user_id,
            plan_id=plan_id,
            start_date=now,
            end_date=end_date,
            visits_remaining=plan.visits_per_month,
            status="ACTIVE"
        )
        
        sub = await self.repo.create_user_subscription(sub)
        return sub

    async def get_active_subscriptions(self, user_id: uuid.UUID) -> List[UserSubscriptionSchema]:
        subs = await self.repo.get_user_subscriptions(user_id)
        return subs
