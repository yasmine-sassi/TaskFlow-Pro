import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/models/user.dart';

part 'api_client.g.dart';

// ==================== Request DTOs ====================

class RegisterDto {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  RegisterDto({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      };
}

class LoginDto {
  final String email;
  final String password;

  LoginDto({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}
class UsersResponse {
  final int statusCode;
  final String message;
  final List<User> data;

  UsersResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) {
    return UsersResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((user) => User.fromJson(user as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data.map((user) => user.toJson()).toList(),
    };
  }
}

// ==================== Response Models ====================

class AuthResponse {
  final String accessToken;
  final User user;

  AuthResponse({
    required this.accessToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        accessToken: json['accessToken'],
        user: User.fromJson(json['user']),
      );
}



// ==================== API Client ====================

@RestApi()
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;

  /// Register a new user
  /// 
  /// Example:
  /// ```dart
  /// final response = await authClient.register(RegisterDto(
  ///   email: 'user@example.com',
  ///   password: 'Password123!',
  ///   firstName: 'John',
  ///   lastName: 'Doe',
  /// ));
  /// ```
  @POST('/auth/register')
  Future<AuthResponse> register(@Body() RegisterDto dto);

  /// Login with email and password
  /// 
  /// Example:
  /// ```dart
  /// final response = await authClient.login(LoginDto(
  ///   email: 'user@example.com',
  ///   password: 'Password123!',
  /// ));
  /// ```
  @POST('/auth/login')
  Future<AuthResponse> login(@Body() LoginDto dto);

  /// Logout current user
  /// 
  /// Requires authentication token
  @POST('/auth/logout')
  Future<void> logout();

  /// Get current authenticated user
  /// 
  /// Requires authentication token
  @GET('/auth/me')
  Future<User> getMe();

  /// Admin-only endpoint
  /// 
  /// Requires authentication token and admin role
  @GET('/auth/admin-only')
  Future<Map<String, dynamic>> adminOnly();

  @GET('/users')
  Future<UsersResponse> getusers();

  @DELETE('/users/{id}')
  Future<void> deleteUser(@Path('id') String id);
}

// ==================== API Client Factory ====================

class AuthApiClientFactory {
  // Singleton instance
  static AuthApiClient? _instance;
  static Dio? _dio;
  
  // Private constructor to prevent instantiation
  AuthApiClientFactory._();

  /// Get the current instance of AuthApiClient
  static AuthApiClient? get instance => _instance;

  /// Check if client is initialized
  static bool get isInitialized => _instance != null;

  /// Create and store a public (unauthenticated) API client
  static AuthApiClient createPublic({required String baseUrl}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add logging interceptor
    _dio!.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      logPrint: (obj) => print(obj),
    ));

    _instance = AuthApiClient(_dio!, baseUrl: baseUrl);
    return _instance!;
  }

  /// Create and store an authenticated API client
  static AuthApiClient createAuthenticated({
    required String baseUrl,
    required String accessToken,
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    ));

    // Add logging interceptor
    _dio!.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      logPrint: (obj) => print(obj),
    ));

    // Add error handling interceptor
    _dio!.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          print('Authentication error: Token may be invalid or expired');
        } else if (error.response?.statusCode == 403) {
          print('Forbidden: You do not have permission to access this resource');
        }
        handler.next(error);
      },
    ));

    _instance = AuthApiClient(_dio!, baseUrl: baseUrl);
    return _instance!;
  }

  /// Update the access token for the current instance
  static void updateAccessToken(String accessToken) {
    if (_dio != null) {
      _dio!.options.headers['Authorization'] = 'Bearer $accessToken';
      print('Access token updated');
    } else {
      print('Warning: No Dio instance found. Please create a client first.');
    }
  }

  /// Remove the access token (logout)
  static void removeAccessToken() {
    if (_dio != null) {
      _dio!.options.headers.remove('Authorization');
      print('Access token removed');
    }
  }

  /// Clear the singleton instance (for logout or reset)
  static void reset() {
    _instance = null;
    _dio?.close();
    _dio = null;
    print('AuthApiClient reset');
  }

  /// Get the current Dio instance (useful for custom requests)
  static Dio? get dio => _dio;
}

// Extension methods for easier usage
extension AuthApiClientFactoryExtension on AuthApiClient {
  /// Update token on existing instance
  void updateToken(String accessToken) {
    AuthApiClientFactory.updateAccessToken(accessToken);
  }

  /// Remove token from existing instance
  void removeToken() {
    AuthApiClientFactory.removeAccessToken();
  }
}

