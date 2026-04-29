"""
app/modules/admin/service.py
──────────────────────────────────────────────────────────────────
Business logic for Admin Dashboard.
"""
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession
from datetime import datetime, date

from app.modules.users.models import User
from app.modules.rides.models import Ride
from app.modules.admin.schemas import AdminDashboardResponse, SystemMetricsResponse

class AdminService:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def get_dashboard_metrics(self) -> AdminDashboardResponse:
        # In a real app, these would be complex aggregation queries.
        # For demonstration, we'll do basic counts.
        
        # 1. Total Users
        stmt_users = select(func.count(User.id))
        total_users = (await self.session.execute(stmt_users)).scalar() or 0
        
        # 2. Total Rides Today
        today = date.today()
        stmt_rides = select(func.count(Ride.id)).where(
            func.date(Ride.created_at) == today
        )
        total_rides_today = (await self.session.execute(stmt_rides)).scalar() or 0

        # Mock active providers and revenue
        metrics = SystemMetricsResponse(
            total_users=total_users,
            active_providers=124, # Mocked (would come from Redis in reality)
            total_rides_today=total_rides_today,
            total_revenue_today=45000.0 # Mocked (would come from Wallet DB)
        )
        
        activity = [
            {"id": "1", "type": "RIDE", "description": "Ride completed in Gulberg", "timestamp": str(datetime.now())},
            {"id": "2", "type": "TOP_UP", "description": "Customer topped up Rs. 1000", "timestamp": str(datetime.now())}
        ]
        
        return AdminDashboardResponse(
            metrics=metrics,
            recent_activity=activity
        )
