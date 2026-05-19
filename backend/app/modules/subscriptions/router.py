"""
app/modules/subscriptions/router.py
──────────────────────────────────────────────────────────────────
REST endpoints for Subscriptions.
"""
from typing import List, Optional
from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.postgres import get_db
from app.core.deps import get_current_user
from app.modules.users.models import User
from app.modules.subscriptions.schemas import SubscriptionPlanSchema, UserSubscriptionSchema, SubscribeRequest
from app.modules.subscriptions.repository import SubscriptionRepository
from app.modules.subscriptions.service import SubscriptionService

router = APIRouter(tags=["Subscriptions"])

def get_subscription_service(session: AsyncSession = Depends(get_db)) -> SubscriptionService:
    return SubscriptionService(SubscriptionRepository(session))

@router.get("/subscriptions/plans", response_model=List[SubscriptionPlanSchema])
async def get_plans(
    vertical: Optional[str] = None,
    service: SubscriptionService = Depends(get_subscription_service)
):
    return await service.get_available_plans(vertical)

@router.get("/subscriptions/me", response_model=List[UserSubscriptionSchema])
async def get_my_subscriptions(
    current_user: User = Depends(get_current_user),
    service: SubscriptionService = Depends(get_subscription_service)
):
    return await service.get_active_subscriptions(current_user.id)

@router.post("/subscriptions/subscribe", response_model=UserSubscriptionSchema, status_code=status.HTTP_201_CREATED)
async def subscribe(
    data: SubscribeRequest,
    current_user: User = Depends(get_current_user),
    service: SubscriptionService = Depends(get_subscription_service)
):
    return await service.subscribe(current_user.id, data.plan_id)
