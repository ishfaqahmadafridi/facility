# KamKaro App Implementation Plan

This document provides a comprehensive, deep technical implementation plan for the **KamKaro** mobile application, based on the `idea.odt` specification. It is designed to be the definitive guide during coding to ensure no requirements are missed.

## Executive Summary
**KamKaro** is a hyper-local on-demand services and gig economy super app for Pakistan. The core innovation is a **Single Account, Dual-Mode System** allowing users to seamlessly switch between Customer Mode (hiring services) and Provider Mode (offering services).

## 1. Technology Stack

### Frontend (Mobile App)
*   **Framework**: Flutter (Single codebase for Android & iOS)
*   **State Management**: Riverpod or Provider (to manage the complex Dual-Mode state)
*   **Maps & Location**: `google_maps_flutter`, `geolocator`
*   **Real-time Communication**: Agora SDK (Calls), Firebase Cloud Messaging (FCM for push notifications)
*   **UI/Animations**: `lottie` for subtle animations and pull-to-refresh.

### Backend
*   **Framework**: Django and Django REST Framework (Python)
*   **Database**: PostgreSQL (Relational integrity for transactions/escrow)
*   **Real-time/Chat**: Django Channels (WebSockets)
*   **Authentication**: JWT-based auth + OTP verification via SMS Gateway.

---

## 2. Core Architecture & System Design

### 2.1 The Dual-Mode System
The most critical architectural component. A single `User` entity will have two nested profiles: `CustomerProfile` and `ProviderProfile`.
*   **State Handling**: The app will maintain an `active_mode` state (`CUSTOMER` or `PROVIDER`).
*   **UI Refresh**: Changing the mode will trigger a root-level state rebuild, swapping the Home Screen layout and Navigation Bar completely.

### 2.2 Database Schema (High-Level)
*   **Users**: `id`, `phone_number`, `cnic`, `cnic_front`, `cnic_back`, `selfie`, `active_mode`, `is_verified`
*   **ProviderProfile**: `user_id`, `categories[]`, `experience`, `bio`, `police_verified`, `is_online`, `location`, `rating`
*   **NurseProfile (Extended Provider)**: `provider_id`, `nursing_license`, `specializations[]`, `kit_available`
*   **Jobs/Bookings**: `id`, `customer_id`, `provider_id`, `service_category`, `status` (pending, accepted, in-progress, completed, disputed), `price`, `location`, `escrow_status`
*   **Rides**: `id`, `customer_id`, `rider_id`, `pickup_location`, `dropoff_location`, `suggested_fare`, `status`
*   **Messages**: `id`, `job_id`, `sender_id`, `content`, `type` (text, voice_note), `timestamp`

---

## 3. Module Implementation Details

### Phase 1: Authentication & Onboarding
#### 1.1 Phone Auth & Verification
*   Implement UI with Pakistan (+92) phone number formatting.
*   Integrate SMS gateway for OTP.
#### 1.2 Multi-Step Signup
*   **Step 1-2**: Personal details, CNIC capture, Selfie capture.
*   **Step 3-4 (Role Selection)**: If Provider selected -> Prompt for categories, experience, video intro.
*   **Nurse Special Flow**: Add mandatory upload for Nursing License and health declaration if "Nurse" category is selected.
*   **Step 5-6**: Location setup (GPS + manual), Bio setup.

### Phase 2: Dual-Mode UI & Navigation
#### 2.1 Mode Switching Logic
*   Implement the explicit "Switch Mode" button in the Profile tab.
*   Add a visual indicator in the top header showing the current mode and location.
#### 2.2 Home Screen - Customer Mode
*   Categories Carousel (Home Repair, Labour, Healthcare, Beauty, Rides, etc.).
*   "Services Near Me" using geospatial queries (Radius: 5/10/20 km).
#### 2.3 Home Screen - Provider Mode
*   "Jobs Available Near You" feed.
*   Online/Offline availability toggle.
*   Earnings summary dashboard.

### Phase 3: Booking & Escrow Workflow
#### 3.1 Customer Booking Flow
*   Browse providers -> View detailed profile (About, Rates, Portfolio, Reviews).
*   Post Job / Request Booking -> Map address pinning.
*   **Escrow System**: Customer pays upfront -> Funds held in Escrow -> Released to provider upon job completion confirmation.
#### 3.2 Provider Acceptance Flow
*   Receive push notification for nearby job.
*   Accept job -> Live tracking begins.
#### 3.3 Rides & Transport Module
*   Customer posts ride request with pickup/dropoff pins and suggested fare.
*   Providers in "Rider Mode" receive requests, can accept or counter-offer.

### Phase 4: Communication & Safety
#### 4.1 In-App Chat & Calls
*   Implement WebSockets/Firebase for text and voice note chat.
*   Integrate Agora for free in-app VoIP calls.
#### 4.2 Safety & Moderation
*   **SOS Button**: Red button to share live location with family/police.
*   "Report Issue" workflow for post-job disputes.
*   Women safety filters (e.g., female customers requesting female providers).

### Phase 5: Provider Dashboard & Payments
*   Implement wallet UI showing current balance, escrow balance, and withdrawal options (JazzCash/Easypaisa).
*   Earnings graphs and active job management.

---

## 4. Verification Plan

### Automated Tests
*   **Unit Tests**: Core business logic (Escrow calculation, state management for Mode Switching).
*   **Integration Tests**: API endpoints for Job Creation, Ride Bidding, and Mode Switching.

### Manual Verification
*   **Dual-Mode Test**: Log in, set up as Provider. Switch to Customer Mode, ensure Provider UI disappears. Switch back, ensure state is preserved.
*   **Booking Flow Test**: Simulate a Customer booking a Plumber, test the escrow holding, chat feature, and final payment release.
*   **Location Test**: Verify that the "Work Near Me" radius filter accurately displays providers within 5km, 10km, and 20km.

---

## 5. Addendum: idea.odt Compliance (Missing Features)
Upon cross-referencing with the original `idea.odt` document, the following missing elements will be implemented to ensure 100% compliance:

### 5.1 User Profile Enhancements
*   Add `full_name` and `gender` (M/F/O) to the `User` model (Crucial for Women Safety Filters).
*   Add `emergency_contact` to the `User` model (For the SOS/Family Tracking feature).
*   Add `health_declaration` (FileField) to `NurseProfile`.

### 5.2 Provider Portfolios & Reviews
*   Create a `PortfolioItem` model linked to `ProviderProfile` for uploading past work images.
*   Create a `Review` model linked to `Job` to capture text feedback and star ratings after job completion.

### 5.3 Women Safety Filter & Estimators
*   Update the `ProvidersNearbyView` to allow female customers to filter for female providers only.
*   Add an endpoint for `Labour Rate & Material Estimator` (Returning standard rate cards or logic).
