import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/project_model.dart';

abstract class ProjectsRemoteDataSource {
  Future<List<ProjectModel>> getAllProjects();
  Future<ProjectModel> getProjectById(String id);
}

class ProjectsRemoteDataSourceImpl implements ProjectsRemoteDataSource {
  final Dio dio;
  ProjectsRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProjectModel>> getAllProjects() async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.projects}',
      );
      print('Projects response: ${response.data}');

      // Backend wraps response in { statusCode, message, data }
      final responseData = response.data;
      final List<dynamic> data = responseData['data'] as List<dynamic>;

      return data.map((item) {
        try {
          final project = item as Map<String, dynamic>;
          // Remove members field if present as it's not in response
          project.remove('members');
          return ProjectModel.fromJson(project);
        } catch (e) {
          print('Error parsing project item: $e');
          print('Item: $item');
          rethrow;
        }
      }).toList();
    } catch (e) {
      print('Error in getAllProjects: $e');
      rethrow;
    }
  }

  @override
  Future<ProjectModel> getProjectById(String id) async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.projects}/$id',
      );
      // Backend wraps response in { statusCode, message, data }
      final responseData = response.data;
      return ProjectModel.fromJson(
          responseData['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
}
