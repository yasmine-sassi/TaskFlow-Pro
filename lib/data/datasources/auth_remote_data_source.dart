import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}
