# SUPERAPP Pakistan — Master Implementation Plan
## Stack: Flutter (Dart) · FastAPI (Python) · PostgreSQL · Redis · WebSockets

> **Status**: 📁 Structure scaffolded — 191 files created on disk. Ready for implementation.

---

## ✅ Physical File Tree (Created on Disk)

```
App/
│
├── backend/
│   ├── alembic/
│   │   ├── env.py
│   │   ├── script.py.mako
│   │   └── versions/
│   │       └── 001_initial_schema.py       ← SESSION 01
│   ├── alembic.ini
│   ├── pytest.ini
│   ├── requirements.txt
│   │
│   ├── app/
│   │   ├── main.py
│   │   │
│   │   ├── common/                         ← SESSION 01
│   │   │   ├── enums.py                    ← All system enums (RideStatus, BookingStatus...)
│   │   │   ├── exceptions.py               ← Custom HTTP exceptions
│   │   │   ├── responses.py                ← Standardized response wrapper
│   │   │   └── constants.py                ← Magic-string-free constants
│   │   │
│   │   ├── core/
│   │   │   ├── config.py                   ← SESSION 01 (add PG + Redis URLs)
│   │   │   ├── security.py                 ← SESSION 02 (JWT helpers)
│   │   │   ├── otp.py                      ← SESSION 02 (SMS OTP)
│   │   │   └── app_factory.py              ← Updated each session
│   │   │
│   │   ├── db/
│   │   │   ├── postgres.py                 ← SESSION 01 (async engine + session)
│   │   │   ├── base.py                     ← SESSION 01 (Base + TimestampMixin)
│   │   │   └── redis.py                    ← SESSION 01 (Redis client)
│   │   │
│   │   ├── modules/
│   │   │   │
│   │   │   ├── auth/                       ← SESSION 02
│   │   │   │   ├── models.py               ← OTP session table
│   │   │   │   ├── schemas.py              ← Pydantic request/response
│   │   │   │   ├── repository.py           ← DB queries
│   │   │   │   ├── service.py              ← Business logic
│   │   │   │   └── router.py               ← REST endpoints
│   │   │   │
│   │   │   ├── users/                      ← SESSION 03
│   │   │   │   ├── models.py
│   │   │   │   ├── schemas.py
│   │   │   │   ├── repository.py
│   │   │   │   ├── service.py
│   │   │   │   └── router.py
│   │   │   │
│   │   │   ├── providers/                  ← SESSION 03
│   │   │   │   ├── models.py
│   │   │   │   ├── schemas.py
│   │   │   │   ├── repository.py
│   │   │   │   ├── service.py
│   │   │   │   └── router.py
│   │   │   │
│   │   │   ├── location/                   ← SESSION 04
│   │   │   │   ├── models.py
│   │   │   │   ├── schemas.py
│   │   │   │   ├── repository.py
│   │   │   │   └── service.py
│   │   │   │
│   │   │   ├── rides/                      ← SESSION 05
│   │   │   │   ├── models.py
│   │   │   │   ├── schemas.py
│   │   │   │   ├── repository.py
│   │   │   │   ├── service.py
│   │   │   │   ├── router.py
│   │   │   │   └── state_machine.py        ← Ride lifecycle transitions
│   │   │   │
│   │   │   ├── matching/                   ← SESSION 05
│   │   │   │   ├── engine.py               ← Orchestrates scoring + broadcast
│   │   │   │   ├── scorer.py               ← Score formula
│   │   │   │   ├── broadcast.py            ← Top-10 broadcast logic
│   │   │   │   └── geo_query.py            ← PostGIS radius query
│   │   │   │
│   │   │   ├── bookings/                   ← SESSION 06
│   │   │   │   ├── models.py
│   │   │   │   ├── schemas.py
│   │   │   │   ├── repository.py
│   │   │   │   ├── service.py
│   │   │   │   ├── router.py
│   │   │   │   └── state_machine.py        ← Job lifecycle transitions
│   │   │   │
│   │   │   ├── roadside/                   ← SESSION 07
│   │   │   │   ├── models.py
│   │   │   │   ├── schemas.py
│   │   │   │   ├── repository.py
│   │   │   │   ├── service.py
│   │   │   │   ├── router.py
│   │   │   │   └── emergency_queue.py      ← Priority queue + expanding radius
│   │   │   │
│   │   │   ├── payments/                   ← SESSION 08
│   │   │   │   ├── models.py
│   │   │   │   ├── schemas.py
│   │   │   │   ├── repository.py
│   │   │   │   ├── service.py
│   │   │   │   ├── router.py
│   │   │   │   ├── jazzcash.py             ← JazzCash gateway
│   │   │   │   ├── easypaisa.py            ← EasyPaisa gateway
│   │   │   │   └── wallet.py               ← In-app wallet + ledger
│   │   │   │
│   │   │   ├── ratings/                    ← SESSION 09
│   │   │   │   ├── models.py
│   │   │   │   ├── schemas.py
│   │   │   │   ├── repository.py
│   │   │   │   ├── service.py
│   │   │   │   └── router.py
│   │   │   │
│   │   │   ├── subscriptions/              ← SESSION 10
│   │   │   │   ├── models.py
│   │   │   │   ├── schemas.py
│   │   │   │   ├── repository.py
│   │   │   │   ├── service.py
│   │   │   │   └── router.py
│   │   │   │
│   │   │   ├── notifications/              ← SESSION 13
│   │   │   │   ├── sms.py
│   │   │   │   ├── push.py
│   │   │   │   ├── service.py
│   │   │   │   └── router.py
│   │   │   │
│   │   │   └── admin/                      ← SESSION 12
│   │   │       ├── schemas.py
│   │   │       ├── service.py
│   │   │       └── router.py
│   │   │
│   │   ├── ws/                             ← Real-time WebSocket gateways
│   │   │   ├── ride_gateway.py             ← SESSION 05 (/ride namespace)
│   │   │   ├── booking_gateway.py          ← SESSION 06 (/booking namespace)
│   │   │   ├── location_gateway.py         ← SESSION 04 (/location namespace)
│   │   │   └── negotiation_gateway.py      ← SESSION 05 (/negotiation namespace)
│   │   │
│   │   └── services/                       ← Shared infrastructure services
│   │       ├── redis_service.py            ← SESSION 04
│   │       ├── storage_service.py          ← SESSION 03
│   │       └── sms_service.py              ← SESSION 02
│   │
│   └── tests/
│       ├── unit/
│       │   ├── test_auth_service.py        ← SESSION 02
│       │   ├── test_ride_service.py        ← SESSION 05
│       │   ├── test_matching_engine.py     ← SESSION 05
│       │   └── test_payment_service.py     ← SESSION 08
│       └── integration/
│           ├── test_auth_api.py
│           ├── test_ride_api.py
│           └── test_booking_api.py
│
└── mobile_app/
    ├── pubspec.yaml
    └── lib/
        ├── main.dart
        ├── app.dart                         ← MaterialApp, routing, providers
        │
        ├── config/
        │   ├── app_config.dart              ← Env-based config
        │   └── routes.dart                  ← Named route definitions
        │
        ├── theme/
        │   ├── app_theme.dart               ← ThemeData
        │   ├── app_colors.dart              ← Color tokens
        │   └── app_text_styles.dart         ← Typography
        │
        ├── utils/
        │   ├── validators.dart              ← Phone, OTP validators
        │   ├── formatters.dart              ← Price, date formatters
        │   └── extensions.dart              ← String/DateTime extensions
        │
        ├── l10n/
        │   ├── strings_en.dart              ← SESSION 14
        │   └── strings_ur.dart              ← SESSION 14
        │
        ├── models/
        │   ├── user_model.dart
        │   ├── provider_model.dart
        │   ├── ride_model.dart
        │   ├── bid_model.dart
        │   ├── booking_model.dart
        │   ├── subscription_model.dart
        │   ├── payment_model.dart
        │   ├── rating_model.dart
        │   ├── location_model.dart
        │   └── job_model.dart               ← Already exists
        │
        ├── services/
        │   ├── api_constants.dart           ← Already exists
        │   ├── api_client.dart              ← SESSION 01 (Dio/http base client)
        │   ├── auth_api.dart                ← SESSION 02
        │   ├── ride_api.dart                ← SESSION 05
        │   ├── booking_api.dart             ← SESSION 06
        │   ├── job_api.dart                 ← Already exists
        │   ├── payment_api.dart             ← SESSION 08
        │   ├── location_service.dart        ← SESSION 04
        │   ├── websocket_service.dart       ← SESSION 04
        │   ├── token_service.dart           ← Already exists
        │   ├── storage_service.dart         ← SESSION 03
        │   └── notification_service.dart    ← SESSION 13
        │
        └── src/
            ├── providers/                   ← Global state
            │   ├── auth_provider.dart       ← Already exists (rewrite S02)
            │   ├── job_provider.dart        ← Already exists
            │   ├── location_provider.dart   ← SESSION 04
            │   └── user_provider.dart       ← SESSION 03
            │
            ├── common_widgets/
            │   ├── job_card.dart            ← Already exists
            │   ├── app_button.dart          ← SESSION 01
            │   ├── app_text_field.dart      ← SESSION 01
            │   ├── loading_overlay.dart     ← SESSION 01
            │   ├── error_widget.dart        ← SESSION 01
            │   ├── avatar_widget.dart       ← SESSION 03
            │   ├── star_rating.dart         ← SESSION 09
            │   └── bottom_sheet_handle.dart ← SESSION 01
            │
            ├── shared/
            │   ├── screens/
            │   │   ├── payment_confirm_screen.dart  ← SESSION 08
            │   │   ├── rating_screen.dart            ← SESSION 09
            │   │   ├── chat_window.dart              ← SESSION 05
            │   │   └── profile_screen.dart           ← SESSION 03
            │   └── widgets/
            │       ├── vertical_card.dart
            │       └── map_background.dart
            │
            └── modules/
                │
                ├── auth/                            ← SESSION 02
                │   ├── screens/
                │   │   ├── splash_screen.dart
                │   │   ├── phone_entry_screen.dart
                │   │   └── otp_verification_screen.dart
                │   └── providers/
                │       └── auth_provider.dart
                │
                ├── onboarding/                      ← SESSION 03
                │   └── screens/
                │       ├── role_select_screen.dart
                │       └── permissions_screen.dart
                │
                ├── home/                            ← SESSION 03
                │   ├── screens/
                │   │   └── super_app_home.dart      ← 5-vertical grid + Emergency CTA
                │   └── providers/
                │       └── home_provider.dart
                │
                ├── ride/                            ← SESSION 05
                │   ├── screens/
                │   │   ├── ride_map_screen.dart
                │   │   ├── pick_drop_selector.dart
                │   │   ├── ride_offer_screen.dart
                │   │   ├── searching_drivers_screen.dart
                │   │   ├── negotiation_chat_screen.dart
                │   │   └── ride_active_screen.dart
                │   ├── providers/
                │   │   └── ride_provider.dart
                │   └── widgets/
                │       ├── driver_card.dart
                │       ├── bid_bubble.dart
                │       └── map_pin.dart
                │
                ├── booking/                         ← SESSION 06
                │   ├── screens/
                │   │   ├── service_category_list.dart
                │   │   ├── service_type_select.dart
                │   │   ├── booking_form.dart
                │   │   ├── provider_searching.dart
                │   │   └── job_tracking.dart
                │   ├── providers/
                │   │   └── booking_provider.dart
                │   └── widgets/
                │       └── service_category_card.dart
                │
                ├── nurses/                          ← SESSION 06 + 10
                │   ├── screens/
                │   │   ├── nurse_service_type.dart
                │   │   ├── subscription_plans.dart
                │   │   └── visit_calendar.dart
                │   └── providers/
                │       └── nurse_provider.dart
                │
                ├── mechanics/                       ← SESSION 07
                │   ├── screens/
                │   │   ├── emergency_home.dart
                │   │   ├── issue_type_select.dart
                │   │   └── mechanic_tracking.dart
                │   └── providers/
                │       └── roadside_provider.dart
                │
                └── provider_panel/                  ← SESSION 11
                    ├── screens/
                    │   ├── provider_home.dart
                    │   ├── job_card_detail.dart
                    │   ├── navigate_to_job.dart
                    │   ├── job_active.dart
                    │   └── earnings_dashboard.dart
                    ├── providers/
                    │   └── provider_panel_provider.dart
                    └── widgets/
                        ├── earnings_chart.dart
                        └── job_status_badge.dart
```

---

## Session Roadmap (15 Sessions)

| # | Session | Files Touched | Status |
|---|---------|---------------|--------|
| 01 | Foundation — PostgreSQL + Alembic + Enums | `db/`, `common/`, `alembic/` | ⬜ Pending |
| 02 | Auth — Phone OTP + JWT + Screens | `auth/`, auth screens | ⬜ Pending |
| 03 | User + Provider Profiles + Home | `users/`, `providers/`, home screens | ⬜ Pending |
| 04 | Location — WebSocket + Redis Geo | `location/`, `ws/location_gateway.py` | ⬜ Pending |
| 05 | Ride Hailing — State Machine + Negotiation | `rides/`, `matching/`, ride screens | ⬜ Pending |
| 06 | Home Services — Nurse + Repairs | `bookings/`, booking + nurse screens | ⬜ Pending |
| 07 | Roadside — Emergency Queue | `roadside/`, mechanics screens | ⬜ Pending |
| 08 | Payments — Cash + Wallet + JazzCash | `payments/`, payment screens | ⬜ Pending |
| 09 | Ratings + Trust Layer | `ratings/`, rating screen | ⬜ Pending |
| 10 | Subscriptions — Nurse Plans | `subscriptions/`, subscription screens | ⬜ Pending |
| 11 | Provider Dashboard + Earnings | provider_panel screens | ⬜ Pending |
| 12 | Admin Panel — Web Dashboard | `admin/`, web_dashboard | ⬜ Pending |
| 13 | Notifications — SMS + FCM | `notifications/` | ⬜ Pending |
| 14 | i18n — Urdu + English + RTL | `l10n/` | ⬜ Pending |
| 15 | Polish + Production Hardening | All | ⬜ Pending |

---

> [!IMPORTANT]
> **191 files** created on disk. All empty, waiting for implementation.
> Tell me which session to start: **"Start Session 01"**, **"Start Session 02"**, etc.
