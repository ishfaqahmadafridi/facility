"""
alembic/env.py
──────────────────────────────────────────────────────────────────
Alembic migration environment.
Uses the SYNC database URL from settings (asyncpg → psycopg2).
"""
import os
import sys
from logging.config import fileConfig

from alembic import context
from sqlalchemy import engine_from_config, pool

# ── Make app importable from here ──────────────────────────────────
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from app.core.config import settings
from app.db.base import Base  # noqa: F401 — needed to register models

# ── Import ALL models so Alembic sees them ─────────────────────────
# Add new models here as each session is implemented
import app.modules.auth.models      # noqa: F401
import app.modules.users.models     # noqa: F401
import app.modules.providers.models # noqa: F401
import app.modules.rides.models     # noqa: F401
import app.modules.bookings.models  # noqa: F401
import app.modules.subscriptions.models  # noqa: F401
import app.modules.payments.models  # noqa: F401
import app.modules.ratings.models   # noqa: F401
import app.modules.location.models  # noqa: F401
import app.modules.roadside.models  # noqa: F401

# ── Alembic config ─────────────────────────────────────────────────
config = context.config
config.set_main_option("sqlalchemy.url", settings.DATABASE_URL_SYNC)

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

target_metadata = Base.metadata


def run_migrations_offline() -> None:
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
        compare_type=True,
    )
    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online() -> None:
    connectable = engine_from_config(
        config.get_section(config.config_ini_section, {}),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )
    with connectable.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=target_metadata,
            compare_type=True,
        )
        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
