"""
app/modules/admin/router.py
──────────────────────────────────────────────────────────────────
REST endpoints for Admin Panel.
"""
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.postgres import get_db
from app.core.deps import get_current_user
from app.modules.users.models import User
from app.modules.admin.schemas import AdminDashboardResponse
from app.modules.admin.service import AdminService

router = APIRouter(tags=["Admin"])

def get_admin_service(session: AsyncSession = Depends(get_db)) -> AdminService:
    return AdminService(session)

@router.get("/admin/dashboard", response_model=AdminDashboardResponse)
async def get_admin_dashboard(
    current_user: User = Depends(get_current_user),
    service: AdminService = Depends(get_admin_service)
):
    if "ADMIN" not in current_user.roles:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Admin access required")
        
    return await service.get_dashboard_metrics()
