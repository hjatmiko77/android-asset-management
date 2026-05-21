# Quick Start Guide - Asset Management App

## 🚀 For Developers

### Clone Repository

```bash
git clone https://github.com/hjatmiko77/android-asset-management.git
cd android-asset-management
```

### Setup Backend

```bash
cd backend
cp .env.example .env
# Edit .env with your configuration
docker-compose up -d
```

Backend will be available at: `http://localhost:8000`

### Setup Mobile App

```bash
cd mobile
flutter pub get
flutter run
```

### Build APK

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
```

## 📱 For End Users

### Installation Steps

1. **Enable Unknown Sources**
   - Go to Settings > Security
   - Enable "Unknown Sources"

2. **Download APK**
   - Download `app-release.apk` from releases

3. **Install App**
   - Tap the APK file
   - Select "Install"
   - Wait for installation to complete

4. **First Launch**
   - Open "Asset Management" app
   - Login with provided credentials

### Default Login

- **Username**: `admin`
- **Password**: `password` (Change on first login)

### Permissions

The app requires:
- Camera (for barcode scanning & photos)
- Location (for GPS coordinates)
- Storage (for photos & offline data)
- Network (for API communication)

Grant permissions when prompted.

## 🎯 Key Features

### Dashboard
- View total assets count
- Check active assets
- See recent asset updates
- Quick access to scan or add assets

### Asset Management
- **Add New Asset**: Tap + button → Fill form → Save
- **Search Asset**: Use search bar with code, brand, or serial number
- **View Details**: Tap any asset card
- **Edit Asset**: Open details → Tap edit icon
- **Delete Asset**: Open details → Tap delete icon

### Scan Barcode
1. Tap QR code icon
2. Point camera at barcode/QR code
3. System automatically fills asset data
4. Confirm and save

### Capture Location
1. In asset form, tap location icon
2. GPS coordinates auto-filled
3. Enter location details manually if needed

### Capture Photos
1. In asset form, tap camera buttons
2. Take photo of asset
3. Take photo of label
4. Photos stored locally

### Offline Mode
- App works without internet
- All data saved locally
- Auto-syncs when online
- Sync status shown in app

## 🔄 Common Tasks

### Search for Asset

```
Home → Assets (or search bar)
Type asset code / brand / serial number
View filtered results
```

### Update Asset Condition

```
Assets → Select asset → Edit
Change Kondisi field
Save
```

### Export Data

```
Home → Download (when available)
Select date range
Download Excel file
```

## 📞 Support

### API Server Configuration

Edit `mobile/lib/config/app_config.dart`:

```dart
static const String apiBaseUrl = 'http://your-server:8000/api';
```

### Troubleshooting

**App won't login**
- Check internet connection
- Verify server address
- Check login credentials

**Camera not working**
- Check camera permissions
- Restart app
- Restart device

**Location not working**
- Enable location permission
- Check GPS is enabled
- Move outdoors for better signal

**Sync issues**
- Check internet connection
- Check server status
- Restart app

## 📊 System Requirements

**Minimum**
- Android 5.0 (API 21)
- 50 MB free storage
- 2GB RAM
- Internet connection (for sync)

**Recommended**
- Android 10+
- 200 MB free storage
- 4GB+ RAM
- WiFi connection

## 🔐 Security Notes

- Always use strong passwords
- Change default credentials immediately
- Use VPN when accessing over public WiFi
- Don't share credentials
- Update app when new versions released

## 📝 Version

- **App Version**: 1.0.0
- **Last Updated**: 2026-05-21
- **Platform**: Android 5.0+

## 🤝 Support

For issues or questions:
1. Check documentation
2. Review troubleshooting section
3. Contact system administrator

---

**Happy Asset Management! 📦**
