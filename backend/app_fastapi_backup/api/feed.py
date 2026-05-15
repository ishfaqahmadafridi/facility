from fastapi import APIRouter, Depends, HTTPException, status
from app.api.user import get_current_user
from app.db.mongodb import get_database
from app.schemas.bidding import ServiceRequest, ServiceRequestBase, BidBase
from app.services.bidding_service import BiddingService
from app.crud.repositories import BiddingRepository, RequestRepository
from typing import List, Optional
from datetime import datetime

router = APIRouter(prefix="/feed", tags=["feed"])

def get_bidding_service(db = Depends(get_database)):
    bid_repo = BiddingRepository(db)
    req_repo = RequestRepository(db)
    return BiddingService(bid_repo, req_repo)

@router.post("/post-job", response_model=ServiceRequest)
async def post_job(
    request: ServiceRequestBase,
    current_user = Depends(get_current_user),
    db = Depends(get_database)
):
    req_repo = RequestRepository(db)
    new_request = request.dict()
    new_request["customer_id"] = str(current_user["_id"])
    new_request["status"] = "Open"
    new_request["created_at"] = datetime.utcnow()
    
    req_id = await req_repo.create(new_request)
    new_request["_id"] = req_id
    return new_request

@router.get("/jobs", response_model=List[ServiceRequest])
async def get_jobs(
    category: Optional[str] = None,
    db = Depends(get_database)
):
    req_repo = RequestRepository(db)
    query = {"status": "Open"}
    if category:
        query["category"] = category
    
    jobs = await req_repo.list(query)
    # Convert _id to string for pydentic
    for job in jobs:
        job["_id"] = str(job["_id"])
    return jobs

@router.post("/bid")
async def place_bid(
    bid_data: BidBase,
    current_user = Depends(get_current_user),
    service: BiddingService = Depends(get_bidding_service)
):
    if current_user["role"] == "Customer":
        raise HTTPException(status_code=403, detail="Only providers can place bids")
    
    bid_id, error = await service.place_bid(
        str(current_user["_id"]),
        current_user["profile_data"].get("name", "Verified Provider"),
        current_user.get("verification_gate", {}).get("experience_years", 0),
        bid_data.dict()
    )
    
    if error:
        raise HTTPException(status_code=400, detail=error)
        
    return {"message": "Bid placed successfully", "bid_id": bid_id}
