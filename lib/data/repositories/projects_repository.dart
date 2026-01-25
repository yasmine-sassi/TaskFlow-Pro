import '../datasources/projects_remote_data_source.dart';
import '../../domain/entities/project.dart';

abstract class ProjectsRepository {
  Future<List<Project>> getAllProjects();
  Future<Project> getProjectById(String id);
}

class ProjectsRepositoryImpl implements ProjectsRepository {
  final ProjectsRemoteDataSource remoteDataSource;

  ProjectsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Project>> getAllProjects() async {
    final models = await remoteDataSource.getAllProjects();
    return models
        .map((model) => Project(
              id: model.id,
              name: model.name,
              description: model.description,
              color: model.color,
              isArchived: model.isArchived,
              ownerId: model.ownerId,
              createdAt: model.createdAt,
              updatedAt: model.updatedAt,
              members: model.members
                  ?.map((m) => ProjectMember(
                        id: m.id,
                        projectId: m.projectId,
                        userId: m.userId,
                        role: m.role,
                        createdAt: m.createdAt,
                        updatedAt: m.updatedAt,
                      ))
                  .toList(),
            ))
        .toList();
  }

  @override
  Future<Project> getProjectById(String id) async {
    final model = await remoteDataSource.getProjectById(id);
    return Project(
      id: model.id,
      name: model.name,
      description: model.description,
      color: model.color,
      isArchived: model.isArchived,
      ownerId: model.ownerId,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      members: model.members
          ?.map((m) => ProjectMember(
                id: m.id,
                projectId: m.projectId,
                userId: m.userId,
                role: m.role,
                createdAt: m.createdAt,
                updatedAt: m.updatedAt,
              ))
          .toList(),
    );
  }
}
