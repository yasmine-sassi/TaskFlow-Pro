import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/errors/exceptions.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });

  Future<UserModel> currentUser({required String token});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      return _parseAuthResponse(response.data);
    } on DioException catch (e) {
      throw ServerException(_extractMessage(e));
    }
  }

  @override
  Future<AuthResponseModel> register({
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
      return _parseAuthResponse(response.data);
    } on DioException catch (e) {
      throw ServerException(_extractMessage(e));
    }
  }

  @override
  Future<UserModel> currentUser({required String token}) async {
    try {
      final response = await dio.get(
        ApiEndpoints.me,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = _unwrapData(response.data);
      final userJson = data['user'] as Map<String, dynamic>;
      return UserModel.fromJson(userJson);
    } on DioException catch (e) {
      throw ServerException(_extractMessage(e));
    }
  }

  AuthResponseModel _parseAuthResponse(dynamic raw) {
    final data = _unwrapData(raw);
    return AuthResponseModel.fromJson(data);
  }

  Map<String, dynamic> _unwrapData(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      if (raw['data'] is Map<String, dynamic>) {
        return raw['data'] as Map<String, dynamic>;
      }
      return raw;
    }
    throw ServerException('Unexpected response shape');
  }

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
