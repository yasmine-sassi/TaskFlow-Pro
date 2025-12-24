import 'package:get_it/get_it.dart';
import 'package:taskflow_pro/utils/token_store.dart';
import 'package:taskflow_pro/utils/dio_client.dart';
import 'package:taskflow_pro/services/auth_service.dart';

final sl = GetIt.instance;

Future<void> initDependencies({String? baseUrl}) async {
  // Token store
  sl.registerLazySingleton<TokenStore>(() => TokenStore());

  // Core HTTP client (optionally override baseUrl)
  sl.registerLazySingleton<DioClient>(
    () => DioClient(baseUrl: baseUrl, tokenProvider: sl<TokenStore>().getToken),
  );

  // Auth service
  sl.registerLazySingleton<AuthService>(
    () => AuthService(dio: sl<DioClient>().dio, tokenStore: sl<TokenStore>()),
  );
}

/// Update token globally for the current Dio client.
void setAccessToken(String? token) {
  sl<TokenStore>().setToken(token);
}
