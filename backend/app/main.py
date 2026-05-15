"""Expose the Django ASGI application under ``app.main:app``.

This keeps existing Uvicorn commands working even though the project's
canonical ASGI entrypoint lives in ``config.asgi``.
"""

from config.asgi import application

app = application
