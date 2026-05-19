from fastapi import APIRouter, Depends
from app.api.deps import get_current_user, get_feed_service
from app.schemas.bidding import ServiceRequest, ServiceRequestBase, BidBase
from app.services.feed_service import FeedService
from typing import List, Optional

router = APIRouter(prefix="/feed", tags=["feed"])

@router.post("/post-job", response_model=ServiceRequest)
async def post(req: ServiceRequestBase, user = Depends(get_current_user), svc: FeedService = Depends(get_feed_service)):
    return await svc.post_job(req.dict(), str(user["_id"]))

@router.get("/jobs", response_model=List[ServiceRequest])
async def list(cat: Optional[str] = None, svc: FeedService = Depends(get_feed_service)):
    return await svc.list_jobs(cat)
