import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/user.dart';
import '../../core/network/dio_client.dart';
import '../../data/datasources/user_remote_data_source.dart';

final dioProvider = Provider((ref) => DioClient().dio);

final userRemoteDataSourceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return UserRemoteDataSourceImpl(dio);
});

final userProvider = FutureProvider<User?>((ref) async {
  try {
    final dataSource = ref.watch(userRemoteDataSourceProvider);
    final userModel = await dataSource.getCurrentUser();
    print('User Provider - User loaded: ${userModel.name}');
    return userModel.toEntity();
  } on DioException catch (e) {
    // Gracefully handle missing/expired token without crashing the UI
    if (e.response?.statusCode == 401) {
      print('User Provider - Unauthorized (401). Returning null user.');
      return null;
    }
    print('User Provider - Dio error: $e');
    return null;
  } catch (e) {
    print('User Provider - Error fetching user: $e');
    return null;
  }
});
