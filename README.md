# Houses BC Mobile - Flutter Android App

A professional Flutter mobile application for first-time home buyers in British Columbia, seamlessly integrated with your existing Node.js backend.

## Project Status

**Core Structure:** ✅ Complete
- Project architecture defined
- Dependencies configured
- Core utilities and network layer implemented
- Theme and configuration ready

**To Complete:**
- Routing/Navigation implementation
- Authentication screens and providers
- Property search and details screens
- Calculator screens
- Appointments and booking
- Client portal

---

## Quick Start

### Prerequisites

1. **Install Flutter SDK** (version 3.2.0 or higher)
   ```bash
   # Linux/Mac
   git clone https://github.com/flutter/flutter.git -b stable ~/development/flutter
   export PATH="$PATH:$HOME/development/flutter/bin"

   # Verify
   flutter doctor
   ```

2. **Install Android Studio** with Android SDK

3. **Accept Android Licenses**
   ```bash
   flutter doctor --android-licenses
   ```

### Setup

1. **Navigate to project**
   ```bash
   cd /home/vboxuser/programs/Rida/houses_bc_mobile
   ```

2. **Create Flutter project structure**
   ```bash
   # This creates the platform files (android/, ios/, etc.)
   flutter create --org com.housesbc --project-name houses_bc_mobile .
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Add missing dependency**

   Edit `pubspec.yaml` and add under dependencies:
   ```yaml
   path_provider: ^2.1.1
   ```

   Then run:
   ```bash
   flutter pub get
   ```

5. **Configure API URL**

   Edit `lib/core/config/app_config.dart`:
   ```dart
   // For Android Emulator
   static const String baseUrl = 'http://10.0.2.2:3000/api';

   // For Physical Device (use your computer's local IP)
   // static const String baseUrl = 'http://192.168.1.XXX:3000/api';
   ```

6. **Start backend server**
   ```bash
   cd /home/vboxuser/programs/Rida/HousesinBCV2
   npm run dev
   ```

7. **Run the app**
   ```bash
   cd /home/vboxuser/programs/Rida/houses_bc_mobile
   flutter run
   ```

---

## Project Architecture

### Clean Architecture with Feature-Based Structure

```
lib/
├── main.dart                    # App entry point
├── app.dart                     # Root widget
├── core/                        # Core functionality
│   ├── config/                  # Configuration & theme
│   ├── network/                 # API client & endpoints
│   ├── storage/                 # Local & secure storage
│   └── utils/                   # Validators & formatters
├── features/                    # Feature modules
│   ├── auth/                    # Authentication
│   ├── onboarding/              # Welcome screens
│   ├── properties/              # Property search & details
│   ├── calculators/             # Mortgage & incentive calculators
│   ├── appointments/            # Viewing bookings
│   └── client_portal/           # User dashboard
├── shared/                      # Shared widgets & models
└── routes/                      # Navigation & routing
```

### State Management

**Riverpod** is used for:
- Dependency injection
- State management
- Asynchronous data handling
- Provider-based architecture

### Network Layer

**Dio** HTTP client with:
- Cookie-based session management
- Automatic error handling
- Request/response logging
- Timeout configuration

### Storage Layer

- **FlutterSecureStorage:** Sensitive data (user ID, auth status)
- **SharedPreferences:** Non-sensitive data (settings, recent searches)

---

## Features Overview

### 1. Welcome & Onboarding
- 3-screen swipeable introduction
- "Skip" and "Get Started" options
- Shows only on first launch

### 2. Property Search
- Search by location, price, beds, baths
- Filter by status (For Sale / For Rent)
- Pagination support
- Pull-to-refresh
- Grid/List view toggle

### 3. Property Details
- Image carousel
- Full property specifications
- Map with location pin
- Save to favorites (triggers auth)
- Book viewing (triggers auth)

### 4. Calculators

**Mortgage Calculator:**
- Home price, down payment
- Interest rate, amortization
- Monthly/bi-weekly/weekly payments
- Total interest calculation

**BC Incentive Calculator:**
- First-time buyer credits
- Property transfer tax exemption
- GST/HST rebate (new homes)
- RRSP Home Buyers' Plan

### 5. Authentication
- Phone number entry
- OTP verification via SMS
- Session persistence
- Seamless login when needed

### 6. Client Portal
- Saved properties list
- Upcoming/past viewings
- Profile management
- Quick access to calculators

### 7. Book Viewings
- Select date & time
- Add notes
- Confirmation screen
- View in portal

---

## Implementation Roadmap

### Phase 1: Navigation & Auth (PRIORITY)

1. **Create Router** (`lib/routes/app_router.dart`)
   ```dart
   import 'package:go_router/go_router.dart';
   import 'package:flutter_riverpod/flutter_riverpod.dart';

   // Define routes and navigation
   final routerProvider = Provider<GoRouter>((ref) {
     return GoRouter(
       initialLocation: '/splash',
       routes: [
         // Define all routes here
       ],
     );
   });
   ```

2. **Auth Providers** (`lib/features/auth/providers/auth_provider.dart`)
   - AuthNotifier class
   - sendOtp method
   - verifyOtp method
   - checkAuthStatus method
   - logout method

3. **OTP Screen** (`lib/features/auth/screens/otp_verification_screen.dart`)
   - Phone number input
   - OTP input (6 digits)
   - Countdown timer
   - Resend OTP button

### Phase 2: Property Features

1. **Property Service** (`lib/features/properties/services/property_service.dart`)
   - searchProperties()
   - getPropertyDetails()
   - saveProperty()
   - getSavedProperties()

2. **Property Providers**
   - PropertySearchProvider
   - PropertyDetailsProvider
   - SavedPropertiesProvider

3. **Property Screens**
   - Property Search Screen with filters
   - Property Details Screen
   - Saved Properties Screen

### Phase 3: Calculators

1. **Calculator Screens**
   - Mortgage Calculator UI
   - Incentive Calculator UI
   - Result cards with breakdowns

2. **Calculator Logic**
   - Already implemented in models
   - Just need UI integration

### Phase 4: Appointments & Portal

1. **Appointment Service**
   - bookAppointment()
   - getAppointments()
   - cancelAppointment()

2. **Client Portal**
   - Dashboard with stats
   - Saved properties list
   - Appointments list
   - Profile section

### Phase 5: Polish & Testing

1. **UI Refinements**
   - Loading states
   - Error handling
   - Empty states
   - Animations

2. **Testing**
   - Unit tests
   - Widget tests
   - Integration tests

3. **Performance**
   - Image caching
   - List optimization
   - Memory management

---

## Key Components to Build

### Shared Widgets

Create these reusable widgets in `lib/shared/widgets/`:

1. **app_button.dart** - Styled ElevatedButton
2. **app_text_field.dart** - Consistent input fields
3. **loading_indicator.dart** - Circular progress indicator
4. **error_view.dart** - Error display with retry
5. **property_card.dart** - Property display card
6. **bottom_nav_bar.dart** - Bottom navigation

### Example: app_button.dart

```dart
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : (icon != null ? Icon(icon) : const SizedBox.shrink()),
        label: Text(label),
      );
    }

    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : (icon != null ? Icon(icon) : const SizedBox.shrink()),
      label: Text(label),
    );
  }
}
```

---

## API Integration

The app connects to your existing backend at `http://localhost:3000/api`

### Available Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/auth/send-otp` | POST | Send OTP code |
| `/auth/verify-otp` | POST | Verify code & login |
| `/auth/status` | GET | Check auth status |
| `/auth/logout` | POST | Logout |
| `/properties/search` | GET | Search properties |
| `/properties/:zpid` | GET | Property details |
| `/saved-properties` | GET/POST | Saved properties |
| `/appointments` | GET/POST | Appointments |

### Session Management

- Cookies are automatically handled by `dio_cookie_manager`
- Session persists across app restarts
- Logout clears cookies and local storage

---

## Development Tips

### Hot Reload
While app is running:
- Press `r` for hot reload
- Press `R` for hot restart
- Press `q` to quit

### Debugging
```bash
# Run in debug mode
flutter run --debug

# View logs
flutter logs

# Analyze code
flutter analyze
```

### Building APK
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# APK location: build/app/outputs/flutter-apk/
```

### Common Issues

**"Cannot connect to API"**
- Android emulator: Use `10.0.2.2` instead of `localhost`
- Physical device: Use your computer's local IP
- Ensure backend is running on port 3000

**"Gradle build failed"**
```bash
cd android && ./gradlew clean && cd ..
flutter clean && flutter pub get
```

---

## Next Steps

1. ✅ Review architecture and structure
2. ✅ Understand the codebase organization
3. 🔲 Install Flutter SDK
4. 🔲 Run `flutter create` to generate platform files
5. 🔲 Implement routing with go_router
6. 🔲 Build authentication flow
7. 🔲 Create property search screens
8. 🔲 Implement calculators
9. 🔲 Add appointment booking
10. 🔲 Build client portal

---

## Resources

- **Flutter Docs:** https://docs.flutter.dev
- **Riverpod Docs:** https://riverpod.dev
- **Dio Package:** https://pub.dev/packages/dio
- **Go Router:** https://pub.dev/packages/go_router

---

## Support

For implementation questions:
1. Check SETUP_INSTRUCTIONS.md
2. Review COMPLETE_CODE_REFERENCE.md
3. Refer to your web app implementation
4. Check Flutter documentation

---

**Built with Flutter • Designed for BC Home Buyers**
