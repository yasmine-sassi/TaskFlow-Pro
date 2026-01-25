import 'package:json_annotation/json_annotation.dart';

part 'project_model.g.dart';

@JsonSerializable()
class ProjectMemberModel {
  final String id;
  final String projectId;
  final String userId;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProjectMemberModel({
    required this.id,
    required this.projectId,
    required this.userId,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProjectMemberModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectMemberModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectMemberModelToJson(this);
}

@JsonSerializable()
class ProjectModel {
  final String id;
  final String name;
  final String? description;
  final String? color;
  final bool isArchived;
  final String ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  @JsonKey(defaultValue: [])
  final List<ProjectMemberModel>? members;

  ProjectModel({
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

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectModelToJson(this);
}
