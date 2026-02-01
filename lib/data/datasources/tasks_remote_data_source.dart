import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/task_model.dart';

abstract class TasksRemoteDataSource {
  Future<List<TaskModel>> getMyTasks();
  Future<TaskModel> getTaskById(String id);
}

class TasksRemoteDataSourceImpl implements TasksRemoteDataSource {
  final Dio dio;
  TasksRemoteDataSourceImpl(this.dio);

  @override
  Future<List<TaskModel>> getMyTasks() async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.tasks}/my-tasks',
      );
      // Backend wraps response in { statusCode, message, data }
      final responseData = response.data;
      final List<dynamic> data = responseData['data'] as List<dynamic>;
      return data
          .map((item) => TaskModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TaskModel> getTaskById(String id) async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.tasks}/$id',
      );
      // Backend wraps response in { statusCode, message, data }
      final responseData = response.data;
      return TaskModel.fromJson(responseData['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
}
