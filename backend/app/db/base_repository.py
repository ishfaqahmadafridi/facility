from motor.motor_asyncio import AsyncIOMotorClient
from typing import Any, Dict, List, Optional, Union
from bson import ObjectId

class BaseRepository:
    def __init__(self, db: Any, collection_name: str):
        self.db = db
        self.collection = db[collection_name]

    async def get(self, id: str) -> Optional[Dict[str, Any]]:
        return await self.collection.find_one({"_id": ObjectId(id)})

    async def get_by_query(self, query: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        return await self.collection.find_one(query)

    async def list(self, query: Dict[str, Any] = {}, skip: int = 0, limit: int = 100) -> List[Dict[str, Any]]:
        cursor = self.collection.find(query).skip(skip).limit(limit)
        return await cursor.to_list(length=limit)

    async def create(self, data: Dict[str, Any]) -> str:
        result = await self.collection.insert_one(data)
        return str(result.inserted_id)

    async def update(self, id: str, data: Dict[str, Any]) -> bool:
        result = await self.collection.update_one({"_id": ObjectId(id)}, {"$set": data})
        return result.modified_count > 0

    async def delete(self, id: str) -> bool:
        result = await self.collection.delete_one({"_id": ObjectId(id)})
        return result.deleted_count > 0
