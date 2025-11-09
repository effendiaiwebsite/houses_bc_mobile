/// API Endpoints
///
/// Centralized endpoint definitions for all API calls
class ApiEndpoints {
  ApiEndpoints._();

  // Auth Endpoints
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String authStatus = '/auth/status';
  static const String logout = '/auth/logout';

  // Property Endpoints
  static const String searchProperties = '/properties/search';
  static String propertyDetails(String zpid) => '/properties/$zpid';

  // Saved Properties Endpoints
  static const String savedProperties = '/saved-properties';
  static String deleteSavedProperty(String id) => '/saved-properties/$id';

  // Appointment Endpoints
  static const String appointments = '/appointments';
  static String appointmentDetails(String id) => '/appointments/$id';
  static String cancelAppointment(String id) => '/appointments/$id';

  // Chatbot Endpoints
  static const String chatbotMessage = '/chatbot/message';
  static String chatbotHistory(String sessionId) => '/chatbot/history/$sessionId';
  static String chatbotDeleteSession(String sessionId) => '/chatbot/session/$sessionId';

  // Health Check
  static const String health = '/health';
}
