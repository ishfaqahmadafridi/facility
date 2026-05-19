from fastapi import APIRouter, Depends
from app.api.deps import get_super_admin, get_gov_service
from app.services.governance_service import GovernanceService

router = APIRouter(prefix="/governance", tags=["governance"])

@router.get("/attestation-queue")
async def queue(adm = Depends(get_super_admin), svc: GovernanceService = Depends(get_gov_service)):
    return await svc.get_attestation_queue()

@router.post("/approve-hcs/{user_id}")
async def approve(user_id: str, adm = Depends(get_super_admin), svc: GovernanceService = Depends(get_gov_service)):
    await svc.approve_hcs(user_id)
    return {"message": "HCS certification approved"}
