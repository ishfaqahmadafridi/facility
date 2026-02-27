from motor.motor_asyncio import AsyncIOMotorClient
from app.core.config import settings
import logging

class Database:
    client: AsyncIOMotorClient = None
    db = None
    use_mock: bool = False

db = Database()

async def connect_to_mongo():
    try:
        db.client = AsyncIOMotorClient(settings.MONGODB_URL, serverSelectionTimeoutMS=2000)
        await db.client.admin.command('ping')
        db.db = db.client[settings.DATABASE_NAME]
        db.use_mock = False
        print("Connected to MongoDB successfully.")
    except Exception as e:
        print(f"Warning: Could not connect to MongoDB ({e}). Switching to IN-MEMORY MOCK MODE.")
        db.use_mock = True
        db.db = {} # Simple dict for mock collections

async def close_mongo_connection():
    if db.client:
        db.client.close()
        print("MongoDB connection closed.")

async def get_database():
    return db.db
