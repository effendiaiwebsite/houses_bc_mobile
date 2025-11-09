# Quick Command Reference

**Essential commands for developing Houses BC Mobile**

---

## 🚀 INITIAL SETUP (One Time)

### Install Flutter (Linux)
```bash
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
flutter --version
```

### Setup Android
```bash
flutter doctor
flutter doctor --android-licenses
```

### Initialize Project
```bash
cd /home/vboxuser/programs/Rida/houses_bc_mobile
flutter create --org com.housesbc --project-name houses_bc_mobile .
flutter pub get
```

### Add Missing Dependency
```bash
# Edit pubspec.yaml and add:
#   path_provider: ^2.1.1
# Then run:
flutter pub get
```

---

## 🏃 DAILY DEVELOPMENT

### Start Backend (Terminal 1)
```bash
cd /home/vboxuser/programs/Rida/HousesinBCV2
npm run dev
# Keep this running
```

### Run Flutter App (Terminal 2)
```bash
cd /home/vboxuser/programs/Rida/houses_bc_mobile
flutter run
```

### While App is Running
```
r  → Hot reload (fast, preserves state)
R  → Hot restart (full restart)
q  → Quit
```

---

## 🔍 DEBUGGING

### Check Available Devices
```bash
flutter devices
```

### Run on Specific Device
```bash
flutter run -d <device-id>
```

### View Logs
```bash
flutter logs
```

### Check for Issues
```bash
flutter doctor
flutter doctor -v  # Verbose
flutter analyze    # Code analysis
```

---

## 🧹 CLEANUP

### Clean Build Cache
```bash
flutter clean
flutter pub get
```

### Clean Android Build
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Reset Everything
```bash
rm -rf build/
rm -rf .dart_tool/
flutter clean
flutter pub get
```

---

## 📦 PACKAGE MANAGEMENT

### Install All Dependencies
```bash
flutter pub get
```

### Update Dependencies
```bash
flutter pub upgrade
```

### Add New Package
```bash
flutter pub add package_name
# Or manually edit pubspec.yaml and run:
flutter pub get
```

### Remove Package
```bash
flutter pub remove package_name
```

### Check Outdated Packages
```bash
flutter pub outdated
```

---

## 🏗️ BUILDING

### Debug APK (For Testing)
```bash
flutter build apk --debug
# Output: build/app/outputs/flutter-apk/app-debug.apk
```

### Release APK (For Distribution)
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### App Bundle (For Google Play)
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### Install APK on Device
```bash
flutter install
# Or manually:
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔧 ANDROID SPECIFIC

### List Emulators
```bash
flutter emulators
```

### Launch Emulator
```bash
flutter emulators --launch <emulator-name>
```

### Check Connected Devices (ADB)
```bash
adb devices
```

### Clear App Data
```bash
adb shell pm clear com.housesbc.houses_bc_mobile
```

### View Android Logs
```bash
adb logcat | grep flutter
```

---

## 🧪 TESTING

### Run All Tests
```bash
flutter test
```

### Run Specific Test
```bash
flutter test test/widget_test.dart
```

### Run with Coverage
```bash
flutter test --coverage
```

---

## 📊 PERFORMANCE

### Profile Build
```bash
flutter build apk --profile
flutter run --profile
```

### Performance Overlay
```
P  → Toggle performance overlay (while app is running)
```

### Measure App Size
```bash
flutter build apk --analyze-size
```

---

## 🌐 BACKEND COMMANDS

### Start Backend
```bash
cd /home/vboxuser/programs/Rida/HousesinBCV2
npm run dev
```

### Check Backend Health
```bash
curl http://localhost:3000/api/health
```

### View Backend Logs
```bash
# Backend logs appear in terminal where npm run dev is running
```

---

## 🔐 API TESTING (cURL)

### Send OTP
```bash
curl -X POST http://localhost:3000/api/auth/send-otp \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber": "+1234567890"}'
```

### Verify OTP
```bash
curl -X POST http://localhost:3000/api/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber": "+1234567890", "code": "123456", "loginType": "client"}'
```

### Search Properties
```bash
curl http://localhost:3000/api/properties/search?location=British%20Columbia
```

---

## 📱 DEVICE SETUP

### Enable USB Debugging (Android)
1. Settings → About Phone
2. Tap "Build Number" 7 times
3. Settings → Developer Options
4. Enable "USB Debugging"

### Connect Physical Device
```bash
# Connect via USB
adb devices  # Should show your device
flutter devices  # Should list your device
flutter run -d <device-id>
```

---

## 🐛 COMMON FIXES

### "Gradle build failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### "Cannot connect to API"
```bash
# For emulator, use:
# http://10.0.2.2:3000/api

# For physical device, use your computer's IP:
# http://192.168.1.XXX:3000/api

# Find your IP (Linux):
ip addr show
# Or:
ifconfig
```

### "No devices found"
```bash
# Start an emulator
flutter emulators
flutter emulators --launch <emulator-name>
```

### "Hot reload not working"
```bash
# Press R (capital R) for hot restart
# Or quit and run again:
flutter run
```

### "Pod install failed" (iOS)
```bash
cd ios
pod install
cd ..
flutter run
```

---

## 📝 CODE GENERATION (Future)

### Generate Code (when using build_runner)
```bash
flutter pub run build_runner build
```

### Watch and Auto-generate
```bash
flutter pub run build_runner watch
```

### Clean and Rebuild
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🔄 GIT COMMANDS (If Using Version Control)

### Initialize Git
```bash
git init
git add .
git commit -m "Initial commit: Flutter app structure"
```

### Create .gitignore
```bash
# Flutter .gitignore
*.iml
.gradle
.idea
.dart_tool/
.flutter-plugins
.packages
.pub-cache/
.pub/
build/
```

### Common Git Workflow
```bash
git status
git add .
git commit -m "Add property search feature"
git push origin main
```

---

## 🚦 QUICK START SEQUENCE

### First Time Setup
```bash
# 1. Install Flutter
cd ~/development && git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:$HOME/development/flutter/bin"

# 2. Setup Android
flutter doctor --android-licenses

# 3. Initialize Project
cd /home/vboxuser/programs/Rida/houses_bc_mobile
flutter create --org com.housesbc --project-name houses_bc_mobile .
flutter pub get

# 4. Add missing dependency (edit pubspec.yaml)
# Then:
flutter pub get

# 5. Run app
flutter run
```

### Daily Workflow
```bash
# Terminal 1: Start backend
cd /home/vboxuser/programs/Rida/HousesinBCV2
npm run dev

# Terminal 2: Run Flutter app
cd /home/vboxuser/programs/Rida/houses_bc_mobile
flutter run

# Make changes, press 'r' for hot reload
```

---

## 📞 HELPFUL SHORTCUTS

While app is running:
```
r  → Hot reload
R  → Hot restart
q  → Quit
h  → Help
d  → Detach (app keeps running)
P  → Toggle performance overlay
```

---

**Bookmark this file for quick reference during development!**
