import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Example registrations
  // sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  // sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  // sl.registerLazySingleton<DioClient>(() => DioClient());
}
