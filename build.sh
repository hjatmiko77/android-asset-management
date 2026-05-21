#!/bin/bash

# Asset Management App - Build Script
# This script automates the APK build process

set -e

echo "🚀 Asset Management - Flutter Build Script"
echo "========================================="

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check Flutter
echo -e "${YELLOW}Checking Flutter installation...${NC}"
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}Flutter not found. Please install Flutter SDK.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Flutter found${NC}"
flutter --version

# Navigate to mobile directory
cd mobile

# Get dependencies
echo -e "${YELLOW}Getting dependencies...${NC}"
flutter pub get
echo -e "${GREEN}✓ Dependencies installed${NC}"

# Build type
BUILD_TYPE=${1:-release}
echo -e "${YELLOW}Building $BUILD_TYPE APK...${NC}"

if [ "$BUILD_TYPE" = "debug" ]; then
    flutter build apk --debug
    APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
elif [ "$BUILD_TYPE" = "profile" ]; then
    flutter build apk --profile
    APK_PATH="build/app/outputs/flutter-apk/app-profile.apk"
else
    flutter build apk --release
    APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
fi

# Check if APK was created
if [ -f "$APK_PATH" ]; then
    SIZE=$(du -h "$APK_PATH" | cut -f1)
    echo -e "${GREEN}✓ APK built successfully${NC}"
    echo -e "${GREEN}📦 APK: $APK_PATH${NC}"
    echo -e "${GREEN}📊 Size: $SIZE${NC}"
else
    echo -e "${RED}✗ APK build failed${NC}"
    exit 1
fi

# Optional: Install on connected device
if [ "$2" = "--install" ]; then
    echo -e "${YELLOW}Installing on device...${NC}"
    adb install -r "$APK_PATH"
    echo -e "${GREEN}✓ APK installed${NC}"
fi

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}Build completed successfully!${NC}"
