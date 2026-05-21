# Android Asset Management - Build Guide

## Prerequisites

- Flutter SDK 3.x
- Android SDK (API 21+)
- Java Development Kit (JDK) 11+
- Gradle

## Step 1: Install Dependencies

```bash
cd mobile
flutter pub get
```

## Step 2: Update Configuration

Edit `lib/config/app_config.dart`:

```dart
static const String apiBaseUrl = 'http://your-server:8000/api'; // Change to your server
```

## Step 3: Build for Testing

```bash
# Debug APK (for testing)
flutter build apk --debug

# Output: build/app/outputs/flutter-apk/app-debug.apk
```

## Step 4: Build Release APK

### Step 4.1: Create Keystore

```bash
keytool -genkey -v -keystore ~/asset-management.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias asset_management
```

Follow the prompts to create your signing key.

### Step 4.2: Create Key Properties

Create `android/key.properties`:

```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=asset_management
storeFile=/path/to/asset-management.keystore
```

### Step 4.3: Update build.gradle

Edit `android/app/build.gradle`:

```gradle
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile file(keystoreProperties['storeFile'])
        storePassword keystoreProperties['storePassword']
    }
}

buildTypes {
    release {
        signingConfig signingConfigs.release
    }
}
```

### Step 4.4: Build Release APK

```bash
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

## Step 5: Build App Bundle (for Google Play)

```bash
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

## Step 6: Install on Device/Emulator

```bash
# Install debug APK
flutter install

# Or install specific APK
adb install build/app/outputs/flutter-apk/app-debug.apk

# Or for release
adb install build/app/outputs/flutter-apk/app-release.apk
```

## Step 7: Testing

```bash
# Run on emulator/device
flutter run

# Run release build
flutter run --release

# Run with verbose output
flutter run -v
```

## APK File Sizes

- Debug APK: ~150-200 MB
- Release APK: ~60-80 MB
- App Bundle: ~40-50 MB

## Troubleshooting

### Gradle Build Issues

```bash
flutter clean
flutter pub get
flutter build apk --release
```

### Permission Issues

Check `android/app/src/main/AndroidManifest.xml` includes:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### Minify Issues

If minify causes issues, edit `android/app/build.gradle`:

```gradle
buildTypes {
    release {
        signingConfig signingConfigs.release
        minifyEnabled false
        shrinkResources false
    }
}
```

## Distribution

### Upload to Google Play

1. Go to Google Play Console
2. Create new app
3. Upload App Bundle (.aab)
4. Fill app details
5. Submit for review

### Direct Distribution

Share APK files:
- Debug: For internal testing
- Release: For production users

## Build Commands Summary

```bash
# Get dependencies
flutter pub get

# Build debug
flutter build apk --debug

# Build release
flutter build apk --release

# Build app bundle
flutter build appbundle --release

# Install and run
flutter run --release

# Clean build
flutter clean
```
