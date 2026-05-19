"""
app/modules/admin/schemas.py
──────────────────────────────────────────────────────────────────
Pydantic schemas for the Admin Dashboard APIs.
"""
from typing import List, Dict, Any
from pydantic import BaseModel

class SystemMetricsResponse(BaseModel):
    total_users: int
    active_providers: int
    total_rides_today: int
    total_revenue_today: float

class RecentActivitySchema(BaseModel):
    id: str
    type: str # e.g. "RIDE", "BOOKING", "TOP_UP"
    description: str
    timestamp: str

class AdminDashboardResponse(BaseModel):
    metrics: SystemMetricsResponse
    recent_activity: List[RecentActivitySchema]
