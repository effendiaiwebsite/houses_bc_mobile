# Houses BC Mobile - Flutter Setup Instructions

## Prerequisites

### 1. Install Flutter SDK

**For Linux:**
```bash
# Download Flutter
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable

# Add Flutter to PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="$PATH:$HOME/development/flutter/bin"

# Verify installation
flutter --version
flutter doctor
```

**For Windows/Mac:** Visit https://docs.flutter.dev/get-started/install

### 2. Install Android Studio
1. Download from https://developer.android.com/studio
2. Install Android SDK and Android SDK Command-line Tools
3. Set up an Android Emulator or connect a physical device

### 3. Accept Android Licenses
```bash
flutter doctor --android-licenses
```

---

## Project Setup

### 1. Navigate to project directory
```bash
cd /home/vboxuser/programs/Rida/houses_bc_mobile
```

### 2. Create Flutter project (if not already created)
```bash
# This command creates the Flutter project structure
flutter create --org com.housesbc --project-name houses_bc_mobile .
```

**Note:** The files in this directory are already structured. This command will create the necessary Flutter platform files (android/, ios/, etc.)

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Update Backend Configuration
Edit `lib/core/config/app_config.dart` and update the API URL:

```dart
// For local development
static const String baseUrl = 'http://10.0.2.2:3000/api'; // Android emulator

// For physical device on same network
static const String baseUrl = 'http://YOUR_LOCAL_IP:3000/api'; // e.g., http://192.168.1.100:3000/api

// For production
static const String baseUrl = 'https://your-production-api.com/api';
```

### 5. Run the App

**Start your backend server first:**
```bash
cd /home/vboxuser/programs/Rida/HousesinBCV2
npm run dev
```

**Then run the Flutter app:**
```bash
cd /home/vboxuser/programs/Rida/houses_bc_mobile

# Run on connected device/emulator
flutter run

# Or specify device
flutter devices
flutter run -d <device-id>
```

---

## Development Tips

### Hot Reload
- Press `r` in the terminal to hot reload
- Press `R` to hot restart
- Press `q` to quit

### Debug Mode
```bash
flutter run --debug
```

### Release Build
```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# Find APK at: build/app/outputs/flutter-apk/app-release.apk
```

---

## Troubleshooting

### "Cannot connect to backend"
1. Ensure backend is running on port 3000
2. For Android emulator, use `http://10.0.2.2:3000/api` (10.0.2.2 is the special IP for localhost)
3. For physical device, use your computer's local IP address

### "Gradle build failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### "No devices found"
```bash
# List available devices
flutter devices

# Start an emulator
flutter emulators
flutter emulators --launch <emulator_id>

# Or use Android Studio's AVD Manager to start an emulator
```

### "Pod install failed" (iOS)
```bash
cd ios
pod install
cd ..
flutter run
```

---

## Project Structure

```
houses_bc_mobile/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── app.dart                  # Root app widget
│   ├── core/                     # Core functionality
│   │   ├── config/              # Configuration
│   │   ├── network/             # API client
│   │   └── storage/             # Local storage
│   ├── features/                # Feature modules
│   │   ├── auth/
│   │   ├── properties/
│   │   ├── calculators/
│   │   ├── appointments/
│   │   └── client_portal/
│   ├── shared/                  # Shared widgets
│   └── routes/                  # Navigation
├── android/                     # Android platform files
├── ios/                        # iOS platform files (future)
└── pubspec.yaml                # Dependencies
```

---

## Next Steps

1. Install Flutter SDK
2. Run `flutter create` to generate platform files
3. Run `flutter pub get` to install dependencies
4. Update API URL in `app_config.dart`
5. Start backend server
6. Run `flutter run`

---

## API Integration

The app connects to your existing Node.js backend:
- Base URL: `http://localhost:3000/api`
- Session-based authentication with cookies
- All endpoints from your web app are supported

### Key Endpoints Used:
- `POST /auth/send-otp` - Send verification code
- `POST /auth/verify-otp` - Verify and login
- `GET /auth/status` - Check authentication
- `GET /properties/search` - Search properties
- `GET /properties/:zpid` - Property details
- `POST /saved-properties` - Save property
- `GET /saved-properties` - Get saved properties
- `POST /appointments` - Book viewing
- `GET /appointments` - Get appointments

---

## Additional Resources

- Flutter Documentation: https://docs.flutter.dev
- Riverpod Documentation: https://riverpod.dev
- Dio HTTP Client: https://pub.dev/packages/dio
- Material Design 3: https://m3.material.io

---

**Ready to build!** Follow the setup steps above and your Flutter app will be running.
