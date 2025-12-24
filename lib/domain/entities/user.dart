class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String? avatar;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.avatar,
  });

  String get fullName => '$firstName $lastName';
}
