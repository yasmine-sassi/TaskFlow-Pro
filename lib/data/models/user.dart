// user_model.dart

class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? avatar;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.avatar,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  // Full name getter
  String get fullName =>
      '$firstName ${lastName.isNotEmpty ? lastName : ''}'.trim();

  // Status getter (active if updated within last 30 days)
  String get status {
    final daysSinceUpdate = DateTime.now().difference(updatedAt).inDays;
    return daysSinceUpdate <= 30 ? 'active' : 'inactive';
  }

  // Last active date formatted (YYYY-MM-DD)
  String get lastActive {
    return '${updatedAt.year}-${updatedAt.month.toString().padLeft(2, '0')}-${updatedAt.day.toString().padLeft(2, '0')}';
  }

  // Get avatar initial
  String get initial => firstName.isNotEmpty ? firstName[0].toUpperCase() : 'U';

  // Check if user is admin
  bool get isAdmin => role.toUpperCase() == 'ADMIN';

  // From JSON factory constructor
  factory User.fromJson(Map<String, dynamic> json) {
    // Handle nested data structure from backend
    final Map<String, dynamic> data = json.containsKey('data')
        ? (json['data'] as Map<String, dynamic>)
        : json;
    final Map<String, dynamic> userData =
        data.containsKey('user') ? data['user'] as Map<String, dynamic> : data;

    return User(
      id: (userData['id'] ?? userData['userId'] ?? '') as String,
      email: (userData['email'] ?? '') as String,
      firstName: userData['firstName'] as String? ?? '',
      lastName: userData['lastName'] as String? ?? '',
      avatar: userData['avatar'] as String?,
      role: (userData['role'] ?? '') as String,
      createdAt: userData['createdAt'] != null
          ? DateTime.parse(userData['createdAt'] as String)
          : DateTime.now(),
      updatedAt: userData['updatedAt'] != null
          ? DateTime.parse(userData['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'avatar': avatar,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Copy with method for immutable updates
  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? avatar,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // From JSON list
  static List<User> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => User.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // To JSON list
  static List<Map<String, dynamic>> toJsonList(List<User> users) {
    return users.map((user) => user.toJson()).toList();
  }

  // ToString for debugging
  @override
  String toString() {
    return 'User(id: $id, email: $email, fullName: $fullName, role: $role)';
  }

  // Equality override
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
