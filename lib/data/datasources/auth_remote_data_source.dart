import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> login({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    return User.fromJson(response.data as Map<String, dynamic>);
  }
}
