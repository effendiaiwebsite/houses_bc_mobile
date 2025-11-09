# PROJECT CONTEXT - Houses BC Mobile App

**Last Updated:** 2025-10-22
**Project Status:** Core structure complete, implementing features
**Location:** `/home/vboxuser/programs/Rida/houses_bc_mobile/`

---

## PROJECT OVERVIEW

### What We're Building

A **Flutter Android mobile app** for first-time home buyers in British Columbia that integrates with an existing Node.js/Express backend. This is a **sister app** to the existing web application (HousesinBCV2).

### Key Objectives

1. **Share data** between web app and mobile app (same backend, same client portal)
2. **Client-focused** - No admin portal needed (web app handles that)
3. **Easy property access** - Simplified mobile experience for house-hunting
4. **Seamless authentication** - OTP-based login matching web app
5. **Offline capability** - Cached data where appropriate

---

## EXISTING INFRASTRUCTURE

### Backend (Already Built)

**Location:** `/home/vboxuser/programs/Rida/HousesinBCV2/`

**Tech Stack:**
- Node.js + Express
- Firestore database
- Twilio SMS for OTP
- Session-based auth (cookies)
- Port: 3000

**Key API Endpoints:**
```
POST /api/auth/send-otp          # Send verification code
POST /api/auth/verify-otp        # Verify and login
GET  /api/auth/status            # Check auth status
POST /api/auth/logout            # Logout

GET  /api/properties/search      # Search properties (Zillow API)
GET  /api/properties/:zpid       # Property details

POST /api/saved-properties       # Save a property
GET  /api/saved-properties       # Get saved properties

POST /api/appointments           # Book viewing
GET  /api/appointments           # Get appointments
```

**Authentication Flow:**
- Phone number → OTP via SMS → Session created
- Sessions persist in cookies
- loginType: 'client' for mobile app (not 'admin')

**Database Collections (Firestore):**
- users
- otpCodes
- savedProperties
- appointments
- leads
- properties
- neighborhoods

---

## MOBILE APP ARCHITECTURE

### Tech Stack

**Framework:** Flutter 3.2+
**Language:** Dart
**State Management:** Riverpod
**HTTP Client:** Dio with cookie_jar
**Routing:** go_router
**Storage:** flutter_secure_storage + shared_preferences
**Maps:** google_maps_flutter

### Project Structure

```
lib/
├── main.dart                    # Entry point
├── app.dart                     # Root widget with Riverpod
├── core/                        # Core functionality
│   ├── config/
│   │   ├── app_config.dart     # API URLs, constants
│   │   └── theme.dart          # Material Design 3 theme
│   ├── network/
│   │   ├── api_client.dart     # Dio client with cookies
│   │   └── api_endpoints.dart  # Endpoint constants
│   ├── storage/
│   │   └── secure_storage.dart # Secure + SharedPrefs storage
│   └── utils/
│       ├── validators.dart     # Input validation
│       └── formatters.dart     # Currency, date formatting
├── features/                    # Feature modules
│   ├── auth/                   # OTP authentication
│   ├── onboarding/             # First-launch welcome
│   ├── properties/             # Search, details, saved
│   ├── calculators/            # Mortgage + incentive calculators
│   ├── appointments/           # Viewing bookings
│   └── client_portal/          # User dashboard
├── shared/                      # Shared components
│   ├── widgets/                # Reusable UI components
│   └── models/                 # Shared data models
└── routes/                      # Navigation
    ├── app_routes.dart         # Route constants
    └── app_router.dart         # GoRouter configuration
```

---

## SCREEN FLOW

```
App Launch
    ↓
[Splash Screen] → Check onboarding status
    ↓
    ├─ First time? → [Onboarding] (3 screens) → Main App
    └─ Returning? → Main App
                      ↓
            ┌─────────────────┐
            │ Bottom Nav Bar  │
            └─────────────────┘
               │       │      │
               ↓       ↓      ↓
          Browse  Calculate  Portal
            │         │        │
            ↓         ↓        ↓
    [Property     [Mortgage   [Requires
     Search]      Calculator] Authentication]
        │             │           │
        ↓             ↓           ↓
    [Property     [Incentive   [Saved
     Details]     Calculator]  Properties]
        │                         │
        ├─ Save Property ─────────┤
        └─ Book Viewing ──────────┤
                │                 │
                ↓                 ↓
        [OTP Verification]  [Appointments]
                │                 │
                └─────────────────┘
                          ↓
                  [Client Portal]
                  - Saved Properties
                  - Appointments
                  - Profile
```

---

## FEATURES BREAKDOWN

### 1. Welcome/Onboarding ✅ (Planned)
- 3 swipeable screens
- Benefits, how it works, get started
- Skip button
- Shows only on first launch

### 2. Property Search ⏳ (In Progress)
- Search by location (default: British Columbia)
- Filters: price, beds, baths, type, status (For Sale/Rent)
- Grid/list view
- Pagination
- Pull-to-refresh
- Recent searches saved locally

### 3. Property Details ⏳ (In Progress)
- Image carousel
- Full specs (beds, baths, sqft, price)
- Map with pin
- Description
- Save button (triggers auth if not logged in)
- Book viewing button (triggers auth if not logged in)

### 4. Mortgage Calculator ⏳ (In Progress)
- Home price input
- Down payment ($ or %)
- Interest rate slider
- Amortization (15-30 years)
- Payment frequency (monthly/bi-weekly/weekly)
- Results:
  - Monthly payment
  - Total interest
  - Total cost
  - Amortization schedule

### 5. BC Incentive Calculator ⏳ (In Progress)
- Home price input
- First-time buyer checkbox
- New home checkbox
- Household income
- Results:
  - First-Time Home Buyers Tax Credit ($8,000)
  - Property Transfer Tax Exemption
  - GST/HST Rebate (new homes)
  - RRSP Home Buyers' Plan ($35,000)
  - Total savings

### 6. Authentication (OTP) ✅ (Complete)
- Phone number entry (+1234567890 format)
- OTP sent via SMS (Twilio)
- 6-digit code verification
- 60-second countdown for resend
- Session persists across app restarts
- Triggered when:
  - Saving properties
  - Booking viewings
  - Accessing portal

### 7. Saved Properties ⏳ (Planned)
- List of saved properties
- Tap to view details
- Remove from saved
- Add notes

### 8. Book Viewing ⏳ (Planned)
- Select date & time
- Add notes
- Confirmation
- View in appointments list

### 9. Client Portal ⏳ (Planned)
- Dashboard with stats:
  - Number of saved properties
  - Upcoming viewings
  - Past viewings
- Quick links:
  - View saved properties
  - Upcoming appointments
  - Profile
  - Calculators
- Logout button

### 10. Profile ⏳ (Planned)
- Phone number (read-only)
- Name (editable)
- Preferences
- About section
- Logout

---

## COMPLETED WORK

### ✅ Phase 1: Project Setup
- [x] Project structure created
- [x] Dependencies configured (pubspec.yaml)
- [x] Core directories created
- [x] Theme configured (Material Design 3, matching web app colors)
- [x] API configuration setup

### ✅ Phase 2: Core Infrastructure
- [x] API Client (Dio with cookie management)
- [x] Secure Storage (auth data, session persistence)
- [x] Validators (phone, OTP, numbers, dates)
- [x] Formatters (currency, dates, phone, addresses)
- [x] API Endpoints constants
- [x] Theme system (colors, text styles, component themes)

### ✅ Phase 3: Models & Services
- [x] User model
- [x] Property model & search params
- [x] Appointment model
- [x] Mortgage calculation model
- [x] Incentive calculation model
- [x] Auth service (sendOtp, verifyOtp, checkAuthStatus, logout)
- [x] API response wrappers

### ✅ Phase 4: Authentication
- [x] Auth provider (Riverpod)
- [x] OTP verification screen
- [x] Session persistence
- [x] Auto-check auth on app start

### ✅ Phase 5: Navigation
- [x] Route constants
- [x] GoRouter configuration
- [x] Bottom navigation bar
- [x] Redirect logic for onboarding
- [x] Main scaffold structure

---

## PENDING WORK

### ⏳ Phase 6: Property Features (NEXT)
- [ ] Property service (search, details, save)
- [ ] Property providers
- [ ] Property search screen with filters
- [ ] Property card widget
- [ ] Property details screen
- [ ] Image carousel widget
- [ ] Saved properties screen

### ⏳ Phase 7: Calculators
- [ ] Calculator tab screen (mortgage/incentive tabs)
- [ ] Mortgage calculator UI
- [ ] Incentive calculator UI
- [ ] Result cards
- [ ] Slider widgets

### ⏳ Phase 8: Appointments
- [ ] Appointment service
- [ ] Appointment provider
- [ ] Book viewing screen
- [ ] Date/time picker
- [ ] Appointments list screen

### ⏳ Phase 9: Client Portal
- [ ] Portal dashboard
- [ ] Stats cards
- [ ] Profile screen
- [ ] Edit profile functionality

### ⏳ Phase 10: Polish
- [ ] Onboarding flow (3 screens)
- [ ] Loading states
- [ ] Error handling
- [ ] Empty states
- [ ] Animations/transitions
- [ ] Image caching optimization

---

## KEY INTEGRATION POINTS WITH WEB APP

### Shared Backend
- Same Firestore database
- Same session management
- Same OTP authentication flow
- Same property data (Zillow API)

### Data Sync
- User logs in on mobile → can access same data on web
- Saved properties on mobile → visible on web
- Appointments booked on mobile → visible on web admin panel
- Session shared across both (same cookies if on web browser)

### Differences
- Mobile: No admin features
- Mobile: Optimized for one-handed use
- Mobile: Simpler navigation (bottom nav)
- Mobile: Offline capability (caching)
- Web: Full admin dashboard
- Web: Desktop-optimized layouts

---

## CRITICAL CONFIGURATION

### API URL (IMPORTANT)

In `lib/core/config/app_config.dart`:

```dart
// Android Emulator (10.0.2.2 = localhost)
static const String baseUrl = 'http://10.0.2.2:3000/api';

// Physical Device (use your computer's local IP)
// static const String baseUrl = 'http://192.168.1.XXX:3000/api';

// Production
// static const String baseUrl = 'https://api.housesbc.com/api';
```

### Backend Must Be Running

```bash
cd /home/vboxuser/programs/Rida/HousesinBCV2
npm run dev
```

Server runs on: http://localhost:3000

---

## DEVELOPMENT COMMANDS

### Initial Setup (One-time)

```bash
cd /home/vboxuser/programs/Rida/houses_bc_mobile

# Create Flutter project structure
flutter create --org com.housesbc --project-name houses_bc_mobile .

# Install dependencies
flutter pub get
```

### Run App

```bash
# List devices
flutter devices

# Run on device
flutter run

# Or specify device
flutter run -d <device-id>
```

### Build APK

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

---

## CURRENT SESSION STATE

### What's Done
1. Complete project structure
2. All core utilities (validators, formatters, storage)
3. API client with cookie management
4. Theme system
5. Authentication (models, service, provider, screen)
6. Navigation/routing setup
7. Documentation (README, SETUP_INSTRUCTIONS, IMPLEMENTATION_GUIDE)

### What's Next
1. **Property Service** - Implement API calls for search, details, save
2. **Property Providers** - Riverpod providers for property state
3. **Property Search Screen** - Main browse screen with filters
4. **Property Card Widget** - Reusable property display
5. **Property Details Screen** - Full property view

### Files Ready to Implement
Reference these for next steps:
- `IMPLEMENTATION_GUIDE.md` - Complete code for all features
- `COMPLETE_CODE_REFERENCE.md` - All models and services
- `/home/vboxuser/programs/Rida/HousesinBCV2/` - Web app reference

---

## DESIGN TOKENS

### Colors (from web app)
- Primary Blue: #2563EB (Blue-600)
- Blue Dark: #1E40AF (Blue-700)
- Blue Light: #3B82F6 (Blue-500)
- Accent Green: #10B981 (Green-500)
- Accent Orange: #F97316 (Orange-500)
- Text Primary: #1F2937 (Gray-800)
- Text Secondary: #6B7280 (Gray-500)
- Background: #FAFAFA (Gray-50)

### Typography
- Display: 32/28/24px, bold
- Headline: 22/20/18px, semi-bold
- Title: 16/14/12px, semi-bold
- Body: 16/14/12px, normal
- Label: 14/12/10px, medium

### Spacing
- xs: 4px
- sm: 8px
- md: 16px
- lg: 24px
- xl: 32px

### Border Radius
- Small: 8px
- Medium: 12px
- Large: 16px
- Circle: 999px

---

## TROUBLESHOOTING REFERENCE

### Cannot connect to backend
1. Ensure backend is running: `cd HousesinBCV2 && npm run dev`
2. Check API URL in `app_config.dart`
3. Android emulator: must use `10.0.2.2` not `localhost`
4. Physical device: use computer's local IP

### Gradle build failed
```bash
cd android && ./gradlew clean && cd ..
flutter clean
flutter pub get
flutter run
```

### Hot reload not working
- Press `R` (capital) for hot restart
- Or stop and `flutter run` again

### Cookie session not persisting
- Check `dio_cookie_manager` is initialized
- Verify `PersistCookieJar` is using correct path
- Clear app data and re-login

---

## REFERENCE WEB APP CODE

When implementing features, refer to these web app files:

**Auth:**
- `HousesinBCV2/server/routes/auth.ts`
- `HousesinBCV2/client/src/hooks/useAuth.tsx`

**Properties:**
- `HousesinBCV2/server/routes/properties.ts`
- `HousesinBCV2/server/services/zillow.ts`
- `HousesinBCV2/client/src/pages/Properties.tsx`

**Saved Properties:**
- `HousesinBCV2/server/routes/savedProperties.ts`
- `HousesinBCV2/client/src/components/SavePropertyModal.tsx`

**Appointments:**
- `HousesinBCV2/server/routes/appointments.ts`
- `HousesinBCV2/client/src/components/AppointmentBookingModal.tsx`

**Client Portal:**
- `HousesinBCV2/client/src/pages/ClientDashboard.tsx`

---

## CONTACT & NOTES

**Project Owner:** Building for BC first-time home buyers
**Backend:** Already complete and tested
**Mobile App:** New development, integrating with existing backend
**Goal:** Make house-hunting easier with mobile-first experience

**Key Principles:**
1. Don't force login upfront - let users browse
2. Trigger auth when saving/booking
3. Keep UI clean and simple
4. Emphasize property photos
5. Fast performance with caching
6. One-handed mobile use

---

**END OF PROJECT CONTEXT**

Use this document to resume work in a new session. All critical information is captured here.
