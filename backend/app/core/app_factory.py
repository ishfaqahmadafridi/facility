"""
app/core/app_factory.py
──────────────────────────────────────────────────────────────────
FastAPI application factory.

Pattern: each session adds its router here.
"""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.core.config import settings
from app.db.postgres import engine
from app.db.redis import ping_redis
from app.db.base import Base


def create_app() -> FastAPI:
    app = FastAPI(
        title=settings.PROJECT_NAME,
        version="1.0.0",
        docs_url="/docs" if settings.DEBUG else None,
        redoc_url="/redoc" if settings.DEBUG else None,
    )

    # ── CORS ───────────────────────────────────────────────────────
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.get_allowed_origins(),
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    # ── Routers ────────────────────────────────────────────────────
    # SESSION 02: auth
    from app.modules.auth.router import router as auth_router
    app.include_router(auth_router, prefix=settings.API_V1_PREFIX)

    # SESSION 03: users, providers
    from app.modules.users.router import router as users_router
    app.include_router(users_router, prefix=settings.API_V1_PREFIX)
    
    from app.modules.providers.router import router as providers_router
    app.include_router(providers_router, prefix=settings.API_V1_PREFIX)

    # SESSION 05: rides
    from app.modules.rides.router import router as rides_router
    app.include_router(rides_router, prefix=settings.API_V1_PREFIX)

    # SESSION 06: bookings
    from app.modules.bookings.router import router as bookings_router
    app.include_router(bookings_router, prefix=settings.API_V1_PREFIX)

    # SESSION 07: roadside
    from app.modules.roadside.router import router as roadside_router
    app.include_router(roadside_router, prefix=settings.API_V1_PREFIX)

    # SESSION 08: wallet
    from app.modules.wallet.router import router as wallet_router
    app.include_router(wallet_router, prefix=settings.API_V1_PREFIX)

    # SESSION 09: ratings
    from app.modules.ratings.router import router as ratings_router
    app.include_router(ratings_router, prefix=settings.API_V1_PREFIX)

    # SESSION 10: subscriptions
    from app.modules.subscriptions.router import router as subscriptions_router
    app.include_router(subscriptions_router, prefix=settings.API_V1_PREFIX)

    # SESSION 12: admin
    from app.modules.admin.router import router as admin_router
    app.include_router(admin_router, prefix=settings.API_V1_PREFIX)

    # SESSION 13: notifications
    from app.modules.notifications.router import router as notifications_router
    app.include_router(notifications_router, prefix=settings.API_V1_PREFIX)

    # ── Lifecycle ──────────────────────────────────────────────────
    @app.on_event("startup")
    async def on_startup():
        # Redis health check
        if not await ping_redis():
            print("WARNING: Redis is not reachable. OTP and caching will fail.")
        else:
            print("OK: Redis connected.")

    @app.on_event("shutdown")
    async def on_shutdown():
        await engine.dispose()

    # ── Health check ───────────────────────────────────────────────
    @app.get("/", tags=["Health"])
    async def root():
        redis_ok = await ping_redis()
        return JSONResponse({
            "app": settings.PROJECT_NAME,
            "status": "online",
            "environment": settings.ENVIRONMENT,
            "redis": "ok" if redis_ok else "unreachable",
        })

    @app.get("/health", tags=["Health"])
    async def health():
        return {"status": "ok"}

    return app
