# Complete Flutter Code Reference

This document contains all the code files for the Houses BC Mobile app. Copy each section into the corresponding file path.

---

## MODELS

### lib/features/auth/models/user_model.dart

```dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String phoneNumber;
  final String role;
  final String? name;
  final bool verified;
  final DateTime? lastLogin;

  const User({
    required this.id,
    required this.phoneNumber,
    required this.role,
    this.name,
    required this.verified,
    this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      phoneNumber: json['phoneNumber'] as String,
      role: json['role'] as String? ?? 'client',
      name: json['name'] as String?,
      verified: json['verified'] as bool? ?? false,
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'role': role,
      'name': name,
      'verified': verified,
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? phoneNumber,
    String? role,
    String? name,
    bool? verified,
    DateTime? lastLogin,
  }) {
    return User(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      name: name ?? this.name,
      verified: verified ?? this.verified,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  @override
  List<Object?> get props => [id, phoneNumber, role, name, verified, lastLogin];
}
```

---

### lib/features/properties/models/property_model.dart

```dart
import 'package:equatable/equatable.dart';

class Property extends Equatable {
  final String zpid;
  final String? address;
  final String? city;
  final String? state;
  final String? zipcode;
  final double? price;
  final int? beds;
  final double? baths;
  final double? sqft;
  final String? propertyType;
  final String? listingStatus;
  final List<String>? images;
  final double? latitude;
  final double? longitude;
  final String? description;
  final int? yearBuilt;
  final double? lotSize;
  final String? listingUrl;

  const Property({
    required this.zpid,
    this.address,
    this.city,
    this.state,
    this.zipcode,
    this.price,
    this.beds,
    this.baths,
    this.sqft,
    this.propertyType,
    this.listingStatus,
    this.images,
    this.latitude,
    this.longitude,
    this.description,
    this.yearBuilt,
    this.lotSize,
    this.listingUrl,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      zpid: json['zpid']?.toString() ?? '',
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipcode: json['zipcode'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      beds: json['beds'] as int?,
      baths: (json['baths'] as num?)?.toDouble(),
      sqft: (json['sqft'] as num?)?.toDouble(),
      propertyType: json['propertyType'] as String?,
      listingStatus: json['listingStatus'] as String?,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : null,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      description: json['description'] as String?,
      yearBuilt: json['yearBuilt'] as int?,
      lotSize: (json['lotSize'] as num?)?.toDouble(),
      listingUrl: json['listingUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'zpid': zpid,
      'address': address,
      'city': city,
      'state': state,
      'zipcode': zipcode,
      'price': price,
      'beds': beds,
      'baths': baths,
      'sqft': sqft,
      'propertyType': propertyType,
      'listingStatus': listingStatus,
      'images': images,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'yearBuilt': yearBuilt,
      'lotSize': lotSize,
      'listingUrl': listingUrl,
    };
  }

  String get fullAddress {
    final parts = <String>[];
    if (address != null) parts.add(address!);
    if (city != null) parts.add(city!);
    if (state != null) parts.add(state!);
    if (zipcode != null) parts.add(zipcode!);
    return parts.join(', ');
  }

  String? get primaryImage => images?.isNotEmpty == true ? images!.first : null;

  @override
  List<Object?> get props => [
        zpid,
        address,
        city,
        state,
        zipcode,
        price,
        beds,
        baths,
        sqft,
        propertyType,
        listingStatus,
        images,
        latitude,
        longitude,
        description,
        yearBuilt,
        lotSize,
        listingUrl,
      ];
}

class PropertySearchParams extends Equatable {
  final String location;
  final String statusType; // 'ForSale' or 'ForRent'
  final String? homeType;
  final double? minPrice;
  final double? maxPrice;
  final int? beds;
  final int? baths;
  final int page;

  const PropertySearchParams({
    this.location = 'British Columbia',
    this.statusType = 'ForSale',
    this.homeType,
    this.minPrice,
    this.maxPrice,
    this.beds,
    this.baths,
    this.page = 1,
  });

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{
      'location': location,
      'status_type': statusType,
      'page': page,
    };

    if (homeType != null) params['home_type'] = homeType;
    if (minPrice != null) params['minPrice'] = minPrice;
    if (maxPrice != null) params['maxPrice'] = maxPrice;
    if (beds != null) params['beds'] = beds;
    if (baths != null) params['baths'] = baths;

    return params;
  }

  PropertySearchParams copyWith({
    String? location,
    String? statusType,
    String? homeType,
    double? minPrice,
    double? maxPrice,
    int? beds,
    int? baths,
    int? page,
  }) {
    return PropertySearchParams(
      location: location ?? this.location,
      statusType: statusType ?? this.statusType,
      homeType: homeType ?? this.homeType,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      beds: beds ?? this.beds,
      baths: baths ?? this.baths,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props =>
      [location, statusType, homeType, minPrice, maxPrice, beds, baths, page];
}

class SavedProperty extends Equatable {
  final String id;
  final String userId;
  final Property property;
  final DateTime savedAt;
  final String? notes;

  const SavedProperty({
    required this.id,
    required this.userId,
    required this.property,
    required this.savedAt,
    this.notes,
  });

  factory SavedProperty.fromJson(Map<String, dynamic> json) {
    return SavedProperty(
      id: json['id'] as String,
      userId: json['userId'] as String,
      property: Property.fromJson(json['property'] as Map<String, dynamic>),
      savedAt: DateTime.parse(json['savedAt'] as String),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'property': property.toJson(),
      'savedAt': savedAt.toIso8601String(),
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [id, userId, property, savedAt, notes];
}
```

---

### lib/features/appointments/models/appointment_model.dart

```dart
import 'package:equatable/equatable.dart';
import '../../properties/models/property_model.dart';

class Appointment extends Equatable {
  final String id;
  final String userId;
  final Property property;
  final DateTime dateTime;
  final String status; // 'scheduled', 'completed', 'cancelled'
  final String? notes;
  final DateTime createdAt;

  const Appointment({
    required this.id,
    required this.userId,
    required this.property,
    required this.dateTime,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      userId: json['userId'] as String,
      property: Property.fromJson(json['property'] as Map<String, dynamic>),
      dateTime: DateTime.parse(json['dateTime'] as String),
      status: json['status'] as String? ?? 'scheduled',
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'property': property.toJson(),
      'dateTime': dateTime.toIso8601String(),
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isUpcoming => dateTime.isAfter(DateTime.now()) && status == 'scheduled';
  bool get isPast => dateTime.isBefore(DateTime.now()) || status == 'completed';
  bool get isCancelled => status == 'cancelled';

  @override
  List<Object?> get props => [id, userId, property, dateTime, status, notes, createdAt];
}
```

---

### lib/features/calculators/models/mortgage_calculation.dart

```dart
import 'dart:math';
import 'package:equatable/equatable.dart';

class MortgageCalculation extends Equatable {
  final double homePrice;
  final double downPayment;
  final double interestRate;
  final int amortizationYears;
  final String paymentFrequency; // 'monthly', 'bi-weekly', 'weekly'

  const MortgageCalculation({
    required this.homePrice,
    required this.downPayment,
    required this.interestRate,
    required this.amortizationYears,
    this.paymentFrequency = 'monthly',
  });

  // Calculated values
  double get loanAmount => homePrice - downPayment;
  double get downPaymentPercentage => (downPayment / homePrice) * 100;

  double get monthlyPayment => _calculatePayment(12);
  double get biWeeklyPayment => _calculatePayment(26);
  double get weeklyPayment => _calculatePayment(52);

  double get totalInterest {
    final totalPaid = monthlyPayment * amortizationYears * 12;
    return totalPaid - loanAmount;
  }

  double get totalCost => homePrice + totalInterest;

  double _calculatePayment(int paymentsPerYear) {
    final principal = loanAmount;
    final annualRate = interestRate / 100;
    final periodicRate = annualRate / paymentsPerYear;
    final numberOfPayments = amortizationYears * paymentsPerYear;

    if (periodicRate == 0) {
      return principal / numberOfPayments;
    }

    return principal *
        (periodicRate * pow(1 + periodicRate, numberOfPayments)) /
        (pow(1 + periodicRate, numberOfPayments) - 1);
  }

  MortgageCalculation copyWith({
    double? homePrice,
    double? downPayment,
    double? interestRate,
    int? amortizationYears,
    String? paymentFrequency,
  }) {
    return MortgageCalculation(
      homePrice: homePrice ?? this.homePrice,
      downPayment: downPayment ?? this.downPayment,
      interestRate: interestRate ?? this.interestRate,
      amortizationYears: amortizationYears ?? this.amortizationYears,
      paymentFrequency: paymentFrequency ?? this.paymentFrequency,
    );
  }

  @override
  List<Object?> get props => [
        homePrice,
        downPayment,
        interestRate,
        amortizationYears,
        paymentFrequency,
      ];
}

class IncentiveCalculation extends Equatable {
  final double homePrice;
  final bool isFirstTimeHomeBuyer;
  final bool isNewHome;
  final double householdIncome;

  const IncentiveCalculation({
    required this.homePrice,
    required this.isFirstTimeHomeBuyer,
    required this.isNewHome,
    required this.householdIncome,
  });

  // BC First-Time Home Buyers Tax Credit (simplified)
  double get firstTimeBuyerCredit {
    if (!isFirstTimeHomeBuyer) return 0;
    return 8000; // Federal credit
  }

  // BC Property Transfer Tax Exemption
  double get pttExemption {
    if (!isFirstTimeHomeBuyer) return 0;
    if (homePrice > 500000) return 0;
    return homePrice * 0.01; // Simplified calculation
  }

  // GST/HST Rebate (for new homes)
  double get gstRebate {
    if (!isNewHome) return 0;
    if (homePrice > 450000) return 0;
    final gst = homePrice * 0.05;
    return gst * 0.36; // 36% rebate
  }

  // RRSP Home Buyers' Plan
  double get rrspWithdrawalLimit {
    if (!isFirstTimeHomeBuyer) return 0;
    return 35000; // Per person, so 70000 for couples
  }

  double get totalIncentives {
    return firstTimeBuyerCredit + pttExemption + gstRebate;
  }

  double get effectiveHomePrice {
    return homePrice - totalIncentives;
  }

  IncentiveCalculation copyWith({
    double? homePrice,
    bool? isFirstTimeHomeBuyer,
    bool? isNewHome,
    double? householdIncome,
  }) {
    return IncentiveCalculation(
      homePrice: homePrice ?? this.homePrice,
      isFirstTimeHomeBuyer: isFirstTimeHomeBuyer ?? this.isFirstTimeHomeBuyer,
      isNewHome: isNewHome ?? this.isNewHome,
      householdIncome: householdIncome ?? this.householdIncome,
    );
  }

  @override
  List<Object?> get props => [
        homePrice,
        isFirstTimeHomeBuyer,
        isNewHome,
        householdIncome,
      ];
}
```

---

## SERVICES

### lib/features/auth/services/auth_service.dart

```dart
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../shared/models/api_response.dart';
import '../models/user_model.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient.instance;
  final SecureStorageService _storage = SecureStorageService.instance;

  /// Send OTP to phone number
  Future<Result<void>> sendOtp(String phoneNumber) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.sendOtp,
        data: {'phoneNumber': phoneNumber},
      );

      if (response.statusCode == 200) {
        return Result.success(null);
      } else {
        final error = response.data?['error'] ?? 'Failed to send OTP';
        return Result.failure(error);
      }
    } on ApiException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('An unexpected error occurred');
    }
  }

  /// Verify OTP and login
  Future<Result<User>> verifyOtp(String phoneNumber, String code) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.verifyOtp,
        data: {
          'phoneNumber': phoneNumber,
          'code': code,
          'loginType': 'client', // Always client for mobile app
        },
      );

      if (response.statusCode == 200) {
        final userData = response.data['user'];
        final user = User.fromJson(userData);

        // Save auth data
        await _storage.saveUserId(user.id);
        await _storage.saveUserPhone(user.phoneNumber);
        await _storage.saveUserRole(user.role);
        await _storage.saveAuthStatus(true);

        return Result.success(user);
      } else {
        final error = response.data?['error'] ?? 'Invalid verification code';
        return Result.failure(error);
      }
    } on ApiException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('An unexpected error occurred');
    }
  }

  /// Check authentication status
  Future<Result<User?>> checkAuthStatus() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.authStatus);

      if (response.statusCode == 200 && response.data['authenticated'] == true) {
        final userData = response.data['user'];
        final user = User.fromJson(userData);
        return Result.success(user);
      } else {
        // Not authenticated
        await _clearAuthData();
        return Result.success(null);
      }
    } on ApiException catch (e) {
      await _clearAuthData();
      return Result.failure(e.message);
    } catch (e) {
      return Result.success(null);
    }
  }

  /// Logout
  Future<Result<void>> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
      await _clearAuthData();
      return Result.success(null);
    } on ApiException catch (e) {
      // Clear local data even if API call fails
      await _clearAuthData();
      return Result.failure(e.message);
    } catch (e) {
      await _clearAuthData();
      return Result.failure('An unexpected error occurred');
    }
  }

  /// Clear all authentication data
  Future<void> _clearAuthData() async {
    await _storage.clearAuthData();
    await _apiClient.clearCookies();
  }

  /// Check if user is authenticated locally
  Future<bool> isAuthenticated() async {
    return await _storage.getAuthStatus();
  }

  /// Get stored user ID
  Future<String?> getUserId() async {
    return await _storage.getUserId();
  }
}
```

Continue in next message due to length...
