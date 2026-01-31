import 'package:dio/dio.dart';
import '../../presentation/providers/user_provider.dart';

/// User service for consuming NestJS backend APIs
class UserService {
  final Dio _dio;

  UserService(this._dio);

  /// Fetch user profile
  Future<User> getProfile() async {
    try {
      final response = await _dio.get('/users/profile');

      return User(
        id: response.data['id'],
        firstName: response.data['firstName'],
        lastName: response.data['lastName'],
        email: response.data['email'],
        avatar: response.data['avatar'],
        role: response.data['role'] ?? 'user',
      );
    } catch (e) {
      throw Exception('Failed to load user profile: $e');
    }
  }

  /// Update user profile
  Future<User> updateProfile({
    required int userId,
    required String firstName,
    required String lastName,
    required String email,
    String? avatar,
  }) async {
    try {
      final response = await _dio.patch(
        '/users/$userId',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          if (avatar != null) 'avatar': avatar,
        },
      );

      return User(
        id: response.data['id'],
        firstName: response.data['firstName'],
        lastName: response.data['lastName'],
        email: response.data['email'],
        avatar: response.data['avatar'],
        role: response.data['role'] ?? 'user',
      );
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Update password
  Future<void> updatePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.patch(
        '/users/$userId/password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }

  /// Upload avatar
  Future<String> uploadAvatar({
    required int userId,
    required String filePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post(
        '/users/$userId/avatar',
        data: formData,
      );

      return response.data['avatarUrl'];
    } catch (e) {
      throw Exception('Failed to upload avatar: $e');
    }
  }
}
