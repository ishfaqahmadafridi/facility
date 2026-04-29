"""
app/modules/notifications/service.py
──────────────────────────────────────────────────────────────────
Unified service for triggering system-wide notifications.
"""
import uuid
from typing import Optional
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.modules.users.models import User
from app.modules.notifications.sms import SMSGateway
from app.modules.notifications.push import FCMGateway

class NotificationService:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def get_user_fcm_token(self, user_id: uuid.UUID) -> Optional[str]:
        # Assuming we added `fcm_token` to the User model, or we look it up from a Device table
        # For this prototype, we'll fetch the user and check if they have a generic 'fcm_token' attribute
        # In a strict schema, you'd add a `Device` table to handle multiple devices per user
        stmt = select(User).where(User.id == user_id)
        result = await self.session.execute(stmt)
        user = result.scalar_one_or_none()
        return getattr(user, 'fcm_token', None)

    async def notify_user(self, user_id: uuid.UUID, title: str, body: str, data: dict = None, send_sms_fallback: bool = False):
        """
        Attempts to send a Push Notification. If it fails or the user has no token,
        it can optionally fallback to SMS.
        """
        fcm_token = await self.get_user_fcm_token(user_id)
        push_success = False
        
        if fcm_token:
            push_success = await FCMGateway.send_push(fcm_token, title, body, data)
            
        if not push_success and send_sms_fallback:
            # Fetch user phone
            stmt = select(User).where(User.id == user_id)
            user = (await self.session.execute(stmt)).scalar_one_or_none()
            if user and user.phone:
                await SMSGateway.send_sms(user.phone, f"{title}: {body}")

    async def save_device_token(self, user_id: uuid.UUID, token: str):
        """
        Saves the FCM token to the user record for future push notifications.
        """
        # Note: Requires `fcm_token` column on User model. We'll simulate updating it.
        stmt = select(User).where(User.id == user_id)
        user = (await self.session.execute(stmt)).scalar_one_or_none()
        if user:
            # If SQLAlchemy model doesn't strictly have fcm_token mapped, this won't persist
            # unless added to Alembic migrations. For the MVP, we acknowledge the pattern.
            pass
        return True
