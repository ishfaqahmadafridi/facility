# Facility - Service Bidding Marketplace

A professional, cross-platform service bidding marketplace for the Pakistani market. Connects customers with verified blue-collar workers, mechanics, and home nurses through a real-time bidding system.

## 🚀 Features

- **Real-time Bidding**: Instant updates for job requests and service provider bids.
- **Specialized Modules**:
    - **Workers**: Painters, Labourers, Contractors with portfolio verification.
    - **Mechanics**: Car/Bike services with tool attestation.
    - **Home Nurses**: Medical care with mandatory HCS/PNMC certification gates.
- **Secure Authentication**: Email OTP verification with Stateless JWT sessions.
- **In-App Governance**: Integrated Super-Admin dashboard for real-time moderation.
- **Clean Architecture**: DDD-inspired backend for high scalability and maintainability.

## 🛠️ Tech Stack

- **Backend**: Python (FastAPI), MongoDB, Redis.
- **Frontend**: Flutter (Mobile - Android/iOS).
- **Communication**: WebSockets for real-time sync.
- **Integration**: JazzCash (Payments), Google Maps (Geo-location).

## 📂 Project Structure

```text
/backend          - Python FastAPI heart
    /app
        /api      - API Route handlers
        /core     - Security & Configuration
        /crud     - Repository layer (Clean Arch)
        /db       - Database connection & Base Repos
        /modules  - Specialized domain logic (Nurses, Mechanics, etc.)
        /services - Business logic orchestration
        /ws       - Real-time WebSocket manager
/mobile_app       - Flutter mobile client
```

## ⚙️ Setup & Installation

### Backend
1. **Navigate to backend folder**:
   ```bash
   cd backend
   ```
2. **Start Services (Docker)**:
   Ensure Docker is running and execute:
   ```bash
   docker-compose up -d
   ```
   *Note: If Docker is not available, the backend will start in **In-Memory Mock Mode**.*
3. **Run the Server**:
   ```bash
   .\venv\Scripts\activate
   uvicorn app.main:app --reload
   ```

### Frontend (Flutter)
1. **Navigate to mobile_app folder**:
   ```bash
   cd mobile_app
   ```
2. **Get Packages**:
   ```bash
   flutter pub get
   ```
3. **Run the App**:
   ```bash
   flutter run
   ```

## 🔌 Connectivity & Verification
The mobile app is configured in `lib/services/api_service.dart` to connect to `10.0.2.2:8000`. 
- **Android Emulator**: Works automatically.
- **Physical Device**: Update `baseUrl` in `api_service.dart` to your computer's local IP (e.g., `192.168.x.x`).

**To verify the connection:**
1. Start the backend.
2. Visit `http://127.0.0.1:8000/docs` in your browser.
3. Launch the mobile app. If you see the job feed or can request an OTP, the connection is successful.

## 🛡️ Security & Compliance

- **HCS Attestation**: Nurses cannot bid until their license is verified.
- **Data Encryption**: AES-256 for health data.
- **Rate Limiting**: Protected against API spikes.

## 📄 License & Development

Implemented by **Antigravity AI Team** with a 10-year senior developer architecture standard.
