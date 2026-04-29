"""
app/modules/roadside/router.py
──────────────────────────────────────────────────────────────────
REST endpoints for Roadside Assistance.
"""
import uuid
from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.postgres import get_db
from app.core.deps import get_current_user
from app.modules.users.models import User
from app.modules.roadside.schemas import RoadsideCreateRequest, RoadsideResponseSchema, RoadsideStatusUpdate
from app.modules.roadside.repository import RoadsideRepository
from app.modules.roadside.service import RoadsideService

router = APIRouter(tags=["Roadside"])

def get_roadside_service(session: AsyncSession = Depends(get_db)) -> RoadsideService:
    return RoadsideService(RoadsideRepository(session))

@router.post("/roadside", response_model=RoadsideResponseSchema, status_code=status.HTTP_201_CREATED)
async def request_assistance(
    data: RoadsideCreateRequest,
    current_user: User = Depends(get_current_user),
    service: RoadsideService = Depends(get_roadside_service)
):
    return await service.request_assistance(current_user.id, data)

@router.get("/roadside/{request_id}", response_model=RoadsideResponseSchema)
async def get_request(
    request_id: uuid.UUID,
    current_user: User = Depends(get_current_user),
    service: RoadsideService = Depends(get_roadside_service)
):
    return await service.get_request(request_id)

@router.post("/roadside/{request_id}/accept", response_model=RoadsideResponseSchema)
async def accept_request(
    request_id: uuid.UUID,
    current_user: User = Depends(get_current_user),
    service: RoadsideService = Depends(get_roadside_service)
):
    if "PROVIDER" not in current_user.roles:
        from fastapi import HTTPException
        raise HTTPException(status_code=403, detail="Only providers can accept requests")
        
    return await service.accept_request(current_user.id, request_id)

@router.patch("/roadside/{request_id}/status", response_model=RoadsideResponseSchema)
async def update_status(
    request_id: uuid.UUID,
    data: RoadsideStatusUpdate,
    current_user: User = Depends(get_current_user),
    service: RoadsideService = Depends(get_roadside_service)
):
    return await service.update_status(current_user.id, request_id, data.status)
