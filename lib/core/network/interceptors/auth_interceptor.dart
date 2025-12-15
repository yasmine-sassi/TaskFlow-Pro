import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  // TODO: inject token provider
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Example: add auth token if available
    // final token = await tokenProvider.getToken();
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    super.onRequest(options, handler);
  }
}
