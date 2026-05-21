# Setup Guide - Asset Management Enterprise

## Prerequisites

- Docker & Docker Compose
- Flutter SDK 3.x
- Python 3.11+
- Git

## Backend Setup

### 1. Environment Configuration

```bash
cd backend
cp .env.example .env
```

Edit `.env` with your configuration:

```env
DATABASE_URL=postgresql://asset_user:asset_password@postgres:5432/asset_management
SECRET_KEY=your-very-secret-key-here
```

### 2. Run with Docker Compose

```bash
# From project root
docker-compose up -d
```

This will start:
- PostgreSQL Database (port 5432)
- FastAPI Backend (port 8000)
- NGINX Proxy (port 80)

### 3. API Documentation

Visit http://localhost:8000/api/docs for interactive Swagger documentation.

## Mobile Setup

### 1. Install Dependencies

```bash
cd mobile
flutter pub get
```

### 2. Update API Configuration

Edit `lib/config/app_config.dart`:

```dart
static const String apiBaseUrl = 'http://localhost:8000/api';
```

### 3. Run on Emulator/Device

```bash
flutter run
```

### 4. Build APK

```bash
flutter build apk --release
```

## Database Initialization

The database schema is automatically created when Docker Compose starts.

To manually initialize:

```bash
sqlpsql -U asset_user -d asset_management -f database/schema.sql
```

## Verification

### Backend Health Check

```bash
curl http://localhost:8000/health
```

Expected response:
```json
{"status": "healthy"}
```

### API Testing

```bash
# Login
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username": "admin", "password": "password"}'

# List Assets
curl http://localhost:8000/api/v1/assets
```

## Troubleshooting

### Port Already in Use

```bash
# Find and kill process
lsof -i :8000
kill -9 <PID>
```

### Database Connection Error

```bash
# Check database logs
docker-compose logs postgres
```

### Flutter Build Issues

```bash
flutter clean
flutter pub get
flutter run
```
