import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Settings state model
class SettingsState {
  final bool darkMode;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool taskReminders;
  final bool weeklyDigest;
  final String language;

  const SettingsState({
    this.darkMode = false,
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.taskReminders = true,
    this.weeklyDigest = false,
    this.language = 'en-US',
  });

  SettingsState copyWith({
    bool? darkMode,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? taskReminders,
    bool? weeklyDigest,
    String? language,
  }) {
    return SettingsState(
      darkMode: darkMode ?? this.darkMode,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      taskReminders: taskReminders ?? this.taskReminders,
      weeklyDigest: weeklyDigest ?? this.weeklyDigest,
      language: language ?? this.language,
    );
  }
}

/// Settings notifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState());

  void updateDarkMode(bool value) {
    state = state.copyWith(darkMode: value);
    // TODO: Persist to backend API
  }

  void updateEmailNotifications(bool value) {
    state = state.copyWith(emailNotifications: value);
    // TODO: Persist to backend API
  }

  void updatePushNotifications(bool value) {
    state = state.copyWith(pushNotifications: value);
    // TODO: Persist to backend API
  }

  void updateTaskReminders(bool value) {
    state = state.copyWith(taskReminders: value);
    // TODO: Persist to backend API
  }

  void updateWeeklyDigest(bool value) {
    state = state.copyWith(weeklyDigest: value);
    // TODO: Persist to backend API
  }

  void updateLanguage(String value) {
    state = state.copyWith(language: value);
    // TODO: Persist to backend API
  }

  Future<void> loadSettings() async {
    // TODO: Load settings from backend API
    // For now, using default values
  }

  Future<void> saveSettings() async {
    // TODO: Save all settings to backend API
  }
}

/// Settings provider
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
