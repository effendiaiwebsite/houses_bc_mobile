import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

/// Secure Storage Service
///
/// Handles both secure storage (for sensitive data like tokens)
/// and shared preferences (for non-sensitive data like settings)
class SecureStorageService {
  static SecureStorageService? _instance;
  late FlutterSecureStorage _secureStorage;
  SharedPreferences? _prefs;

  SecureStorageService._internal() {
    _secureStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
  }

  static SecureStorageService get instance {
    _instance ??= SecureStorageService._internal();
    return _instance!;
  }

  /// Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ========== Secure Storage (FlutterSecureStorage) ==========

  /// Save data to secure storage
  Future<void> saveSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  /// Read data from secure storage
  Future<String?> readSecure(String key) async {
    return await _secureStorage.read(key: key);
  }

  /// Delete data from secure storage
  Future<void> deleteSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  /// Clear all secure storage
  Future<void> clearSecure() async {
    await _secureStorage.deleteAll();
  }

  // ========== Authentication Data ==========

  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await saveSecure(AppConfig.keyUserId, userId);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await readSecure(AppConfig.keyUserId);
  }

  /// Save user phone
  Future<void> saveUserPhone(String phone) async {
    await saveSecure(AppConfig.keyUserPhone, phone);
  }

  /// Get user phone
  Future<String?> getUserPhone() async {
    return await readSecure(AppConfig.keyUserPhone);
  }

  /// Save user role
  Future<void> saveUserRole(String role) async {
    await saveSecure(AppConfig.keyUserRole, role);
  }

  /// Get user role
  Future<String?> getUserRole() async {
    return await readSecure(AppConfig.keyUserRole);
  }

  /// Save authentication status
  Future<void> saveAuthStatus(bool isAuthenticated) async {
    await saveSecure(
      AppConfig.keyIsAuthenticated,
      isAuthenticated.toString(),
    );
  }

  /// Get authentication status
  Future<bool> getAuthStatus() async {
    final value = await readSecure(AppConfig.keyIsAuthenticated);
    return value == 'true';
  }

  /// Clear all authentication data
  Future<void> clearAuthData() async {
    await deleteSecure(AppConfig.keyUserId);
    await deleteSecure(AppConfig.keyUserPhone);
    await deleteSecure(AppConfig.keyUserRole);
    await deleteSecure(AppConfig.keyIsAuthenticated);
  }

  // ========== Shared Preferences (non-sensitive data) ==========

  /// Save string to preferences
  Future<bool> saveString(String key, String value) async {
    if (_prefs == null) await init();
    return await _prefs!.setString(key, value);
  }

  /// Get string from preferences
  String? getString(String key) {
    return _prefs?.getString(key);
  }

  /// Save boolean to preferences
  Future<bool> saveBool(String key, bool value) async {
    if (_prefs == null) await init();
    return await _prefs!.setBool(key, value);
  }

  /// Get boolean from preferences
  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  /// Save int to preferences
  Future<bool> saveInt(String key, int value) async {
    if (_prefs == null) await init();
    return await _prefs!.setInt(key, value);
  }

  /// Get int from preferences
  int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  /// Save list of strings to preferences
  Future<bool> saveStringList(String key, List<String> value) async {
    if (_prefs == null) await init();
    return await _prefs!.setStringList(key, value);
  }

  /// Get list of strings from preferences
  List<String>? getStringList(String key) {
    return _prefs?.getStringList(key);
  }

  /// Remove key from preferences
  Future<bool> remove(String key) async {
    if (_prefs == null) await init();
    return await _prefs!.remove(key);
  }

  /// Clear all preferences
  Future<bool> clearPreferences() async {
    if (_prefs == null) await init();
    return await _prefs!.clear();
  }

  // ========== Convenience Methods ==========

  /// Check if onboarding is complete
  bool isOnboardingComplete() {
    return getBool(AppConfig.keyOnboardingComplete) ?? false;
  }

  /// Mark onboarding as complete
  Future<void> setOnboardingComplete() async {
    await saveBool(AppConfig.keyOnboardingComplete, true);
  }

  /// Get recent searches
  List<String> getRecentSearches() {
    return getStringList(AppConfig.keyRecentSearches) ?? [];
  }

  /// Add to recent searches
  Future<void> addRecentSearch(String search) async {
    final searches = getRecentSearches();
    searches.remove(search); // Remove if exists
    searches.insert(0, search); // Add to beginning

    // Keep only the last N searches
    if (searches.length > AppConfig.maxRecentSearches) {
      searches.removeRange(
        AppConfig.maxRecentSearches,
        searches.length,
      );
    }

    await saveStringList(AppConfig.keyRecentSearches, searches);
  }

  /// Clear recent searches
  Future<void> clearRecentSearches() async {
    await remove(AppConfig.keyRecentSearches);
  }
}
