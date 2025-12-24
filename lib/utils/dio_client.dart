import 'package:dio/dio.dart';
import 'auth_interceptor.dart';
import 'api_endpoints.dart';

class DioClient {
  late final Dio dio;

  DioClient({String? baseUrl, Future<String?> Function()? tokenProvider}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(tokenProvider: tokenProvider ?? () async => null),
    ]);
  }
}
