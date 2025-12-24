import 'package:get_it/get_it.dart';
import 'package:taskflow_pro/core/network/dio_client.dart';
import 'package:taskflow_pro/data/datasources/auth_remote_data_source.dart';
import 'package:taskflow_pro/data/repositories/auth_repository_impl.dart';
import 'package:taskflow_pro/domain/repositories/auth_repository.dart';

final sl = GetIt.instance;

class TokenStore {
  String? _token;
  Future<String?> getToken() async => _token;
  void setToken(String? token) => _token = token;
}

Future<void> initDependencies({String? baseUrl}) async {
  // Token store
  sl.registerLazySingleton<TokenStore>(() => TokenStore());

  // Core HTTP client (optionally override baseUrl)
  sl.registerLazySingleton<DioClient>(
    () => DioClient(baseUrl: baseUrl, tokenProvider: sl<TokenStore>().getToken),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<DioClient>().dio),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );
}

/// Update Authorization header globally for the current Dio client.
void setAccessToken(String? token) {
  sl<TokenStore>().setToken(token);
}

// This is the dependency injection (DI) service locator file.
// It uses get_it to register and manage singleton instances of services throughout the app.
