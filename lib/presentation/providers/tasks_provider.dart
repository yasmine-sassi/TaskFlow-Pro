import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_providers.dart';
import '../../data/datasources/tasks_remote_data_source.dart';
import '../../data/repositories/tasks_repository.dart';
import '../../domain/entities/task.dart';

final tasksRepositoryProvider = Provider<TasksRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final remoteDataSource = TasksRemoteDataSourceImpl(dioClient.dio);
  return TasksRepositoryImpl(remoteDataSource);
});

final tasksProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(tasksRepositoryProvider);
  return repository.getMyTasks();
});

final taskProvider = FutureProvider.family<Task, String>((ref, id) async {
  final repository = ref.watch(tasksRepositoryProvider);
  return repository.getTaskById(id);
});
