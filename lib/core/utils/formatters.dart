import 'package:intl/intl.dart';

/// Data Formatters
///
/// Utility functions for formatting currency, numbers, dates, etc.
class Formatters {
  Formatters._();

  /// Format number as currency (CAD)
  static String formatCurrency(num amount, {bool includeSymbol = true}) {
    final formatter = NumberFormat.currency(
      locale: 'en_CA',
      symbol: includeSymbol ? '\$' : '',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Format number with commas
  static String formatNumber(num number, {int decimals = 0}) {
    final formatter = NumberFormat('#,##0${decimals > 0 ? '.' : ''}${'0' * decimals}');
    return formatter.format(number);
  }

  /// Format number as compact (e.g., 1.2M, 500K)
  static String formatCompact(num number) {
    final formatter = NumberFormat.compact(locale: 'en_CA');
    return formatter.format(number);
  }

  /// Format price range
  static String formatPriceRange(num? min, num? max) {
    if (min == null && max == null) return 'Any Price';
    if (min == null) return 'Up to ${formatCurrency(max!)}';
    if (max == null) return '${formatCurrency(min)} +';
    return '${formatCurrency(min)} - ${formatCurrency(max)}';
  }

  /// Format date (e.g., Jan 15, 2025)
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }

  /// Format date and time (e.g., Jan 15, 2025 at 2:30 PM)
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, y \'at\' h:mm a').format(dateTime);
  }

  /// Format time only (e.g., 2:30 PM)
  static String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  /// Format relative time (e.g., "2 days ago", "in 3 hours")
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.isNegative) {
      // Past
      final absDiff = difference.abs();
      if (absDiff.inDays > 365) {
        final years = (absDiff.inDays / 365).floor();
        return '$years ${years == 1 ? 'year' : 'years'} ago';
      } else if (absDiff.inDays > 30) {
        final months = (absDiff.inDays / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else if (absDiff.inDays > 0) {
        return '${absDiff.inDays} ${absDiff.inDays == 1 ? 'day' : 'days'} ago';
      } else if (absDiff.inHours > 0) {
        return '${absDiff.inHours} ${absDiff.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (absDiff.inMinutes > 0) {
        return '${absDiff.inMinutes} ${absDiff.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else {
        return 'Just now';
      }
    } else {
      // Future
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return 'in $years ${years == 1 ? 'year' : 'years'}';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return 'in $months ${months == 1 ? 'month' : 'months'}';
      } else if (difference.inDays > 0) {
        return 'in ${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'}';
      } else if (difference.inHours > 0) {
        return 'in ${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'}';
      } else if (difference.inMinutes > 0) {
        return 'in ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}';
      } else {
        return 'Now';
      }
    }
  }

  /// Format property address
  static String formatAddress(String? street, String? city, String? province) {
    final parts = <String>[];
    if (street != null && street.isNotEmpty) parts.add(street);
    if (city != null && city.isNotEmpty) parts.add(city);
    if (province != null && province.isNotEmpty) parts.add(province);
    return parts.join(', ');
  }

  /// Format area (square feet)
  static String formatArea(num sqft) {
    return '${formatNumber(sqft)} sq ft';
  }

  /// Format percentage
  static String formatPercentage(num value, {int decimals = 1}) {
    return '${value.toStringAsFixed(decimals)}%';
  }

  /// Format interest rate
  static String formatInterestRate(num rate) {
    return '${rate.toStringAsFixed(2)}%';
  }

  /// Parse currency string to number
  static num? parseCurrency(String? value) {
    if (value == null || value.isEmpty) return null;
    // Remove currency symbols, commas, spaces
    final cleaned = value.replaceAll(RegExp(r'[^\d.]'), '');
    return num.tryParse(cleaned);
  }

  /// Format phone number for display
  static String formatPhone(String phone) {
    // Remove all non-digit characters except +
    final cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');

    if (cleaned.length < 4) return cleaned;

    // Format as +1 (234) 567-8900
    if (cleaned.startsWith('+1') && cleaned.length == 12) {
      return '+1 (${cleaned.substring(2, 5)}) ${cleaned.substring(5, 8)}-${cleaned.substring(8)}';
    }

    // Generic formatting
    return cleaned;
  }

  /// Truncate text with ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Format distance (km)
  static String formatDistance(double km) {
    if (km < 1) {
      return '${(km * 1000).toInt()} m';
    }
    return '${km.toStringAsFixed(1)} km';
  }

  /// Pluralize word based on count
  static String pluralize(int count, String singular, {String? plural}) {
    if (count == 1) return singular;
    return plural ?? '${singular}s';
  }

  /// Format beds/baths (e.g., "3 beds, 2 baths")
  static String formatBedsBaths(int? beds, int? baths) {
    final parts = <String>[];
    if (beds != null) parts.add('$beds ${pluralize(beds, 'bed')}');
    if (baths != null) parts.add('$baths ${pluralize(baths, 'bath')}');
    return parts.join(', ');
  }

  /// Format status (capitalize first letter)
  static String formatStatus(String status) {
    if (status.isEmpty) return status;
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }
}
