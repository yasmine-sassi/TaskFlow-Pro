import '../datasources/tasks_remote_data_source.dart';
import '../../domain/entities/task.dart';

abstract class TasksRepository {
  Future<List<Task>> getMyTasks();
  Future<Task> getTaskById(String id);
}

class TasksRepositoryImpl implements TasksRepository {
  final TasksRemoteDataSource remoteDataSource;

  TasksRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Task>> getMyTasks() async {
    final models = await remoteDataSource.getMyTasks();
    return models
        .map((model) => Task(
              id: model.id,
              title: model.title,
              description: model.description,
              status: model.status,
              priority: model.priority,
              dueDate: model.dueDate,
              position: model.position,
              projectId: model.projectId,
              ownerId: model.ownerId,
              createdAt: model.createdAt,
              updatedAt: model.updatedAt,
              assigneeIds: model.assignees?.map((a) => a.id).toList(),
              labelIds: model.labels?.map((l) => l.id).toList(),
            ))
        .toList();
  }

  @override
  Future<Task> getTaskById(String id) async {
    final model = await remoteDataSource.getTaskById(id);
    return Task(
      id: model.id,
      title: model.title,
      description: model.description,
      status: model.status,
      priority: model.priority,
      dueDate: model.dueDate,
      position: model.position,
      projectId: model.projectId,
      ownerId: model.ownerId,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      assigneeIds: model.assignees?.map((a) => a.id).toList(),
      labelIds: model.labels?.map((l) => l.id).toList(),
    );
  }
}
