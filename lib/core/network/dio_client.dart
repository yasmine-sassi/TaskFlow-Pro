import 'package:dio/dio.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import '../constants/api_endpoints.dart';

class DioClient {
  static DioClient? _instance;
  late final Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(),
      ErrorInterceptor(),
      LoggingInterceptor(),
      RetryInterceptor(dio: dio),
    ]);
  }

  factory DioClient() {
    _instance ??= DioClient._internal();
    return _instance!;
  }

  static void reset() {
    _instance = null;
  }
}
