import 'package:flutter_riverpod/flutter_riverpod.dart';

/// User model
class User {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final String role;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.role = 'user',
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? avatar,
    String? role,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
    );
  }
}

/// User notifier
class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  void setUser(User user) {
    state = user;
  }

  void updateUser({String? name, String? email, String? avatar}) {
    if (state != null) {
      state = state!.copyWith(
        name: name,
        email: email,
        avatar: avatar,
      );
      // TODO: Persist to backend API
    }
  }

  void clearUser() {
    state = null;
  }

  Future<void> loadUser() async {
    // TODO: Load user from backend API
    // For now, setting a mock user
    state = const User(
      id: 1,
      name: 'John Doe',
      email: 'john.doe@example.com',
      role: 'admin',
    );
  }

  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    // TODO: Call backend API to update profile
    updateUser(name: name, email: email);
  }
}

/// User provider
final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  final notifier = UserNotifier();
  // Load user on initialization
  notifier.loadUser();
  return notifier;
});
