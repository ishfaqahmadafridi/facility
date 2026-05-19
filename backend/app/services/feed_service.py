from app.crud.repositories import RequestRepository
from datetime import datetime

class FeedService:
    def __init__(self, db):
        self.db = db
        self.req_repo = RequestRepository(db)

    async def post_job(self, request_data: dict, customer_id: str):
        request_data["customer_id"] = customer_id
        request_data["status"] = "Open"
        request_data["created_at"] = datetime.utcnow()
        req_id = await self.req_repo.create(request_data)
        request_data["_id"] = req_id
        return request_data

    async def list_jobs(self, category: str = None):
        query = {"status": "Open"}
        if category:
            query["category"] = category
        jobs = await self.req_repo.list(query)
        for job in jobs:
            job["_id"] = str(job["_id"])
        return jobs
