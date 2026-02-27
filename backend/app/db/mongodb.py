from motor.motor_asyncio import AsyncIOMotorClient
from app.core.config import settings

class Database:
    client: AsyncIOMotorClient = None
    db = None

db_connection = Database()

async def connect_to_mongo():
    db_connection.client = AsyncIOMotorClient(settings.MONGODB_URL)
    db_connection.db = db_connection.client[settings.DATABASE_NAME]
    print("Connected to MongoDB")

async def close_mongo_connection():
    db_connection.client.close()
    print("Disconnected from MongoDB")

def get_database():
    return db_connection.db
