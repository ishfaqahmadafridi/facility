"""
app/modules/notifications/router.py
──────────────────────────────────────────────────────────────────
REST endpoints for device registration.
"""
from pydantic import BaseModel
from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.postgres import get_db
from app.core.deps import get_current_user
from app.modules.users.models import User
from app.modules.notifications.service import NotificationService

router = APIRouter(tags=["Notifications"])

class DeviceTokenRequest(BaseModel):
    fcm_token: str

def get_notification_service(session: AsyncSession = Depends(get_db)) -> NotificationService:
    return NotificationService(session)

@router.post("/notifications/register-device")
async def register_device(
    data: DeviceTokenRequest,
    current_user: User = Depends(get_current_user),
    service: NotificationService = Depends(get_notification_service)
):
    """
    Called by the Flutter app on startup to register the Firebase Cloud Messaging token.
    """
    await service.save_device_token(current_user.id, data.fcm_token)
    return {"message": "Device registered successfully"}
