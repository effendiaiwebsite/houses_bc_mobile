import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../../../shared/models/api_response.dart';

// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Loading State Enum
enum LoadingState { initial, loading, success, error }

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
