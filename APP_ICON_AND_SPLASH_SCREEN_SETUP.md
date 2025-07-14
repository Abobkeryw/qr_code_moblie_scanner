# App Icon and Splash Screen Setup

## Overview
This document describes the changes made to set up the `Camera_caver.png` image as both the app icon and splash screen for the QR Code Scanner application.

## Changes Made

### 1. App Icon Setup
- **Files Modified**: All mipmap directories in `android/app/src/main/res/`
  - `mipmap-hdpi/ic_launcher.png`
  - `mipmap-mdpi/ic_launcher.png`
  - `mipmap-xhdpi/ic_launcher.png`
  - `mipmap-xxhdpi/ic_launcher.png`
  - `mipmap-xxxhdpi/ic_launcher.png`

- **Action**: Copied `images/Camera_caver.png` to all mipmap directories as `ic_launcher.png`
- **Purpose**: This makes the Camera_caver.png image the app icon that appears on the device home screen and app drawer

### 2. Splash Screen Setup
- **Files Modified**:
  - `android/app/src/main/res/drawable/launch_background.xml`
  - `android/app/src/main/res/drawable-v21/launch_background.xml`

- **Changes**:
  - Uncommented the bitmap section in both launch background files
  - Changed the source from `@mipmap/launch_image` to `@mipmap/ic_launcher`
  - This ensures the app icon appears during the splash screen on both light and dark themes

### 3. Asset Configuration
- **File**: `pubspec.yaml`
- **Status**: Already properly configured with `assets: - images/` which includes the Camera_caver.png

## Technical Details

### App Icon
- The app icon is automatically picked up by Android from the `ic_launcher.png` files in the mipmap directories
- Different densities (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi) ensure the icon looks crisp on all device screen densities
- The icon will appear on the device home screen, app drawer, and in the app switcher

### Splash Screen
- The splash screen is controlled by the `launch_background.xml` files
- The `@mipmap/ic_launcher` reference points to the same icon used for the app icon
- The splash screen shows during app startup until the Flutter engine draws its first frame

## Verification Steps

1. **Clean and rebuild the app**:
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Build and install the app**:
   ```bash
   flutter build apk
   # or
   flutter run
   ```

3. **Verify the changes**:
   - The app icon should show the Camera_caver.png image on the device home screen
   - When launching the app, the splash screen should display the same Camera_caver.png image
   - The icon should appear crisp and properly sized on different device densities

## Notes

- The Camera_caver.png image is now used consistently across:
  - App icon (home screen, app drawer)
  - Splash screen (app launch)
  - App switcher (recent apps)

- The image is automatically scaled appropriately for different screen densities
- Both light and dark theme splash screens will show the same icon
- The setup follows Android best practices for app icons and splash screens

## Troubleshooting

If the icon doesn't appear correctly:
1. Ensure the Camera_caver.png file exists in the `images/` directory
2. Run `flutter clean` and `flutter pub get`
3. Rebuild the app completely
4. Check that the mipmap directories contain the copied ic_launcher.png files
5. Verify the launch_background.xml files have the correct bitmap configuration 