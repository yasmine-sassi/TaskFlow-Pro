class Task {
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
  final List<String>? assigneeIds;
  final List<String>? labelIds;

  Task({
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
    this.assigneeIds,
    this.labelIds,
  });
}
