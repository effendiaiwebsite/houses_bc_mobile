# Complete Implementation Guide

This guide contains ALL the remaining code you need to complete the Houses BC Mobile app.

---

## TABLE OF CONTENTS

1. [Routing & Navigation](#routing--navigation)
2. [Authentication Implementation](#authentication-implementation)
3. [Property Features](#property-features)
4. [Calculator Screens](#calculator-screens)
5. [Appointments](#appointments)
6. [Client Portal](#client-portal)
7. [Shared Widgets](#shared-widgets)

---

## ROUTING & NAVIGATION

### lib/routes/app_routes.dart

```dart
/// Route names as constants
class AppRoutes {
  AppRoutes._();

  // Core
  static const splash = '/splash';
  static const onboarding = '/onboarding';

  // Main navigation
  static const home = '/';
  static const browse = '/browse';
  static const calculators = '/calculators';
  static const portal = '/portal';

  // Properties
  static const propertyDetails = '/property/:zpid';
  static const savedProperties = '/saved-properties';

  // Auth
  static const otpVerification = '/otp-verification';

  // Calculators
  static const mortgageCalculator = '/calculators/mortgage';
  static const incentiveCalculator = '/calculators/incentive';

  // Appointments
  static const bookViewing = '/book-viewing';
  static const appointments = '/appointments';

  // Profile
  static const profile = '/profile';
}
```

### lib/routes/app_router.dart

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/screens/otp_verification_screen.dart';
import '../features/onboarding/screens/welcome_screen.dart';
import '../features/onboarding/screens/onboarding_flow.dart';
import '../features/properties/screens/property_search_screen.dart';
import '../features/properties/screens/property_details_screen.dart';
import '../features/properties/screens/saved_properties_screen.dart';
import '../features/calculators/screens/mortgage_calculator_screen.dart';
import '../features/calculators/screens/incentive_calculator_screen.dart';
import '../features/calculators/screens/calculators_tab_screen.dart';
import '../features/appointments/screens/book_viewing_screen.dart';
import '../features/client_portal/screens/client_portal_screen.dart';
import '../features/client_portal/screens/profile_screen.dart';
import '../core/storage/secure_storage.dart';
import 'app_routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) async {
      // Check if onboarding is complete
      final storage = SecureStorageService.instance;
      final onboardingComplete = storage.isOnboardingComplete();

      final isSplash = state.matchedLocation == AppRoutes.splash;
      final isOnboarding = state.matchedLocation == AppRoutes.onboarding;
      final isOtpVerification = state.matchedLocation == AppRoutes.otpVerification;

      // If on splash, decide where to go
      if (isSplash) {
        if (!onboardingComplete) {
          return AppRoutes.onboarding;
        }
        return AppRoutes.home;
      }

      // If onboarding not complete and not on onboarding screen
      if (!onboardingComplete && !isOnboarding) {
        return AppRoutes.onboarding;
      }

      return null; // No redirect
    },
    routes: [
      // Splash
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingFlow(),
      ),

      // Main navigation with bottom nav bar
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          // Home / Browse Properties
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const PropertySearchScreen(),
          ),

          // Calculators
          GoRoute(
            path: AppRoutes.calculators,
            builder: (context, state) => const CalculatorsTabScreen(),
          ),

          // Portal
          GoRoute(
            path: AppRoutes.portal,
            builder: (context, state) => const ClientPortalScreen(),
          ),
        ],
      ),

      // Property Details
      GoRoute(
        path: AppRoutes.propertyDetails,
        builder: (context, state) {
          final zpid = state.pathParameters['zpid']!;
          return PropertyDetailsScreen(zpid: zpid);
        },
      ),

      // Saved Properties
      GoRoute(
        path: AppRoutes.savedProperties,
        builder: (context, state) => const SavedPropertiesScreen(),
      ),

      // OTP Verification
      GoRoute(
        path: AppRoutes.otpVerification,
        builder: (context, state) {
          final phoneNumber = state.uri.queryParameters['phone'];
          final onSuccess = state.extra as VoidCallback?;
          return OtpVerificationScreen(
            phoneNumber: phoneNumber,
            onSuccess: onSuccess,
          );
        },
      ),

      // Book Viewing
      GoRoute(
        path: AppRoutes.bookViewing,
        builder: (context, state) {
          final property = state.extra; // Pass property object
          return BookViewingScreen(property: property);
        },
      ),

      // Profile
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.matchedLocation}'),
      ),
    ),
  );
});

/// Splash screen
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// Main scaffold with bottom navigation
class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Portal',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(AppRoutes.calculators)) return 1;
    if (location.startsWith(AppRoutes.portal)) return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.calculators);
        break;
      case 2:
        context.go(AppRoutes.portal);
        break;
    }
  }
}
```

---

## AUTHENTICATION IMPLEMENTATION

### lib/features/auth/providers/auth_provider.dart

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../../../shared/models/api_response.dart';

// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Auth State
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final LoadingState loadingState;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.loadingState = LoadingState.initial,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    LoadingState? loadingState,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      loadingState: loadingState ?? this.loadingState,
    );
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState()) {
    _checkAuthStatus();
  }

  // Check authentication status on app start
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(loadingState: LoadingState.loading);

    final result = await _authService.checkAuthStatus();

    if (result.isSuccess) {
      state = state.copyWith(
        user: result.data,
        loadingState: LoadingState.success,
      );
    } else {
      state = state.copyWith(
        loadingState: LoadingState.error,
        error: result.error,
      );
    }
  }

  // Send OTP
  Future<Result<void>> sendOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _authService.sendOtp(phoneNumber);

    state = state.copyWith(isLoading: false);

    if (result.isFailure) {
      state = state.copyWith(error: result.error);
    }

    return result;
  }

  // Verify OTP
  Future<Result<User>> verifyOtp(String phoneNumber, String code) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _authService.verifyOtp(phoneNumber, code);

    if (result.isSuccess) {
      state = state.copyWith(
        user: result.data,
        isLoading: false,
        loadingState: LoadingState.success,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.error,
      );
    }

    return result;
  }

  // Logout
  Future<void> logout() async {
    await _authService.logout();
    state = AuthState(); // Reset to initial state
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Auth Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});
```

### lib/features/auth/screens/otp_verification_screen.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../providers/auth_provider.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String? phoneNumber;
  final VoidCallback? onSuccess;

  const OtpVerificationScreen({
    super.key,
    this.phoneNumber,
    this.onSuccess,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _otpSent = false;
  int _countdown = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.phoneNumber != null) {
      _phoneController.text = widget.phoneNumber!;
      _sendOtp(); // Auto-send OTP if phone number provided
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _countdown = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final phoneNumber = Validators.cleanPhone(_phoneController.text);
    final result = await ref.read(authNotifierProvider.notifier).sendOtp(phoneNumber);

    if (result.isSuccess) {
      setState(() {
        _otpSent = true;
      });
      _startCountdown();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification code sent!')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.error ?? 'Failed to send code')),
        );
      }
    }
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final phoneNumber = Validators.cleanPhone(_phoneController.text);
    final code = _otpController.text;

    final result = await ref.read(authNotifierProvider.notifier).verifyOtp(phoneNumber, code);

    if (result.isSuccess) {
      if (mounted) {
        // Call success callback if provided
        widget.onSuccess?.call();

        // Navigate back or to portal
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/portal');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in successfully!')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.error ?? 'Verification failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                // Header
                Text(
                  _otpSent ? 'Enter Verification Code' : 'Enter Your Phone Number',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _otpSent
                      ? 'We sent a 6-digit code to ${_phoneController.text}'
                      : 'We\'ll send you a verification code',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Phone Number Field
                if (!_otpSent) ...[
                  AppTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    hint: '+1234567890',
                    keyboardType: TextInputType.phone,
                    validator: Validators.validatePhone,
                    prefixIcon: Icons.phone,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Send Code',
                    onPressed: _sendOtp,
                    isLoading: authState.isLoading,
                  ),
                ],

                // OTP Field
                if (_otpSent) ...[
                  AppTextField(
                    controller: _otpController,
                    label: 'Verification Code',
                    hint: '000000',
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    validator: Validators.validateOtp,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Verify',
                    onPressed: _verifyOtp,
                    isLoading: authState.isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Resend button
                  if (_countdown == 0)
                    TextButton(
                      onPressed: _sendOtp,
                      child: const Text('Resend Code'),
                    )
                  else
                    Text(
                      'Resend code in $_countdown seconds',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],

                const Spacer(),

                // Info text
                Text(
                  'By continuing, you agree to our Terms of Service and Privacy Policy',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

Continue in next file due to length...
