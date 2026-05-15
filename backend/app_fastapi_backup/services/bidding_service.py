from app.crud.repositories import BiddingRepository, RequestRepository
from bson import ObjectId
from datetime import datetime

class BiddingService:
    def __init__(self, bid_repo: BiddingRepository, req_repo: RequestRepository):
        self.bid_repo = bid_repo
        self.req_repo = req_repo

    async def place_bid(self, user_id: str, user_name: str, user_exp: int, bid_data: dict):
        # Business validation logic
        request = await self.req_repo.get_by_query({
            "_id": ObjectId(bid_data["request_id"]), 
            "status": "Open"
        })
        if not request:
            return None, "Job request not found or closed"

        new_bid = {
            **bid_data,
            "provider_id": user_id,
            "provider_name": user_name,
            "provider_experience": user_exp,
            "status": "Pending",
            "created_at": datetime.utcnow()
        }
        bid_id = await self.bid_repo.create(new_bid)
        return bid_id, None
