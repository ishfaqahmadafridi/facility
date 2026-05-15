from fastapi import FastAPI
from app.core.config import settings
from app.db.mongodb import connect_to_mongo, close_mongo_connection
from bson import ObjectId
from datetime import datetime
from app.api import auth, user, feed, governance

app = FastAPI(title=settings.PROJECT_NAME)

app.include_router(auth.router)
app.include_router(user.router)
app.include_router(feed.router)
app.include_router(governance.router)

@app.on_event("startup")
async def startup_db_client():
    await connect_to_mongo()

@app.on_event("shutdown")
async def shutdown_db_client():
    await close_mongo_connection()

@app.get("/")
async def root():
    return {"message": "Welcome to the Service Bidding App API", "status": "online"}
