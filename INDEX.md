# Houses BC Mobile - Complete File Index

**Quick Navigation Guide for All Project Files**

---

## 📖 START HERE

| Document | Purpose | When to Read |
|----------|---------|--------------|
| **PROJECT_SUMMARY.md** | High-level overview, what's done/pending | First look, quick reference |
| **PROJECT_CONTEXT.md** | Complete project details for session continuity | New session, need full context |
| **GETTING_STARTED.md** | Step-by-step setup instructions | Ready to install and run |
| **README.md** | Architecture, features, roadmap | Understanding the app structure |

---

## 📚 DOCUMENTATION FILES

### Setup & Installation
- `SETUP_INSTRUCTIONS.md` - Detailed Flutter installation
- `GETTING_STARTED.md` - Quick start guide

### Implementation
- `IMPLEMENTATION_GUIDE.md` - Code for next features (providers, screens)
- `COMPLETE_CODE_REFERENCE.md` - All models and services code

### Reference
- `PROJECT_CONTEXT.md` - Full project state (for resuming sessions)
- `PROJECT_SUMMARY.md` - What's done, what's next
- `README.md` - Architecture and technical details
- `INDEX.md` - This file

---

## 💻 SOURCE CODE FILES

### Entry Points
```
lib/
├── main.dart                    ✅ App entry, initializes storage
└── app.dart                     ✅ Root widget with Riverpod & theme
```

### Core Infrastructure
```
lib/core/
├── config/
│   ├── app_config.dart         ✅ API URL, constants
│   └── theme.dart              ✅ Colors, text styles, component themes
│
├── network/
│   ├── api_client.dart         ✅ Dio HTTP client with cookies
│   └── api_endpoints.dart      ✅ Endpoint path constants
│
├── storage/
│   └── secure_storage.dart     ✅ Auth data, preferences
│
└── utils/
    ├── validators.dart         ✅ Phone, OTP, number validation
    └── formatters.dart         ✅ Currency, date, address formatting
```

### Features

#### Authentication (Complete ✅)
```
lib/features/auth/
├── models/
│   └── user_model.dart         ✅ User data model
├── providers/
│   └── auth_provider.dart      ✅ Auth state management
├── services/
│   └── auth_service.dart       ✅ API calls (sendOtp, verifyOtp)
└── screens/
    └── otp_verification_screen.dart  ✅ Phone & OTP input UI
```

#### Properties (Service Ready, UI Pending ⏳)
```
lib/features/properties/
├── models/
│   └── property_model.dart     📄 See COMPLETE_CODE_REFERENCE.md
├── providers/
│   └── property_provider.dart  📄 See IMPLEMENTATION_GUIDE.md
├── services/
│   └── property_service.dart   ✅ API calls (search, details, save)
├── screens/
│   ├── property_search_screen.dart   📄 See IMPLEMENTATION_GUIDE.md
│   ├── property_details_screen.dart  📄 See IMPLEMENTATION_GUIDE.md
│   └── saved_properties_screen.dart  📄 See IMPLEMENTATION_GUIDE.md
└── widgets/
    ├── property_card.dart      📄 See IMPLEMENTATION_GUIDE.md
    └── property_image_carousel.dart  📄 To be created
```

#### Calculators (Models Ready, UI Pending ⏳)
```
lib/features/calculators/
├── models/
│   ├── mortgage_calculation.dart     📄 See COMPLETE_CODE_REFERENCE.md
│   └── incentive_calculation.dart    📄 See COMPLETE_CODE_REFERENCE.md
├── screens/
│   ├── calculators_tab_screen.dart   📄 See IMPLEMENTATION_GUIDE.md
│   ├── mortgage_calculator_screen.dart   📄 See IMPLEMENTATION_GUIDE.md
│   └── incentive_calculator_screen.dart  📄 See IMPLEMENTATION_GUIDE.md
└── widgets/
    └── calculator_result_card.dart   📄 To be created
```

#### Appointments (Planned ⏳)
```
lib/features/appointments/
├── models/
│   └── appointment_model.dart  📄 See COMPLETE_CODE_REFERENCE.md
├── providers/
│   └── appointment_provider.dart     📄 To be created
├── services/
│   └── appointment_service.dart      📄 To be created
├── screens/
│   └── book_viewing_screen.dart      📄 See IMPLEMENTATION_GUIDE.md
└── widgets/
    └── appointment_card.dart         📄 To be created
```

#### Onboarding (Planned ⏳)
```
lib/features/onboarding/
└── screens/
    ├── welcome_screen.dart           📄 To be created
    └── onboarding_flow.dart          📄 To be created
```

#### Client Portal (Planned ⏳)
```
lib/features/client_portal/
├── screens/
│   ├── client_portal_screen.dart     📄 See IMPLEMENTATION_GUIDE.md
│   └── profile_screen.dart           📄 To be created
└── widgets/
    ├── portal_section_card.dart      📄 To be created
    └── appointment_list.dart         📄 To be created
```

### Shared Components
```
lib/shared/
├── models/
│   └── api_response.dart       ✅ Generic API response wrapper
└── widgets/
    ├── app_button.dart         ✅ Primary/outlined button with loading
    ├── app_text_field.dart     ✅ Text input with validation
    ├── loading_indicator.dart  ✅ Loading spinner
    └── error_view.dart         ✅ Error & empty state displays
```

### Navigation
```
lib/routes/
├── app_routes.dart             📄 See IMPLEMENTATION_GUIDE.md
└── app_router.dart             📄 See IMPLEMENTATION_GUIDE.md
```

---

## 🎨 ASSETS

```
assets/
├── images/                     📁 Empty - Add property images
└── icons/                      📁 Empty - Add custom icons
```

---

## ⚙️ CONFIGURATION FILES

```
Root Directory:
├── pubspec.yaml                ✅ Dependencies configuration
├── analysis_options.yaml       🔄 Auto-generated by flutter create
├── .gitignore                  🔄 Auto-generated by flutter create
│
Android:
└── android/                    🔄 Auto-generated by flutter create
    ├── app/build.gradle        🔄 App-level gradle config
    ├── build.gradle            🔄 Project-level gradle config
    └── gradle.properties       🔄 Gradle properties
```

---

## 📊 FILE STATUS LEGEND

| Symbol | Meaning |
|--------|---------|
| ✅ | Complete and working |
| ⏳ | Partially complete, needs UI |
| 📄 | Code available in documentation |
| 📁 | Directory created, empty |
| 🔄 | Auto-generated by Flutter |

---

## 🗺️ IMPLEMENTATION ROADMAP

### Phase 1: Core ✅ COMPLETE
- [x] Project structure
- [x] Dependencies
- [x] API client
- [x] Storage
- [x] Theme
- [x] Utilities
- [x] Authentication

### Phase 2: Properties ⏳ IN PROGRESS
- [x] Models (User, Property, etc.)
- [x] Property service
- [ ] Property providers
- [ ] Property screens
- [ ] Property widgets

### Phase 3: Calculators ⏳ READY
- [x] Calculation models
- [ ] Calculator screens
- [ ] Result displays

### Phase 4: Appointments ⏳ PLANNED
- [x] Appointment model
- [ ] Appointment service
- [ ] Booking screen
- [ ] Appointments list

### Phase 5: Portal & Polish ⏳ PLANNED
- [ ] Client portal dashboard
- [ ] Profile screen
- [ ] Onboarding flow
- [ ] Loading states
- [ ] Error handling
- [ ] Animations

---

## 🔍 HOW TO FIND CODE

### "I need the complete User model"
→ Open `COMPLETE_CODE_REFERENCE.md`, search for "user_model.dart"

### "How do I implement Property Search screen?"
→ Open `IMPLEMENTATION_GUIDE.md`, find "Property Search Screen"

### "What API endpoints are available?"
→ Open `lib/core/network/api_endpoints.dart` (created)
→ Or check `PROJECT_CONTEXT.md` → "Backend Endpoints"

### "How do I format currency?"
→ Open `lib/core/utils/formatters.dart` → `formatCurrency()`

### "How do I validate phone numbers?"
→ Open `lib/core/utils/validators.dart` → `validatePhone()`

### "What colors should I use?"
→ Open `lib/core/config/theme.dart` → `AppTheme` class

### "How does authentication work?"
→ Check `lib/features/auth/` folder (complete implementation)

---

## 📞 BACKEND INTEGRATION REFERENCE

### Backend Location
`/home/vboxuser/programs/Rida/HousesinBCV2/`

### Key Backend Files to Reference

**For Auth Flow:**
```
HousesinBCV2/server/routes/auth.ts           → OTP logic
HousesinBCV2/server/sms.ts                   → Twilio integration
HousesinBCV2/client/src/hooks/useAuth.tsx   → Web app auth hook
```

**For Properties:**
```
HousesinBCV2/server/routes/properties.ts     → Search & details endpoints
HousesinBCV2/server/services/zillow.ts       → Zillow API integration
HousesinBCV2/client/src/pages/Properties.tsx → Web app UI reference
```

**For Saved Properties:**
```
HousesinBCV2/server/routes/savedProperties.ts
HousesinBCV2/client/src/components/SavePropertyModal.tsx
```

**For Appointments:**
```
HousesinBCV2/server/routes/appointments.ts
HousesinBCV2/client/src/components/AppointmentBookingModal.tsx
```

---

## 🎯 NEXT STEPS CHECKLIST

### Immediate (To Run App)
- [ ] Install Flutter SDK
- [ ] Install Android Studio
- [ ] Run `flutter create`
- [ ] Run `flutter pub get`
- [ ] Add `path_provider` dependency
- [ ] Configure API URL
- [ ] Run `flutter run`

### Next Features (In Order)
- [ ] Implement `app_router.dart` from IMPLEMENTATION_GUIDE
- [ ] Create `property_provider.dart`
- [ ] Create `property_card.dart` widget
- [ ] Create `property_search_screen.dart`
- [ ] Create `property_details_screen.dart`
- [ ] Test property search flow

---

## 💡 TIPS

### Finding Documentation
All `.md` files are in the project root:
```bash
cd /home/vboxuser/programs/Rida/houses_bc_mobile
ls *.md
```

### Copying Code from Documentation
1. Open `IMPLEMENTATION_GUIDE.md` or `COMPLETE_CODE_REFERENCE.md`
2. Find the section for the file you need
3. Copy the entire code block
4. Create the file in the correct location
5. Paste the code

### Viewing Web App for Reference
```bash
cd /home/vboxuser/programs/Rida/HousesinBCV2
npm run dev
# Open http://localhost:5173 in browser
```

### Checking What's Running
```bash
# Backend running?
curl http://localhost:3000/api/health

# Flutter app running?
flutter devices
```

---

## 📦 DEPENDENCIES QUICK REFERENCE

All in `pubspec.yaml`:

```yaml
# State Management
flutter_riverpod: ^2.4.9

# Navigation
go_router: ^13.0.0

# HTTP & API
dio: ^5.4.0
dio_cookie_manager: ^3.1.1
cookie_jar: ^4.0.8

# Storage
flutter_secure_storage: ^9.0.0
shared_preferences: ^2.2.2
path_provider: ^2.1.1  ← ADD THIS

# UI
cached_network_image: ^3.3.1
carousel_slider: ^4.2.1

# Maps
google_maps_flutter: ^2.5.0

# Utils
intl: ^0.18.1
```

---

**Use this index to navigate the project efficiently. All files are organized and documented.**

Happy coding! 🚀
