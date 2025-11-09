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
