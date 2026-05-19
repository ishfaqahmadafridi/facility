"""
Revision: 001_initial_schema
──────────────────────────────────────────────────────────────────
Creates ALL core tables for SUPERAPP Pakistan.

Tables:
    users, providers, provider_skills, locations,
    rides, ride_bids, bookings, subscriptions,
    subscription_visits, payments, ratings, wallet_transactions

Run with:
    cd backend
    alembic upgrade head
"""
import uuid
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects.postgresql import UUID, ARRAY, JSONB

# revision identifiers
revision = "001_initial_schema"
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    # ── Enable extensions ────────────────────────────────────────────
    op.execute("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\"")
    op.execute("CREATE EXTENSION IF NOT EXISTS postgis")

    # ── Enum types ───────────────────────────────────────────────────
    # User
    op.execute("CREATE TYPE user_role AS ENUM ('CUSTOMER','PROVIDER','ADMIN')")
    op.execute("CREATE TYPE user_status AS ENUM ('ACTIVE','SUSPENDED','BANNED')")
    op.execute("CREATE TYPE preferred_language AS ENUM ('en','ur')")

    # Provider
    op.execute("CREATE TYPE approval_status AS ENUM ('PENDING','APPROVED','REJECTED')")
    op.execute("CREATE TYPE provider_vertical AS ENUM ('RIDE','NURSE','REPAIR','ROADSIDE')")
    op.execute("CREATE TYPE skill_category AS ENUM ("
               "'BIKE_RIDER','CAR_DRIVER','RN','LPN','CAREGIVER',"
               "'PLUMBER','ELECTRICIAN','MISTRI','MAZDOOR','AC_TECHNICIAN',"
               "'MECHANIC','TYRE_EXPERT','BATTERY_EXPERT')")

    # Ride
    op.execute("CREATE TYPE ride_status AS ENUM ("
               "'REQUESTED','BROADCASTING','NEGOTIATING','CONFIRMED',"
               "'IN_PROGRESS','COMPLETED','CANCELLED')")
    op.execute("CREATE TYPE bid_type AS ENUM ('ACCEPT','COUNTER','REJECT')")
    op.execute("CREATE TYPE vehicle_type AS ENUM ('BIKE','RICKSHAW','CAR','VAN')")

    # Booking
    op.execute("CREATE TYPE booking_status AS ENUM ("
               "'REQUESTED','SEARCHING','ACCEPTED','EN_ROUTE',"
               "'ARRIVED','IN_PROGRESS','COMPLETED','CANCELLED')")
    op.execute("CREATE TYPE booking_vertical AS ENUM ("
               "'NURSE','PLUMBER','ELECTRICIAN','MISTRI','MAZDOOR','AC_TECHNICIAN')")

    # Subscription
    op.execute("CREATE TYPE plan_type AS ENUM ('DAILY','WEEKLY','MONTHLY')")
    op.execute("CREATE TYPE subscription_frequency AS ENUM ("
               "'ONCE_DAILY','TWICE_DAILY','ALTERNATE_DAYS','WEEKLY')")
    op.execute("CREATE TYPE subscription_status AS ENUM ("
               "'ACTIVE','PAUSED','CANCELLED','EXPIRED')")
    op.execute("CREATE TYPE visit_status AS ENUM ("
               "'SCHEDULED','COMPLETED','MISSED','CANCELLED')")

    # Payment
    op.execute("CREATE TYPE payment_method AS ENUM ("
               "'CASH','JAZZCASH','EASYPAISA','WALLET')")
    op.execute("CREATE TYPE payment_status AS ENUM ("
               "'PENDING','COMPLETED','FAILED','REFUNDED')")
    op.execute("CREATE TYPE payment_reference_type AS ENUM ("
               "'RIDE','BOOKING','SUBSCRIPTION','WALLET_TOPUP')")
    op.execute("CREATE TYPE wallet_transaction_type AS ENUM ('CREDIT','DEBIT')")

    # Rating
    op.execute("CREATE TYPE rating_reference_type AS ENUM ('RIDE','BOOKING')")

    # Roadside
    op.execute("CREATE TYPE roadside_issue_type AS ENUM ("
               "'PUNCTURE','BATTERY','FUEL','BREAKDOWN','TOWING','OTHER')")
    op.execute("CREATE TYPE roadside_status AS ENUM ("
               "'REQUESTED','BROADCASTING','ACCEPTED','EN_ROUTE',"
               "'ARRIVED','IN_PROGRESS','COMPLETED','CANCELLED')")

    # ── TABLE: users ─────────────────────────────────────────────────
    op.create_table(
        "users",
        sa.Column("id", UUID(as_uuid=True), primary_key=True, server_default=sa.text("uuid_generate_v4()")),
        sa.Column("phone", sa.String(20), nullable=False, unique=True),
        sa.Column("full_name", sa.String(120), nullable=True),
        sa.Column("roles", ARRAY(sa.Text), nullable=False, server_default="{'CUSTOMER'}"),
        sa.Column("status", sa.Text, nullable=False, server_default="ACTIVE"),
        sa.Column("wallet_balance", sa.Numeric(12, 2), nullable=False, server_default="0.00"),
        sa.Column("preferred_lang", sa.Text, nullable=False, server_default="en"),
        sa.Column("fcm_token", sa.Text, nullable=True),
        sa.Column("avatar_url", sa.Text, nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now(), onupdate=sa.func.now(), nullable=False),
        sa.Column("deleted_at", sa.DateTime(timezone=True), nullable=True),
    )
    op.create_index("ix_users_phone", "users", ["phone"], unique=True)
    op.create_index("ix_users_status", "users", ["status"])

    # ── TABLE: otp_sessions ──────────────────────────────────────────
    op.create_table(
        "otp_sessions",
        sa.Column("id", UUID(as_uuid=True), primary_key=True, server_default=sa.text("uuid_generate_v4()")),
        sa.Column("phone", sa.String(20), nullable=False),
        sa.Column("attempts", sa.SmallInteger, nullable=False, server_default="0"),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("verified_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
    )
    op.create_index("ix_otp_sessions_phone", "otp_sessions", ["phone"])

    # ── TABLE: refresh_tokens ────────────────────────────────────────
    op.create_table(
        "refresh_tokens",
        sa.Column("id", UUID(as_uuid=True), primary_key=True, server_default=sa.text("uuid_generate_v4()")),
        sa.Column("user_id", UUID(as_uuid=True), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False),
        sa.Column("token_hash", sa.String(256), nullable=False, unique=True),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("revoked_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
    )
    op.create_index("ix_refresh_tokens_user_id", "refresh_tokens", ["user_id"])

    # ── TABLE: providers ─────────────────────────────────────────────
    op.create_table(
        "providers",
        sa.Column("id", UUID(as_uuid=True), primary_key=True, server_default=sa.text("uuid_generate_v4()")),
        sa.Column("user_id", UUID(as_uuid=True), sa.ForeignKey("users.id", ondelete="RESTRICT"), nullable=False, unique=True),
        sa.Column("verticals", ARRAY(sa.Text), nullable=False, server_default="{}"),
        sa.Column("cnic_number", sa.String(15), nullable=True),
        sa.Column("cnic_doc_url", sa.Text, nullable=True),
        sa.Column("license_doc_url", sa.Text, nullable=True),
        sa.Column("approval_status", sa.Text, nullable=False, server_default="PENDING"),
        sa.Column("is_available", sa.Boolean, nullable=False, server_default="false"),
        sa.Column("vehicle_type", sa.Text, nullable=True),
        sa.Column("vehicle_number", sa.String(20), nullable=True),
        sa.Column("avg_rating", sa.Numeric(3, 2), nullable=False, server_default="0.00"),
        sa.Column("total_jobs", sa.Integer, nullable=False, server_default="0"),
        sa.Column("response_rate", sa.Numeric(5, 2), nullable=False, server_default="0.00"),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column("deleted_at", sa.DateTime(timezone=True), nullable=True),
    )
    op.create_index("ix_providers_user_id", "providers", ["user_id"], unique=True)
    op.create_index("ix_providers_approval_status", "providers", ["approval_status"])
    op.create_index("ix_providers_is_available", "providers", ["is_available"])

    # ── TABLE: provider_skills ───────────────────────────────────────
    op.create_table(
        "provider_skills",
        sa.Column("id", UUID(as_uuid=True), primary_key=True, server_default=sa.text("uuid_generate_v4()")),
        sa.Column("provider_id", UUID(as_uuid=True), sa.ForeignKey("providers.id", ondelete="RESTRICT"), nullable=False),
        sa.Column("category", sa.Text, nullable=False),
        sa.Column("sub_category", sa.String(80), nullable=True),
        sa.Column("verified_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
    )
    op.create_index("ix_provider_skills_provider_id", "provider_skills", ["provider_id"])
    op.create_index("ix_provider_skills_category", "provider_skills", ["category"])

    # ── TABLE: locations ─────────────────────────────────────────────
    # Hot data also cached in Redis GEOADD driver:locations
    op.create_table(
        "locations",
        sa.Column("id", UUID(as_uuid=True), primary_key=True, server_default=sa.text("uuid_generate_v4()")),
        sa.Column("provider_id", UUID(as_uuid=True), sa.ForeignKey("providers.id", ondelete="RESTRICT"), nullable=False),
        sa.Column("lat", sa.Numeric(10, 7), nullable=False),
        sa.Column("lng", sa.Numeric(10, 7), nullable=False),
        sa.Column("accuracy", sa.Numeric(6, 2), nullable=True),
        sa.Column("recorded_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
    )
    op.create_index("ix_locations_provider_id", "locations", ["provider_id"])
    op.create_index("ix_locations_recorded_at", "locations", ["recorded_at"])

    # ── TABLE: rides ─────────────────────────────────────────────────
    op.create_table(
        "rides",
        sa.Column("id", UUID(as_uuid=True), primary_key=True, server_default=sa.text("uuid_generate_v4()")),
        sa.Column("customer_id", UUID(as_uuid=True), sa.ForeignKey("users.id", ondelete="RESTRICT"), nullable=False),
        sa.Column("provider_id", UUID(as_uuid=True), sa.ForeignKey("providers.id", ondelete="RESTRICT"), nullable=True),
        sa.Column("pickup_lat", sa.Numeric(10, 7), nullable=False),
        sa.Column("pickup_lng", sa.Numeric(10, 7), nullable=False),
        sa.Column("pickup_address", sa.Text, nullable=True),
        sa.Column("drop_lat", sa.Numeric(10, 7), nullable=False),
        sa.Column("drop_lng", sa.Numeric(10, 7), nullable=False),
        sa.Column("drop_address", sa.Text, nullable=True),
        sa.Column("vehicle_type", sa.Text, nullable=False, server_default="BIKE"),
        sa.Column("offered_price", sa.Numeric(10, 2), nullable=False),
        sa.Column("final_price", sa.Numeric(10, 2), nullable=True),
        sa.Column("distance_km", sa.Numeric(8, 3), nullable=True),
        sa.Column("status", sa.Text, nullable=False, server_default="REQUESTED"),
        sa.Column("payment_method", sa.Text, nullable=False, server_default="CASH"),
        sa.Column("cancel_reason", sa.Text, nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column("deleted_at", sa.DateTime(timezone=True), nullable=True),
    )
    op.create_index("ix_rides_customer_id", "rides", ["customer_id"])
    op.create_index("ix_rides_provider_id", "rides", ["provider_id"])
    op.create_index("ix_rides_status", "rides", ["status"])
    op.create_index("ix_rides_created_at", "rides", ["created_at"])

    # ── TABLE: ride_bids ─────────────────────────────────────────────
    op.create_table(
        "ride_bids",
        sa.Column("id", UUID(as_uuid=True), primary_key=True, server_default=sa.text("uuid_generate_v4()")),
        sa.Column("ride_id", UUID(as_uuid=True), sa.ForeignKey("rides.id", ondelete="RESTRICT"), nullable=False),
        sa.Column("provider_id", UUID(as_uuid=True), sa.ForeignKey("providers.id", ondelete="RESTRICT"), nullable=False),
        sa.Column("amount", sa.Numeric(10, 2), nullable=False),
        sa.Column("bid_type", sa.Text, nullable=False),
        sa.Column("message", sa.Text, nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
    )
    op.create_index("ix_ride_bids_ride_id", "ride_bids", ["ride_id"])
    op.create_index("ix_ride_bids_provider_id", "ride_bids", ["provider_id"])

    # ── TABLE: bookings ──────────────────────────────────────────────
    op.create_table(
        "bookings",
        sa.Column("id", UUID(as_uuid=True), primary_key=True, server_default=sa.text("uuid_generate_v4()")),
        sa.Column("customer_id", UUID(as_uuid=True), sa.ForeignKey("users.id", ondelete="RESTRICT"), nullable=False),
        sa.Column("provider_id", UUID(as_uuid=True), sa.ForeignKey("providers.id", ondelete="RESTRICT"), nullable=True),
        sa.Column("vertical", sa.Text, nullable=False),
        sa.Column("service_type", sa.String(80), nullable=False),
        sa.Column("address_text", sa.Text, nullable=False),
        sa.Column("address_lat", sa.Numeric(10, 7), nullable=False),
        sa.Column("address_lng", sa.Numeric(10, 7), nullable=False),
        sa.Column("scheduled_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("checkin_otp", sa.String(6), nullable=True),
        sa.Column("status", sa.Text, nullable=False, server_default="REQUESTED"),
        sa.Column("offered_price", sa.Numeric(10, 2), nullable=True),
        sa.Column("final_price", sa.Numeric(10, 2), nullable=True),
        sa.Column("payment_method", sa.Text, nullable=False, server_default="CASH"),
        sa.Column("notes", sa.Text, nullable=True),
        sa.Column("cancel_reason", sa.Text, nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column("deleted_at", sa.DateTime(timezone=True), nullable=True),
    )
    op.create_index("ix_bookings_customer_id", "bookings", ["customer_id"])
    op.create_index("ix_bookings_provider_id", "bookings", ["provider_id"])
    op.create_index("ix_bookings_status", "bookings", ["status"])
    op.create_index("ix_bookings_vertical", "bookings", ["vertical"])

    # ── TABLE: subscriptions ─────────────────────────────────────────
    op.create_table(
        "subscriptions",
        sa.Column("id", UUID(as_uuid=True), primary_key=True, server_default=sa.text("uuid_generate_v4()")),
        sa.Column("customer_id", UUID(as_uuid=True), sa.ForeignKey("users.id", ondelete="RESTRICT"), nullable=False),
        sa.Column("provider_id", UUID(as_uuid=True), sa.ForeignKey("providers.id", ondelete="RESTRICT"), nullable=True),
        sa.Column("plan_type", sa.Text, nullable=False),
        sa.Column("frequency", sa.Text, nullable=False),
        sa.Column("duration_months", sa.SmallInteger, nullable=False, server_default="1"),
        sa.Column("start_date", sa.Date, nullable=False),
        sa.Column("end_date", sa.Date, nullable=False),
        sa.Column("status", sa.Text, nullable=False, server_default="ACTIVE"),
        sa.Column("monthly_amount", sa.Numeric(10, 2), nullable=False),
        sa.Column("auto_renew", sa.Boolean, nullable=False, server_default="true"),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column("deleted_at", sa.DateTime(timezone=True), nullable=True),
    )
    op.create_index("ix_subscriptions_customer_id", "subscriptions", ["customer_id"])
    op.create_index("ix_subscriptions_status", "subscriptions", ["status"])

    # ── TABLE: subscription_visits ───────────────────────────────────
    op.create_table(
        "subscription_visits",
        sa.Column("id", UUID(as_uuid=True), primary_key=True, server_default=sa.text("uuid_generate_v4()")),
        sa.Column("subscription_id", UUID(as_uuid=True), sa.ForeignKey("subscriptions.id", ondelete="RESTRICT"), nullable=False),
        sa.Column("scheduled_date", sa.Date, nullable=False),
        sa.Column("status", sa.Text, nullable=False, server_default="SCHEDULED"),
        sa.Column("checkin_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("checkout_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("notes", sa.Text, nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
    )
    op.create_index("ix_subscription_visits_subscription_id", "subscription_visits", ["subscription_id"])
    op.create_index("ix_subscription_visits_scheduled_date", "subscription_visits", ["scheduled_date"])

    # ── TABLE: payments ──────────────────────────────────────────────
    op.create_table(
        "payments",
        sa.Column("id", UUID(as_uuid=True), primary_key=True, server_default=sa.text("uuid_generate_v4()")),
        sa.Column("reference_id", UUID(as_uuid=True), nullable=False),
        sa.Column("reference_type", sa.Text, nullable=False),
        sa.Column("customer_id", UUID(as_uuid=True), sa.ForeignKey("users.id", ondelete="RESTRICT"), nullable=False),
        sa.Column("provider_id", UUID(as_uuid=True), sa.ForeignKey("providers.id", ondelete="RESTRICT"), nullable=True),
        sa.Column("gross_amount", sa.Numeric(12, 2), nullable=False),
        sa.Column("commission_amount", sa.Numeric(12, 2), nullable=False, server_default="0.00"),
        sa.Column("net_amount", sa.Numeric(12, 2), nullable=False),
        sa.Column("method", sa.Text, nullable=False),
        sa.Column("gateway_ref", sa.String(128), nullable=True),
        sa.Column("gateway_response", JSONB, nullable=True),
        sa.Column("status", sa.Text, nullable=False, server_default="PENDING"),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
    )
    op.create_index("ix_payments_reference_id", "payments", ["reference_id"])
    op.create_index("ix_payments_customer_id", "payments", ["customer_id"])
    op.create_index("ix_payments_status", "payments", ["status"])

    # ── TABLE: ratings ───────────────────────────────────────────────
    op.create_table(
        "ratings",
        sa.Column("id", UUID(as_uuid=True), primary_key=True, server_default=sa.text("uuid_generate_v4()")),
        sa.Column("rater_id", UUID(as_uuid=True), sa.ForeignKey("users.id", ondelete="RESTRICT"), nullable=False),
        sa.Column("ratee_id", UUID(as_uuid=True), sa.ForeignKey("users.id", ondelete="RESTRICT"), nullable=False),
        sa.Column("reference_id", UUID(as_uuid=True), nullable=False),
        sa.Column("reference_type", sa.Text, nullable=False),
        sa.Column("score", sa.SmallInteger, nullable=False),
        sa.Column("comment", sa.Text, nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.CheckConstraint("score >= 1 AND score <= 5", name="ck_ratings_score_range"),
    )
    op.create_index("ix_ratings_ratee_id", "ratings", ["ratee_id"])
    op.create_index("ix_ratings_reference_id", "ratings", ["reference_id"])

    # ── TABLE: wallet_transactions ───────────────────────────────────
    op.create_table(
        "wallet_transactions",
        sa.Column("id", UUID(as_uuid=True), primary_key=True, server_default=sa.text("uuid_generate_v4()")),
        sa.Column("user_id", UUID(as_uuid=True), sa.ForeignKey("users.id", ondelete="RESTRICT"), nullable=False),
        sa.Column("amount", sa.Numeric(12, 2), nullable=False),
        sa.Column("type", sa.Text, nullable=False),
        sa.Column("balance_after", sa.Numeric(12, 2), nullable=False),
        sa.Column("reference", sa.String(128), nullable=True),
        sa.Column("description", sa.Text, nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
    )
    op.create_index("ix_wallet_transactions_user_id", "wallet_transactions", ["user_id"])
    op.create_index("ix_wallet_transactions_created_at", "wallet_transactions", ["created_at"])

    # ── TABLE: roadside_requests ─────────────────────────────────────
    op.create_table(
        "roadside_requests",
        sa.Column("id", UUID(as_uuid=True), primary_key=True, server_default=sa.text("uuid_generate_v4()")),
        sa.Column("customer_id", UUID(as_uuid=True), sa.ForeignKey("users.id", ondelete="RESTRICT"), nullable=False),
        sa.Column("provider_id", UUID(as_uuid=True), sa.ForeignKey("providers.id", ondelete="RESTRICT"), nullable=True),
        sa.Column("issue_type", sa.Text, nullable=False),
        sa.Column("lat", sa.Numeric(10, 7), nullable=False),
        sa.Column("lng", sa.Numeric(10, 7), nullable=False),
        sa.Column("address_text", sa.Text, nullable=True),
        sa.Column("description", sa.Text, nullable=True),
        sa.Column("status", sa.Text, nullable=False, server_default="REQUESTED"),
        sa.Column("broadcast_radius_km", sa.Numeric(5, 2), nullable=False, server_default="3.0"),
        sa.Column("final_price", sa.Numeric(10, 2), nullable=True),
        sa.Column("payment_method", sa.Text, nullable=False, server_default="CASH"),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column("deleted_at", sa.DateTime(timezone=True), nullable=True),
    )
    op.create_index("ix_roadside_requests_customer_id", "roadside_requests", ["customer_id"])
    op.create_index("ix_roadside_requests_status", "roadside_requests", ["status"])


def downgrade() -> None:
    # Drop tables in reverse FK order
    op.drop_table("roadside_requests")
    op.drop_table("wallet_transactions")
    op.drop_table("ratings")
    op.drop_table("payments")
    op.drop_table("subscription_visits")
    op.drop_table("subscriptions")
    op.drop_table("bookings")
    op.drop_table("ride_bids")
    op.drop_table("rides")
    op.drop_table("locations")
    op.drop_table("provider_skills")
    op.drop_table("providers")
    op.drop_table("refresh_tokens")
    op.drop_table("otp_sessions")
    op.drop_table("users")

    # Drop enum types
    for t in [
        "roadside_status", "roadside_issue_type",
        "rating_reference_type",
        "wallet_transaction_type", "payment_reference_type",
        "payment_status", "payment_method",
        "visit_status", "subscription_status",
        "subscription_frequency", "plan_type",
        "booking_vertical", "booking_status",
        "vehicle_type", "bid_type", "ride_status",
        "skill_category", "provider_vertical", "approval_status",
        "preferred_language", "user_status", "user_role",
    ]:
        op.execute(f"DROP TYPE IF EXISTS {t}")
