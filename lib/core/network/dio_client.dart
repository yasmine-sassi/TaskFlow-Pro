import 'package:dio/dio.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import '../constants/api_endpoints.dart';

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
      AuthInterceptor(tokenProvider ?? () async => null),
      ErrorInterceptor(),
      LoggingInterceptor(),
      RetryInterceptor(dio: dio),
    ]);
  }
}
