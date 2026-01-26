// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
      priority: json['priority'] as String,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      position: (json['position'] as num).toInt(),
      projectId: json['projectId'] as String,
      ownerId: json['ownerId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      assignees: (json['assignees'] as List<dynamic>?)
          ?.map((e) => AssigneeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      labels: (json['labels'] as List<dynamic>?)
          ?.map((e) => LabelModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'status': instance.status,
      'priority': instance.priority,
      'dueDate': instance.dueDate?.toIso8601String(),
      'position': instance.position,
      'projectId': instance.projectId,
      'ownerId': instance.ownerId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'assignees': instance.assignees,
      'labels': instance.labels,
    };

AssigneeModel _$AssigneeModelFromJson(Map<String, dynamic> json) =>
    AssigneeModel(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );

Map<String, dynamic> _$AssigneeModelToJson(AssigneeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };

LabelModel _$LabelModelFromJson(Map<String, dynamic> json) => LabelModel(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String,
    );

Map<String, dynamic> _$LabelModelToJson(LabelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
    };
