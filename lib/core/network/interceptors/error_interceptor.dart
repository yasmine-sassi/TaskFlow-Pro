import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401/403 etc.
    // Map DioException to domain failures if needed
    super.onError(err, handler);
  }
}
