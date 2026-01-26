import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/network/api_client.dart';
import '../../data/models/user.dart' as user_model;

/// User model for settings page
class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? avatar;
  final String role;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.avatar,
    this.role = 'user',
  });

  String get name => '$firstName ${lastName.isNotEmpty ? lastName : ''}'.trim();

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? avatar,
    String? role,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
    );
  }

  factory User.fromBackendUser(user_model.User backendUser) {
    return User(
      id: backendUser.id,
      firstName: backendUser.firstName,
      lastName: backendUser.lastName,
      email: backendUser.email,
      avatar: backendUser.avatar,
      role: backendUser.role,
    );
  }
}

/// User notifier
class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  void setUser(User user) {
    state = user;
  }

  void updateUser(
      {String? firstName, String? lastName, String? email, String? avatar}) {
    if (state != null) {
      state = state!.copyWith(
        firstName: firstName,
        lastName: lastName,
        email: email,
        avatar: avatar,
      );
    }
  }

  void clearUser() {
    state = null;
  }

  Future<void> loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('user_data');

      if (userDataString != null) {
        final userData = json.decode(userDataString);
        final backendUser = user_model.User.fromJson(userData);
        state = User.fromBackendUser(backendUser);
      } else {
        // Try to fetch from backend
        await loadUserFromBackend();
      }
    } catch (e) {
      print('Error loading user: $e');
    }
  }

  Future<void> loadUserFromBackend() async {
    try {
      final client = AuthApiClientFactory.instance;
      if (client != null) {
        final backendUser = await client.getProfile();
        state = User.fromBackendUser(backendUser);

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', json.encode(backendUser.toJson()));
      }
    } catch (e) {
      print('Error loading user from backend: $e');
    }
  }

  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? avatar,
  }) async {
    try {
      final client = AuthApiClientFactory.instance;
      if (client == null) {
        print('ERROR: API client not initialized');
        throw Exception('API client not initialized');
      }

      print('Creating UpdateProfileDto with:');
      print('  firstName: $firstName');
      print('  lastName: $lastName');
      print('  avatar length: ${avatar?.length}');

      final dto = UpdateProfileDto(
        firstName: firstName,
        lastName: lastName,
        avatar: avatar,
      );

      print('Calling client.updateProfile...');
      final updatedUser = await client.updateProfile(dto);
      print('Profile updated successfully: ${updatedUser.toJson()}');

      state = User.fromBackendUser(updatedUser);

      // Update SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', json.encode(updatedUser.toJson()));
      print('User data saved to SharedPreferences');

      return true;
    } catch (e, stackTrace) {
      print('ERROR updating profile: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final client = AuthApiClientFactory.instance;
      if (client == null) {
        throw Exception('API client not initialized');
      }

      final dto = ChangePasswordDto(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      await client.changePassword(dto);
      return true;
    } catch (e) {
      print('Error changing password: $e');
      rethrow;
    }
  }
}

/// User provider
final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  final notifier = UserNotifier();
  // Load user on initialization
  notifier.loadUser();
  return notifier;
});
