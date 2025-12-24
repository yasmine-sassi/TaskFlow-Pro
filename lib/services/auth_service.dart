import 'package:dio/dio.dart';
import '../utils/api_endpoints.dart';
import '../utils/token_store.dart';
import '../models/auth_models.dart';

/// Unified auth service wrapping Dio calls and error handling.
class AuthService {
  final Dio dio;
  final TokenStore tokenStore;

  AuthService({required this.dio, required this.tokenStore});

  /// Login with email and password.
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      final session = AuthSession.fromJson(_unwrapData(response.data));
      tokenStore.setToken(session.accessToken);
      return session;
    } on DioException catch (e) {
      throw AuthException(_extractMessage(e));
    }
  }

  /// Register a new user.
  Future<AuthSession> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
        },
      );
      final session = AuthSession.fromJson(_unwrapData(response.data));
      tokenStore.setToken(session.accessToken);
      return session;
    } on DioException catch (e) {
      throw AuthException(_extractMessage(e));
    }
  }

  /// Get current user profile.
  Future<User> me() async {
    try {
      final response = await dio.get(ApiEndpoints.me);
      final data = _unwrapData(response.data);
      return User.fromJson(data['user'] as Map<String, dynamic>? ?? {});
    } on DioException catch (e) {
      throw AuthException(_extractMessage(e));
    }
  }

  /// Clear the token (client-side logout only).
  Future<void> logout() async {
    tokenStore.setToken(null);
  }

  /// Unwraps { data: {...} } if present, else returns as-is.
  Map<String, dynamic> _unwrapData(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      if (raw['data'] is Map<String, dynamic>) {
        return raw['data'] as Map<String, dynamic>;
      }
      return raw;
    }
    throw AuthException('Unexpected response shape');
  }

  /// Extracts error message from DioException.
  String _extractMessage(DioException e) {
    final responseData = e.response?.data;
    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'];
      if (message is List) {
        return message.join(', ');
      }
      if (message != null) {
        return message.toString();
      }
    }
    return e.message ?? 'Network error';
  }
}

/// Simple exception for auth errors.
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}
