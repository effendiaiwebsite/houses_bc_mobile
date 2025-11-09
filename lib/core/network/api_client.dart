import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../config/app_config.dart';

// Conditional imports - use stub on web, real implementation on mobile
import 'api_client_stub.dart'
    if (dart.library.io) 'api_client_mobile.dart';

/// API Client
///
/// Centralized HTTP client with cookie management for session persistence
class ApiClient {
  static ApiClient? _instance;
  late Dio _dio;
  CookieJar? _cookieJar;

  ApiClient._internal() {
    final baseUrl = AppConfig.baseUrl;
    print('[API Client] Initializing with base URL: $baseUrl');

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: AppConfig.connectionTimeout,
        sendTimeout: AppConfig.sendTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) {
          // Accept all status codes to handle errors manually
          return status != null && status < 500;
        },
      ),
    );

    // Add logging interceptor
    if (AppConfig.enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: _printLog,
      ));
    }

    // Initialize cookie jar for session persistence (not on web)
    if (!kIsWeb) {
      _initCookieJar();
    }
  }

  Future<void> _initCookieJar() async {
    // Skip on web - browser handles cookies automatically
    if (kIsWeb) return;

    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final appDocPath = appDocDir.path;
      _cookieJar = PersistCookieJar(
        storage: FileStorage('$appDocPath/.cookies/'),
      );
      _dio.interceptors.add(CookieManager(_cookieJar!));
    } catch (e) {
      // Fallback to memory-only cookie jar
      _cookieJar = CookieJar();
      _dio.interceptors.add(CookieManager(_cookieJar!));
    }
  }

  static ApiClient get instance {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;

  void _printLog(Object object) {
    if (AppConfig.enableLogging) {
      print('[API] $object');
    }
  }

  /// Clear all cookies (useful for logout)
  Future<void> clearCookies() async {
    if (!kIsWeb && _cookieJar != null) {
      await _cookieJar!.deleteAll();
    }
  }

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors and convert to meaningful exceptions
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          'Connection timeout. Please check your internet connection.',
          error.response?.statusCode,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['error'] ??
            error.response?.data?['message'] ??
            'An error occurred';
        return ApiException(message, statusCode);

      case DioExceptionType.cancel:
        return ApiException('Request was cancelled', null);

      case DioExceptionType.connectionError:
        return ApiException(
          'No internet connection. Please check your network.',
          null,
        );

      case DioExceptionType.unknown:
      default:
        return ApiException(
          'An unexpected error occurred. Please try again.',
          null,
        );
    }
  }
}

/// Custom API Exception
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode != null && statusCode! >= 500;
}
