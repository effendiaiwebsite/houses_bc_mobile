/// Route names as constants
class AppRoutes {
  AppRoutes._();

  // Core
  static const splash = '/splash';
  static const home = '/';

  // Properties
  static const propertyDetails = '/property/:zpid';
  static const savedProperties = '/saved-properties';

  // Auth
  static const otpVerification = '/otp-verification';

  // Calculators
  static const calculators = '/calculators';
  static const mortgageCalculator = '/calculators/mortgage';
  static const incentiveCalculator = '/calculators/incentive';

  // Appointments
  static const bookViewing = '/book-viewing';
  static const appointments = '/appointments';

  // Portal
  static const portal = '/portal';
  static const profile = '/profile';
}
