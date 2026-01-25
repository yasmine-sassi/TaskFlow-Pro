import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';
import '../../data/datasources/projects_remote_data_source.dart';
import '../../data/repositories/projects_repository.dart';
import '../../domain/entities/project.dart';

final projectsRepositoryProvider = Provider<ProjectsRepository>((ref) {
  final dioClient = DioClient();
  final remoteDataSource = ProjectsRemoteDataSourceImpl(dioClient.dio);
  return ProjectsRepositoryImpl(remoteDataSource);
});

final projectsProvider = FutureProvider<List<Project>>((ref) async {
  final repository = ref.watch(projectsRepositoryProvider);
  return repository.getAllProjects();
});

final projectProvider = FutureProvider.family<Project, String>((ref, id) async {
  final repository = ref.watch(projectsRepositoryProvider);
  return repository.getProjectById(id);
});
