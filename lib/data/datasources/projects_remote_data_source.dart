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
      final response = await dio.get(ApiEndpoints.projects);
      // Backend wraps response in { statusCode, message, data }
      final responseData = response.data;
      final List<dynamic> data = responseData['data'] as List<dynamic>;
      return data
          .map((item) => ProjectModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProjectModel> getProjectById(String id) async {
    try {
      final response = await dio.get('${ApiEndpoints.projects}/$id');
      // Backend wraps response in { statusCode, message, data }
      final responseData = response.data;
      return ProjectModel.fromJson(
          responseData['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
}
