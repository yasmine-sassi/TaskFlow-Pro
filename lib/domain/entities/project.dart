class ProjectMember {
  final String id;
  final String projectId;
  final String userId;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProjectMember({
    required this.id,
    required this.projectId,
    required this.userId,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });
}

class Project {
  final String id;
  final String name;
  final String? description;
  final String? color;
  final bool isArchived;
  final String ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProjectMember>? members;

  Project({
    required this.id,
    required this.name,
    this.description,
    this.color,
    required this.isArchived,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    this.members,
  });
}
