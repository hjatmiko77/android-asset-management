# Android Asset Management Enterprise

Aplikasi Android untuk stock opname aset perusahaan dengan Flutter mobile dan FastAPI backend.

## 📱 Fitur Utama

- **Login & Authentication**: JWT-based authentication
- **Asset Management**: Input, edit, delete, dan search aset
- **Barcode/QR Scanner**: Scan untuk mencari dan mengisi form otomatis
- **GPS Location**: Lokasi otomatis dengan coordinates
- **Photo Capture**: Foto aset dan label aset
- **Offline Mode**: SQLite local database dengan auto-sync
- **Export Excel**: Export data ke format .xlsx
- **Audit Log**: Tracking semua aktivitas user
- **Responsive UI**: Optimized untuk tablet Android
- **Dark Mode**: Support dark mode

## 🏗️ Arsitektur

```
Android Flutter App
        ↓
    REST API (FastAPI)
        ↓
PostgreSQL Database
        ↓
Excel Export
```

## 📚 Struktur Project

```
android-asset-management/
├── mobile/                 # Flutter Application
│   ├── lib/
│   │   ├── config/
│   │   ├── core/
│   │   ├── data/
│   │   ├── domain/
│   │   ├── presentation/
│   │   └── main.dart
│   ├── pubspec.yaml
│   └── test/
├── backend/               # FastAPI Backend
│   ├── app/
│   │   ├── api/
│   │   ├── models/
│   │   ├── schemas/
│   │   ├── services/
│   │   └── main.py
│   ├── requirements.txt
│   ├── Dockerfile
│   └── .env.example
├── database/              # Database Schema
│   ├── schema.sql
│   └── migration/
├── docker-compose.yml
├── nginx.conf
└── docs/                  # Documentation
    ├── API.md
    ├── SETUP.md
    ├── DEPLOYMENT.md
    └── DATABASE.md
```

## 🚀 Quick Start

### Mobile App
```bash
cd mobile
flutter pub get
flutter run
```

### Backend
```bash
cd backend
pip install -r requirements.txt
uvicorn app.main:app --reload
```

### Docker Compose
```bash
docker-compose up -d
```

## 📖 Dokumentasi

- [Setup Guide](docs/SETUP.md)
- [API Documentation](docs/API.md)
- [Database Schema](docs/DATABASE.md)
- [Deployment Guide](docs/DEPLOYMENT.md)

## 🔐 Keamanan

- HTTPS ready
- JWT Authentication
- Password Hash (bcrypt)
- API Validation
- Environment Variables untuk credentials
- Audit logging

## 📋 Form Aset Fields

### Data Lokasi
- Organization
- Latitude / Longitude (GPS)
- Location
- Building
- Systems
- Sub-Systems

### Data Asset Level
- Asset Code Level 5-7
- Description Level 5-7
- Kode Aset

### Data Detail Aset
- Asset Category
- Merk/Brand
- Serial Number
- Model
- Installed Date
- Warranty Date
- Capex/Opex
- Kepemilikan
- Kondisi
- Detail Kondisi
- Fungsi Utama Aset

### Upload
- Photo Aset
- Photo Label Aset

## 🛠️ Tech Stack

### Mobile
- Flutter 3.x
- Riverpod (State Management)
- Dio (HTTP Client)
- SQLite (Local Database)
- Mobile Scanner (Barcode/QR)
- Geolocator (GPS)
- Image Picker (Camera)

### Backend
- FastAPI
- Python 3.11+
- SQLAlchemy ORM
- PostgreSQL
- JWT Authentication
- Docker

## 📝 License

Propriatary - Asset Management Enterprise

## 👥 Contributors

- Your Name (@hjatmiko77)

---

**Status**: 🚧 Under Development

**Last Updated**: 2026-05-21
