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

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/ishfaqahmadafridi/facility.git
    cd facility/backend
    ```

2.  **Environment Setup**:
    Create a `.env` file in `/backend` using the template below:
    ```env
    PROJECT_NAME="Facility"
    MONGODB_URL="mongodb://localhost:27017"
    DATABASE_NAME="facility_db"
    SECRET_KEY="your_secret_key"
    REDIS_URL="redis://localhost:6379/0"
    ```

3.  **Run with Virtual Environment**:
    ```bash
    python -m venv venv
    ./venv/Scripts/activate # Windows
    pip install -r requirements.txt
    uvicorn app.main:app --reload
    ```

4.  **Run Services (Docker)**:
    Ensure Docker is running and execute:
    ```bash
    docker-compose up -d
    ```

### Frontend (Flutter)

1.  **Install Flutter**: Follow [flutter.dev](https://flutter.dev) to install the SDK.
2.  **Get Packages**:
    ```bash
    cd mobile_app
    flutter pub get
    ```
3.  **Run the App**:
    ```bash
    flutter run
    ```

## 🛡️ Security & Compliance

- **HCS Attestation**: Nurses cannot bid until their license is verified.
- **Data Encryption**: AES-256 for health data.
- **Rate Limiting**: Protected against API spikes.

## 📄 License & Development

Implemented by **Antigravity AI Team** with a 10-year senior developer architecture standard.
