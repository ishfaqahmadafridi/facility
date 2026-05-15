from app.db.base_repository import BaseRepository
from typing import Optional, Dict, Any

class UserRepository(BaseRepository):
    def __init__(self, db: Any):
        super().__init__(db, "users")

    async def get_by_email(self, email: str) -> Optional[Dict[str, Any]]:
        return await self.collection.find_one({"email": email})

class BiddingRepository(BaseRepository):
    def __init__(self, db: Any):
        super().__init__(db, "bids")

class RequestRepository(BaseRepository):
    def __init__(self, db: Any):
        super().__init__(db, "requests")
