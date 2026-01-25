import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

@JsonSerializable()
class TaskModel {
  final String id;
  final String title;
  final String? description;
  final String status;
  final String priority;
  final DateTime? dueDate;
  final int position;
  final String projectId;
  final String ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  @JsonKey(name: 'assignees')
  final List<AssigneeModel>? assignees;
  @JsonKey(name: 'labels')
  final List<LabelModel>? labels;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    required this.position,
    required this.projectId,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    this.assignees,
    this.labels,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
  Map<String, dynamic> toJson() => _$TaskModelToJson(this);
}

@JsonSerializable()
class AssigneeModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;

  AssigneeModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory AssigneeModel.fromJson(Map<String, dynamic> json) =>
      _$AssigneeModelFromJson(json);
  Map<String, dynamic> toJson() => _$AssigneeModelToJson(this);
}

@JsonSerializable()
class LabelModel {
  final String id;
  final String name;
  final String color;

  LabelModel({
    required this.id,
    required this.name,
    required this.color,
  });

  factory LabelModel.fromJson(Map<String, dynamic> json) =>
      _$LabelModelFromJson(json);
  Map<String, dynamic> toJson() => _$LabelModelToJson(this);
}
