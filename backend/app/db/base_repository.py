from typing import Any, Dict, List, Optional
from bson import ObjectId
import uuid

class BaseRepository:
    def __init__(self, db: Any, collection_name: str):
        self.db = db
        self.collection_name = collection_name
        # Internal mock storage if db is a dict (Mock Mode)
        self.is_mock = isinstance(db, dict)
        if self.is_mock:
            if collection_name not in db:
                db[collection_name] = {}
            self.mock_data = db[collection_name]
        else:
            self.collection = db[collection_name]

    async def get(self, id: str) -> Optional[Dict[str, Any]]:
        if self.is_mock:
            return self.mock_data.get(id)
        return await self.collection.find_one({"_id": ObjectId(id)})

    async def get_by_query(self, query: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        if self.is_mock:
            # Simple mock query (matches exactly)
            for item in self.mock_data.values():
                if all(item.get(k) == v for k, v in query.items() if k != "_id"):
                    return item
            return None
        return await self.collection.find_one(query)

    async def list(self, query: Dict[str, Any] = {}, skip: int = 0, limit: int = 100) -> List[Dict[str, Any]]:
        if self.is_mock:
            # Simple mock list
            items = list(self.mock_data.values())
            return items[skip:skip+limit]
        cursor = self.collection.find(query).skip(skip).limit(limit)
        return await cursor.to_list(length=limit)

    async def create(self, data: Dict[str, Any]) -> str:
        if self.is_mock:
            id_str = str(uuid.uuid4())
            data["_id"] = id_str
            self.mock_data[id_str] = data
            return id_str
        result = await self.collection.insert_one(data)
        return str(result.inserted_id)

    async def update(self, id: str, data: Dict[str, Any]) -> bool:
        if self.is_mock:
            if id in self.mock_data:
                self.mock_data[id].update(data)
                return True
            return False
        result = await self.collection.update_one({"_id": ObjectId(id)}, {"$set": data})
        return result.modified_count > 0

    async def delete(self, id: str) -> bool:
        if self.is_mock:
            if id in self.mock_data:
                del self.mock_data[id]
                return True
            return False
        result = await self.collection.delete_one({"_id": ObjectId(id)})
        return result.deleted_count > 0
