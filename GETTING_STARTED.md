# Getting Started with Houses BC Mobile

This guide will walk you through getting your Flutter app up and running.

---

## BEFORE YOU START

### What You Have

✅ **Complete project structure** with all core files
✅ **Backend already running** (HousesinBCV2)
✅ **Authentication system** fully implemented
✅ **Models, services, and utilities** ready to use
✅ **Theme and configuration** set up
✅ **Documentation** comprehensive and detailed

### What You Need

❌ Flutter SDK installed
❌ Android Studio set up
❌ Flutter project initialized (platform files)
❌ Screens and UI components built

---

## STEP 1: INSTALL FLUTTER

### On Linux

```bash
# Download Flutter
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# Verify
flutter --version
```

### On Windows/Mac

Visit: https://docs.flutter.dev/get-started/install

---

## STEP 2: SET UP ANDROID STUDIO

1. Download from: https://developer.android.com/studio
2. Install Android SDK
3. Install Android SDK Command-line Tools
4. Create an Android Virtual Device (AVD)

```bash
# Accept licenses
flutter doctor --android-licenses

# Check setup
flutter doctor
```

You should see all green checkmarks except for VS Code/IntelliJ (optional).

---

## STEP 3: INITIALIZE FLUTTER PROJECT

```bash
cd /home/vboxuser/programs/Rida/houses_bc_mobile

# This creates android/, ios/, and other platform files
flutter create --org com.housesbc --project-name houses_bc_mobile .

# Install dependencies
flutter pub get
```

**Important:** Add this missing dependency to `pubspec.yaml`:

```yaml
dependencies:
  # ... existing dependencies ...
  path_provider: ^2.1.1  # Add this line
```

Then run:
```bash
flutter pub get
```

---

## STEP 4: CONFIGURE API URL

Edit `lib/core/config/app_config.dart`:

```dart
// For Android Emulator (10.0.2.2 maps to localhost)
static const String baseUrl = 'http://10.0.2.2:3000/api';

// For Physical Device (replace with your computer's IP)
// Find your IP: Run `ifconfig` (Linux/Mac) or `ipconfig` (Windows)
// static const String baseUrl = 'http://192.168.1.XXX:3000/api';
```

---

## STEP 5: START BACKEND SERVER

In a separate terminal:

```bash
cd /home/vboxuser/programs/Rida/HousesinBCV2
npm run dev
```

You should see:
```
🚀 Server running on port 3000
📝 Environment: development
🔗 API: http://localhost:3000/api
```

Keep this running while developing the mobile app.

---

## STEP 6: RUN THE APP

```bash
cd /home/vboxuser/programs/Rida/houses_bc_mobile

# List available devices
flutter devices

# Run on emulator/device
flutter run

# Or specify device
flutter run -d <device-id>
```

First build takes 2-5 minutes. Subsequent runs are faster.

---

## STEP 7: COMPLETE THE IMPLEMENTATION

You now have a working app skeleton. Here's what to build next:

### Priority 1: Property Search (NEXT)

Create these files by copying from `IMPLEMENTATION_GUIDE.md`:

1. **Property Providers** (`lib/features/properties/providers/property_provider.dart`)
   - Manages property search state
   - Handles pagination
   - Caches search results

2. **Property Card Widget** (`lib/features/properties/widgets/property_card.dart`)
   - Displays property in grid/list
   - Shows image, price, beds/baths, location
   - Tap to view details

3. **Property Search Screen** (`lib/features/properties/screens/property_search_screen.dart`)
   - Search bar
   - Filters (price, beds, baths, type)
   - Grid of property cards
   - Pull-to-refresh
   - Pagination

4. **Property Details Screen** (`lib/features/properties/screens/property_details_screen.dart`)
   - Image carousel
   - Full specs
   - Map location
   - Save button
   - Book viewing button

### Priority 2: Calculators

1. **Mortgage Calculator Screen**
   - Input fields for price, down payment, rate, years
   - Slider for interest rate
   - Results card with monthly payment

2. **Incentive Calculator Screen**
   - Checkboxes for first-time buyer, new home
   - Results showing all available incentives

### Priority 3: Appointments & Portal

1. **Book Viewing Screen**
   - Date picker
   - Time picker
   - Notes field

2. **Client Portal Screen**
   - Stats cards
   - Quick links
   - Recent activity

---

## DEVELOPMENT WORKFLOW

### Hot Reload

While app is running:
- Type `r` - Hot reload (preserves state)
- Type `R` - Hot restart (fresh start)
- Type `q` - Quit

### View Logs

```bash
flutter logs
```

### Debug on Device

```bash
# Enable USB debugging on Android phone
# Connect via USB
flutter devices
flutter run -d <your-device-id>
```

---

## FILE REFERENCE GUIDE

### Core Files (Already Created)

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point |
| `lib/app.dart` | Root widget with Riverpod |
| `lib/core/config/app_config.dart` | API URL, constants |
| `lib/core/config/theme.dart` | Theme colors, styles |
| `lib/core/network/api_client.dart` | HTTP client with cookies |
| `lib/core/storage/secure_storage.dart` | Local storage |
| `lib/core/utils/validators.dart` | Input validation |
| `lib/core/utils/formatters.dart` | Currency, date formatting |
| `lib/routes/app_router.dart` | Navigation config |
| `lib/features/auth/services/auth_service.dart` | Auth API calls |
| `lib/features/properties/services/property_service.dart` | Property API calls |

### Files to Create (Next Steps)

Refer to `IMPLEMENTATION_GUIDE.md` for complete code:

1. `lib/features/properties/providers/property_provider.dart`
2. `lib/features/properties/widgets/property_card.dart`
3. `lib/features/properties/screens/property_search_screen.dart`
4. `lib/features/properties/screens/property_details_screen.dart`
5. `lib/features/calculators/screens/mortgage_calculator_screen.dart`
6. `lib/features/calculators/screens/incentive_calculator_screen.dart`
7. `lib/features/calculators/screens/calculators_tab_screen.dart`
8. `lib/features/onboarding/screens/onboarding_flow.dart`
9. `lib/features/client_portal/screens/client_portal_screen.dart`

---

## TESTING THE APP

### Test Authentication

1. Tap "Portal" in bottom nav
2. Should prompt for phone number
3. Enter `+1234567890` (or any E.164 format)
4. Check backend terminal for OTP code
5. Enter 6-digit code
6. Should log in successfully

### Test Property Search (Once Built)

1. Open app to Browse screen
2. Should load properties from BC
3. Tap a property to see details
4. Tap "Save" - should prompt for auth if not logged in
5. After login, property should save

### Test Calculators (Once Built)

1. Tap "Calculate" in bottom nav
2. Should see Mortgage/Incentive tabs
3. Enter values and see results update
4. No auth required

---

## COMMON ISSUES

### "Cannot connect to http://10.0.2.2:3000"

**Solution:**
1. Ensure backend is running: `cd HousesinBCV2 && npm run dev`
2. Check you're using emulator (physical device needs local IP)
3. Try `http://localhost:3000` if on web
4. Check firewall isn't blocking port 3000

### "Gradle build failed"

**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### "No devices found"

**Solution:**
```bash
# Start Android emulator from Android Studio
# OR
flutter emulators
flutter emulators --launch <emulator-name>
```

### "Cookie session not persisting"

**Solution:**
- Clear app data: Long press app icon → App info → Clear data
- Logout and login again
- Check `dio_cookie_manager` is initialized in api_client.dart

---

## BUILD FOR RELEASE

### Debug APK (for testing)

```bash
flutter build apk --debug
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`

### Release APK (for distribution)

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### App Bundle (for Google Play)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

---

## NEXT SESSION CHECKLIST

If you need to stop and continue later:

1. ✅ Read `PROJECT_CONTEXT.md` - Full project overview
2. ✅ Review `README.md` - Architecture and features
3. ✅ Check `IMPLEMENTATION_GUIDE.md` - Code for next features
4. ✅ Reference web app: `/home/vboxuser/programs/Rida/HousesinBCV2/`
5. ✅ Start backend: `npm run dev`
6. ✅ Run Flutter app: `flutter run`

---

## HELPFUL RESOURCES

- **Flutter Documentation:** https://docs.flutter.dev
- **Riverpod Guide:** https://riverpod.dev/docs/introduction/getting_started
- **Material Design 3:** https://m3.material.io
- **Dart Language Tour:** https://dart.dev/guides/language/language-tour
- **Go Router Package:** https://pub.dev/packages/go_router
- **Dio HTTP Client:** https://pub.dev/packages/dio

---

## SUPPORT

For questions:
1. Check documentation in this folder
2. Review existing web app code at `HousesinBCV2/`
3. Search Flutter documentation
4. Check package documentation on pub.dev

---

**You're ready to build!**

Start with Step 1 (Install Flutter) and work through each step. By Step 7, you'll have a running app skeleton ready for feature implementation.

Good luck! 🚀
