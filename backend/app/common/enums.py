"""
app/common/enums.py
──────────────────────────────────────────────────────────────────
Single source of truth for all system enums.

Rules:
 - DB-level enum types are defined here as Python Enum subclasses.
 - Never use raw strings for status fields — always reference these.
 - When adding a new enum, add it to both Python AND the Alembic
   migration that creates the corresponding column.
"""
import enum


# ── User ───────────────────────────────────────────────────────────

class UserRole(str, enum.Enum):
    CUSTOMER = "CUSTOMER"
    PROVIDER = "PROVIDER"
    ADMIN    = "ADMIN"


class UserStatus(str, enum.Enum):
    ACTIVE    = "ACTIVE"
    SUSPENDED = "SUSPENDED"
    BANNED    = "BANNED"


class PreferredLanguage(str, enum.Enum):
    EN = "en"
    UR = "ur"


# ── Provider ───────────────────────────────────────────────────────

class ApprovalStatus(str, enum.Enum):
    PENDING  = "PENDING"
    APPROVED = "APPROVED"
    REJECTED = "REJECTED"


class ProviderVertical(str, enum.Enum):
    RIDE      = "RIDE"       # Vertical A
    NURSE     = "NURSE"      # Vertical B
    REPAIR    = "REPAIR"     # Vertical C
    ROADSIDE  = "ROADSIDE"   # Vertical D


class SkillCategory(str, enum.Enum):
    # Ride
    BIKE_RIDER   = "BIKE_RIDER"
    CAR_DRIVER   = "CAR_DRIVER"
    # Nurse
    RN           = "RN"           # Registered Nurse
    LPN          = "LPN"          # Licensed Practical Nurse
    CAREGIVER    = "CAREGIVER"
    # Repair
    PLUMBER      = "PLUMBER"
    ELECTRICIAN  = "ELECTRICIAN"
    MISTRI       = "MISTRI"       # Mason / general handyman
    MAZDOOR      = "MAZDOOR"      # Labour / helper
    AC_TECHNICIAN = "AC_TECHNICIAN"
    # Roadside
    MECHANIC     = "MECHANIC"
    TYRE_EXPERT  = "TYRE_EXPERT"
    BATTERY_EXPERT = "BATTERY_EXPERT"


# ── Ride (Vertical A) ──────────────────────────────────────────────

class RideStatus(str, enum.Enum):
    REQUESTED    = "REQUESTED"
    BROADCASTING = "BROADCASTING"
    NEGOTIATING  = "NEGOTIATING"
    CONFIRMED    = "CONFIRMED"
    IN_PROGRESS  = "IN_PROGRESS"
    COMPLETED    = "COMPLETED"
    CANCELLED    = "CANCELLED"


class BidType(str, enum.Enum):
    ACCEPT  = "ACCEPT"
    COUNTER = "COUNTER"
    REJECT  = "REJECT"


class VehicleType(str, enum.Enum):
    BIKE    = "BIKE"
    RICKSHAW = "RICKSHAW"
    CAR     = "CAR"
    VAN     = "VAN"


# ── Booking (Verticals B & C) ──────────────────────────────────────

class BookingStatus(str, enum.Enum):
    REQUESTED    = "REQUESTED"
    SEARCHING    = "SEARCHING"
    ACCEPTED     = "ACCEPTED"
    EN_ROUTE     = "EN_ROUTE"
    ARRIVED      = "ARRIVED"
    IN_PROGRESS  = "IN_PROGRESS"
    COMPLETED    = "COMPLETED"
    CANCELLED    = "CANCELLED"


class BookingVertical(str, enum.Enum):
    NURSE    = "NURSE"
    PLUMBER  = "PLUMBER"
    ELECTRICIAN = "ELECTRICIAN"
    MISTRI   = "MISTRI"
    MAZDOOR  = "MAZDOOR"
    AC_TECHNICIAN = "AC_TECHNICIAN"


# ── Subscription (Vertical B monthly) ─────────────────────────────

class PlanType(str, enum.Enum):
    DAILY   = "DAILY"
    WEEKLY  = "WEEKLY"
    MONTHLY = "MONTHLY"


class SubscriptionFrequency(str, enum.Enum):
    ONCE_DAILY    = "ONCE_DAILY"
    TWICE_DAILY   = "TWICE_DAILY"
    ALTERNATE_DAYS = "ALTERNATE_DAYS"
    WEEKLY        = "WEEKLY"


class SubscriptionStatus(str, enum.Enum):
    ACTIVE    = "ACTIVE"
    PAUSED    = "PAUSED"
    CANCELLED = "CANCELLED"
    EXPIRED   = "EXPIRED"


class VisitStatus(str, enum.Enum):
    SCHEDULED  = "SCHEDULED"
    COMPLETED  = "COMPLETED"
    MISSED     = "MISSED"
    CANCELLED  = "CANCELLED"


# ── Payment ────────────────────────────────────────────────────────

class PaymentMethod(str, enum.Enum):
    CASH      = "CASH"
    JAZZCASH  = "JAZZCASH"
    EASYPAISA = "EASYPAISA"
    WALLET    = "WALLET"


class PaymentStatus(str, enum.Enum):
    PENDING   = "PENDING"
    COMPLETED = "COMPLETED"
    FAILED    = "FAILED"
    REFUNDED  = "REFUNDED"


class PaymentReferenceType(str, enum.Enum):
    RIDE         = "RIDE"
    BOOKING      = "BOOKING"
    SUBSCRIPTION = "SUBSCRIPTION"
    WALLET_TOPUP = "WALLET_TOPUP"


class WalletTransactionType(str, enum.Enum):
    CREDIT = "CREDIT"
    DEBIT  = "DEBIT"


# ── Rating ─────────────────────────────────────────────────────────

class RatingReferenceType(str, enum.Enum):
    RIDE    = "RIDE"
    BOOKING = "BOOKING"


# ── Roadside (Vertical D) ──────────────────────────────────────────

class RoadsideIssueType(str, enum.Enum):
    PUNCTURE   = "PUNCTURE"
    BATTERY    = "BATTERY"     # Jump-start
    FUEL       = "FUEL"
    BREAKDOWN  = "BREAKDOWN"
    TOWING     = "TOWING"
    OTHER      = "OTHER"


class RoadsideStatus(str, enum.Enum):
    REQUESTED    = "REQUESTED"
    BROADCASTING = "BROADCASTING"
    ACCEPTED     = "ACCEPTED"
    EN_ROUTE     = "EN_ROUTE"
    ARRIVED      = "ARRIVED"
    IN_PROGRESS  = "IN_PROGRESS"
    COMPLETED    = "COMPLETED"
    CANCELLED    = "CANCELLED"
