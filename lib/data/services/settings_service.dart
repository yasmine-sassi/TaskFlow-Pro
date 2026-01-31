import 'package:dio/dio.dart';
import '../../presentation/providers/settings_provider.dart';

/// Settings service for consuming NestJS backend APIs
class SettingsService {
  final Dio _dio;

  SettingsService(this._dio);

  /// Fetch user settings/preferences
  Future<SettingsState> getSettings(int userId) async {
    try {
      final response = await _dio.get('/users/$userId/settings');

      return SettingsState(
        darkMode: response.data['darkMode'] ?? false,
        emailNotifications: response.data['emailNotifications'] ?? true,
        pushNotifications: response.data['pushNotifications'] ?? true,
        taskReminders: response.data['taskReminders'] ?? true,
        weeklyDigest: response.data['weeklyDigest'] ?? false,
        language: response.data['language'] ?? 'en-US',
      );
    } catch (e) {
      throw Exception('Failed to load settings: $e');
    }
  }

  /// Update user settings/preferences
  Future<SettingsState> updateSettings({
    required int userId,
    bool? darkMode,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? taskReminders,
    bool? weeklyDigest,
    String? language,
  }) async {
    try {
      final response = await _dio.patch(
        '/users/$userId/settings',
        data: {
          if (darkMode != null) 'darkMode': darkMode,
          if (emailNotifications != null)
            'emailNotifications': emailNotifications,
          if (pushNotifications != null) 'pushNotifications': pushNotifications,
          if (taskReminders != null) 'taskReminders': taskReminders,
          if (weeklyDigest != null) 'weeklyDigest': weeklyDigest,
          if (language != null) 'language': language,
        },
      );

      return SettingsState(
        darkMode: response.data['darkMode'] ?? false,
        emailNotifications: response.data['emailNotifications'] ?? true,
        pushNotifications: response.data['pushNotifications'] ?? true,
        taskReminders: response.data['taskReminders'] ?? true,
        weeklyDigest: response.data['weeklyDigest'] ?? false,
        language: response.data['language'] ?? 'en-US',
      );
    } catch (e) {
      throw Exception('Failed to update settings: $e');
    }
  }

  /// Update notification preferences
  Future<void> updateNotificationPreferences({
    required int userId,
    required bool emailNotifications,
    required bool pushNotifications,
    required bool taskReminders,
    required bool weeklyDigest,
  }) async {
    try {
      await _dio.patch(
        '/users/$userId/notifications',
        data: {
          'emailNotifications': emailNotifications,
          'pushNotifications': pushNotifications,
          'taskReminders': taskReminders,
          'weeklyDigest': weeklyDigest,
        },
      );
    } catch (e) {
      throw Exception('Failed to update notification preferences: $e');
    }
  }

  /// Update appearance settings
  Future<void> updateAppearanceSettings({
    required int userId,
    required bool darkMode,
    required String language,
  }) async {
    try {
      await _dio.patch(
        '/users/$userId/appearance',
        data: {
          'darkMode': darkMode,
          'language': language,
        },
      );
    } catch (e) {
      throw Exception('Failed to update appearance settings: $e');
    }
  }
}
