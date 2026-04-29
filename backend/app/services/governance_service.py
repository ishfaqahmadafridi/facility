from app.db.mongodb import get_database
from bson import ObjectId

class GovernanceService:
    def __init__(self, db):
        self.db = db

    async def get_attestation_queue(self):
        return await self.db.users.find({
            "role": "Nurse",
            "verification_gate.hcs_verified": False
        }).to_list(100)

    async def approve_hcs(self, user_id: str):
        await self.db.users.update_one(
            {"_id": ObjectId(user_id)},
            {"$set": {"verification_gate.hcs_verified": True}}
        )
