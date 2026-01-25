import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/widgets/settings_card.dart';
import '../presentation/widgets/custom_switch.dart';
import '../presentation/widgets/custom_input.dart';
import '../presentation/widgets/settings_tab_button.dart';
import '../core/theme/app_theme.dart';
import '../presentation/providers/settings_provider.dart';
import '../presentation/providers/user_provider.dart';

/// Settings page matching the React prototype Settings.tsx
/// Includes Profile, Notifications, Appearance, and Security tabs
class SettingsPage extends ConsumerStatefulWidget {
  final int initialTab;

  const SettingsPage({super.key, this.initialTab = 0});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late int _currentTabIndex;

  // Controllers for profile form
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  // Controllers for security form
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.initialTab;
    // Initialize form controllers with user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userProvider);
      if (user != null) {
        _nameController.text = user.name;
        _emailController.text = user.email;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = ref.watch(settingsProvider);
    final user = ref.watch(userProvider);

    final tabs = [
      ('Profile', Icons.person_outline, 0),
      ('Notifications', Icons.notifications_outlined, 1),
      ('Appearance', Icons.palette_outlined, 2),
      ('Security', Icons.shield_outlined, 3),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settings',
                  style: AppTheme.heading1.copyWith(
                    color:
                        isDark ? AppTheme.darkForeground : AppTheme.foreground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your account and preferences',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.mutedForeground,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Horizontal Tab Navigation (top)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: tabs
                    .map((tab) => _buildCompactTabButton(
                          label: tab.$1,
                          icon: tab.$2,
                          index: tab.$3,
                          isDark: isDark,
                        ))
                    .toList(),
              ),
            ),

            const SizedBox(height: 28),

            // Content Area
            _buildTabContent(
              _currentTabIndex,
              settings,
              user,
              isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactTabButton({
    required String label,
    required IconData icon,
    required int index,
    required bool isDark,
  }) {
    final isSelected = _currentTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTabIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1.5,
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(
    int tabIndex,
    dynamic settings,
    dynamic user,
    bool isDark,
  ) {
    switch (tabIndex) {
      case 0:
        return _buildProfileTab(user);
      case 1:
        return _buildNotificationsTab(settings);
      case 2:
        return _buildAppearanceTab(settings);
      case 3:
        return _buildSecurityTab();
      default:
        return _buildProfileTab(user);
    }
  }

  Widget _buildProfileTab(user) {
    final initials = user?.name
            ?.split(' ')
            .map((n) => n.isNotEmpty ? n[0] : '')
            .join('')
            .toUpperCase() ??
        'U';

    return SettingsCard(
      title: 'Profile Information',
      description: 'Update your personal information and profile picture',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar section
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.primaryForeground,
                child: Text(
                  initials,
                  style: AppTheme.heading2.copyWith(
                    color: AppTheme.primaryForeground,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        // Handle photo upload
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Photo upload not implemented')),
                        );
                      },
                      child: const Text('Change Photo'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'JPG, GIF or PNG. Max size 2MB.',
                      style: AppTheme.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Form fields
          Row(
            children: [
              Expanded(
                child: CustomInput(
                  label: 'Full Name',
                  controller: _nameController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomInput(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Save button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  ref.read(userProvider.notifier).updateUser(
                        name: _nameController.text,
                        email: _emailController.text,
                      );
                  _handleSave();
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsTab(settings) {
    return SettingsCard(
      title: 'Notification Preferences',
      description: 'Choose how you want to be notified about updates',
      child: Column(
        children: [
          SettingSwitchRow(
            label: 'Email Notifications',
            description: 'Receive email updates about your tasks and projects',
            value: settings.emailNotifications,
            onChanged: (value) {
              ref
                  .read(settingsProvider.notifier)
                  .updateEmailNotifications(value);
            },
          ),
          const SizedBox(height: 24),
          SettingSwitchRow(
            label: 'Push Notifications',
            description: 'Get push notifications in your browser',
            value: settings.pushNotifications,
            onChanged: (value) {
              ref
                  .read(settingsProvider.notifier)
                  .updatePushNotifications(value);
            },
          ),
          const SizedBox(height: 24),
          SettingSwitchRow(
            label: 'Task Reminders',
            description: 'Remind me of upcoming task deadlines',
            value: settings.taskReminders,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateTaskReminders(value);
            },
          ),
          const SizedBox(height: 24),
          SettingSwitchRow(
            label: 'Weekly Digest',
            description: 'Receive a weekly summary of your activity',
            value: settings.weeklyDigest,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateWeeklyDigest(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceTab(settings) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SettingsCard(
      title: 'Appearance',
      description: 'Customize the look and feel of the application',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingSwitchRow(
            label: 'Dark Mode',
            description: 'Switch between light and dark themes',
            value: settings.darkMode,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateDarkMode(value);
            },
            leading: Icon(
              settings.darkMode ? Icons.dark_mode : Icons.light_mode,
              size: 20,
              color: AppTheme.mutedForeground,
            ),
          ),

          const SizedBox(height: 24),

          // Language selection
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Language',
                style: AppTheme.label.copyWith(
                  color: isDark ? AppTheme.darkForeground : AppTheme.foreground,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDark ? AppTheme.darkBorder : AppTheme.border,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.language,
                      size: 20,
                      color: AppTheme.mutedForeground,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'English (US)',
                      style: AppTheme.bodySmall.copyWith(
                        color: isDark
                            ? AppTheme.darkForeground
                            : AppTheme.foreground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTab() {
    return SettingsCard(
      title: 'Security',
      description: 'Manage your password and security settings',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInput(
            label: 'Current Password',
            controller: _currentPasswordController,
            obscureText: true,
          ),

          const SizedBox(height: 16),

          CustomInput(
            label: 'New Password',
            controller: _newPasswordController,
            obscureText: true,
          ),

          const SizedBox(height: 16),

          CustomInput(
            label: 'Confirm New Password',
            controller: _confirmPasswordController,
            obscureText: true,
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_newPasswordController.text ==
                      _confirmPasswordController.text) {
                    // Handle password update
                    _handleSave();
                    _currentPasswordController.clear();
                    _newPasswordController.clear();
                    _confirmPasswordController.clear();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Passwords do not match'),
                        backgroundColor: AppTheme.destructive,
                      ),
                    );
                  }
                },
                child: const Text('Update Password'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Divider(),

          const SizedBox(height: 24),

          // Two-Factor Authentication
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Two-Factor Authentication',
                      style: AppTheme.label.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppTheme.darkForeground
                            : AppTheme.foreground,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Add an extra layer of security to your account',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('2FA setup not implemented'),
                    ),
                  );
                },
                child: const Text('Enable 2FA'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
