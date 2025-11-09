/// Input Validators
///
/// Validation functions for forms and user input
class Validators {
  Validators._();

  /// Validate phone number (E.164 format)
  /// E.g., +1234567890
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove spaces and dashes
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

    // Check if it starts with + and has 10-15 digits
    final regex = RegExp(r'^\+[1-9]\d{9,14}$');
    if (!regex.hasMatch(cleaned)) {
      return 'Please enter a valid phone number (e.g., +1234567890)';
    }

    return null;
  }

  /// Validate OTP code
  static String? validateOtp(String? value, {int length = 6}) {
    if (value == null || value.isEmpty) {
      return 'Verification code is required';
    }

    if (value.length != length) {
      return 'Please enter the $length-digit code';
    }

    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Code must contain only numbers';
    }

    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate number
  static String? validateNumber(String? value, {String fieldName = 'Value'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    final number = num.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    return null;
  }

  /// Validate number in range
  static String? validateNumberInRange(
    String? value, {
    required num min,
    required num max,
    String? fieldName,
  }) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Value'} is required';
    }

    final number = num.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (number < min || number > max) {
      return 'Must be between $min and $max';
    }

    return null;
  }

  /// Validate email (optional, for future use)
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate minimum length
  static String? validateMinLength(
    String? value, {
    required int minLength,
    String? fieldName,
  }) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    if (value.length < minLength) {
      return 'Must be at least $minLength characters';
    }

    return null;
  }

  /// Validate price
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }

    final price = num.tryParse(value.replaceAll(RegExp(r'[^\d.]'), ''));
    if (price == null || price <= 0) {
      return 'Please enter a valid price';
    }

    return null;
  }

  /// Validate date is in the future
  static String? validateFutureDate(DateTime? date) {
    if (date == null) {
      return 'Date is required';
    }

    if (date.isBefore(DateTime.now())) {
      return 'Please select a future date';
    }

    return null;
  }

  /// Format phone number for display
  /// Adds spaces for readability
  static String formatPhoneDisplay(String phone) {
    // Remove all non-digit characters except +
    final cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');

    if (cleaned.length < 4) return cleaned;

    // Format as +1 234 567 8900
    if (cleaned.startsWith('+1') && cleaned.length == 12) {
      return '${cleaned.substring(0, 2)} ${cleaned.substring(2, 5)} ${cleaned.substring(5, 8)} ${cleaned.substring(8)}';
    }

    // Generic formatting for other formats
    return cleaned;
  }

  /// Clean phone number to E.164 format
  static String cleanPhone(String phone) {
    // Remove all non-digit characters except +
    return phone.replaceAll(RegExp(r'[^\d+]'), '');
  }
}
