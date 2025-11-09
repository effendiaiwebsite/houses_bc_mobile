import 'package:flutter/foundation.dart' show kIsWeb;

/// Application Configuration
///
/// Central configuration for API URLs, constants, and environment settings
class AppConfig {
  // Private constructor to prevent instantiation
  AppConfig._();

  // API Configuration
  // Automatically uses the correct URL based on platform:
  // - Web: localhost (since browser runs on same machine as server)
  // - Android Emulator: 10.0.2.2 (special alias for host machine)
  // - Physical Device: Use your computer's IP on the same network

  // TODO: For physical device testing, replace this with your computer's actual IP
  // You can find it by running: `hostname -I` on Linux/Mac or `ipconfig` on Windows
  static const String _physicalDeviceIp = '10.0.2.15'; // Update this for physical device testing

  static String get baseUrl {
    if (kIsWeb) {
      // Web version - use localhost for development
      return 'http://localhost:3000/api';
    } else {
      // Mobile version
      // When isDevelopment is true, use localhost for testing
      // When false, use production backend
      if (isDevelopment) {
        // Local development - works for Android Emulator
        return 'http://10.0.2.2:3000/api'; // Android Emulator localhost

        // For physical device testing, use your computer's IP:
        // return 'http://$_physicalDeviceIp:3000/api'; // Physical Device
      } else {
        // Production backend
        return 'https://housesinbc.com/api';
      }
    }
  }

  // API Timeouts
  static const Duration connectionTimeout = Duration(seconds: 120);
  static const Duration sendTimeout = Duration(seconds: 120);
  static const Duration receiveTimeout = Duration(seconds: 120);

  // Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserPhone = 'user_phone';
  static const String keyUserRole = 'user_role';
  static const String keyIsAuthenticated = 'is_authenticated';
  static const String keyOnboardingComplete = 'onboarding_complete';

  // Preferences Keys (SharedPreferences - non-sensitive data)
  static const String keyRecentSearches = 'recent_searches';
  static const String keySearchFilters = 'search_filters';

  // App Constants
  static const String appName = 'Houses BC';
  static const String defaultLocation = 'British Columbia';
  static const int propertiesPerPage = 20;
  static const int maxRecentSearches = 10;

  // OTP Configuration
  static const int otpLength = 6;
  static const Duration otpExpiry = Duration(minutes: 10);

  // Map Configuration
  static const double defaultLatitude = 49.2827; // Vancouver
  static const double defaultLongitude = -123.1207;
  static const double defaultZoom = 12.0;

  // Image Configuration
  static const String placeholderImage = 'assets/images/placeholder_house.png';
  static const int imageCacheMaxAge = 7; // days

  // Environment
  static const bool isDevelopment = false; // Set to false for production
  static const bool enableLogging = true; // Temporarily enable for debugging
}
