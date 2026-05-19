"""
app/common/responses.py
──────────────────────────────────────────────────────────────────
Standardized API response wrapper.

Every endpoint returns one of:
    success_response(data, message)   → 200/201
    error_response(code, message)     → used in exception handlers

Shape:
    {
        "success": true,
        "message": "Ride created successfully.",
        "data": { ... },
        "timestamp": "2024-01-01T12:00:00Z"
    }
"""
from datetime import datetime, timezone
from typing import Any, Optional

from fastapi.responses import JSONResponse


def success_response(
    data: Any = None,
    message: str = "Success",
    status_code: int = 200,
) -> JSONResponse:
    return JSONResponse(
        status_code=status_code,
        content={
            "success": True,
            "message": message,
            "data": data,
            "timestamp": datetime.now(timezone.utc).isoformat(),
        },
    )


def created_response(data: Any = None, message: str = "Created successfully") -> JSONResponse:
    return success_response(data=data, message=message, status_code=201)


def paginated_response(
    items: list,
    total: int,
    page: int,
    page_size: int,
    message: str = "Success",
) -> JSONResponse:
    return JSONResponse(
        status_code=200,
        content={
            "success": True,
            "message": message,
            "data": {
                "items": items,
                "pagination": {
                    "total": total,
                    "page": page,
                    "page_size": page_size,
                    "total_pages": (total + page_size - 1) // page_size,
                },
            },
            "timestamp": datetime.now(timezone.utc).isoformat(),
        },
    )
