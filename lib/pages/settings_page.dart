import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import '../presentation/widgets/settings_card.dart';
import '../presentation/widgets/custom_switch.dart';
import '../presentation/widgets/custom_input.dart';
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
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  // Controllers for security form
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Password visibility states
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedImageBase64;
  bool _isProfileLoading = false;
  bool _isPasswordLoading = false;

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.initialTab;
    // Initialize form controllers with user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
      // Force reload from backend to ensure fresh data
      ref.read(userProvider.notifier).loadUserFromBackend();
    });
  }

  void _loadUserData() {
    final user = ref.read(userProvider);
    if (user != null) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _emailController.text = user.email;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await File(image.path).readAsBytes();
        final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';
        setState(() {
          _selectedImageBase64 = base64Image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: AppTheme.destructive,
          ),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isProfileLoading = true);

    try {
      print('Updating profile with:');
      print('First Name: ${_firstNameController.text.trim()}');
      print('Last Name: ${_lastNameController.text.trim()}');
      print('Avatar: ${_selectedImageBase64?.substring(0, 50)}...');

      final success = await ref.read(userProvider.notifier).updateProfile(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            avatar: _selectedImageBase64,
          );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          setState(() => _selectedImageBase64 = null);
          _loadUserData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Failed to update profile. Please check console for details.'),
              backgroundColor: AppTheme.destructive,
            ),
          );
        }
      }
    } catch (e) {
      print('Error updating profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppTheme.destructive,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProfileLoading = false);
      }
    }
  }

  Future<void> _changePassword() async {
    // Validation
    if (_currentPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Current password is required'),
          backgroundColor: AppTheme.destructive,
        ),
      );
      return;
    }

    if (_newPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New password is required'),
          backgroundColor: AppTheme.destructive,
        ),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: AppTheme.destructive,
        ),
      );
      return;
    }

    if (_newPasswordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 8 characters'),
          backgroundColor: AppTheme.destructive,
        ),
      );
      return;
    }

    setState(() => _isPasswordLoading = true);

    try {
      await ref.read(userProvider.notifier).changePassword(
            currentPassword: _currentPasswordController.text,
            newPassword: _newPasswordController.text,
            confirmPassword: _confirmPasswordController.text,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Failed to change password';
        if (e.toString().contains('400')) {
          errorMessage =
              'Invalid current password or password requirements not met';
        } else if (e.toString().contains('401')) {
          errorMessage = 'Authentication failed. Please login again.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppTheme.destructive,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPasswordLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = ref.watch(settingsProvider);
    final user = ref.watch(userProvider);

    // Update text controllers when user data changes
    if (user != null) {
      if (_firstNameController.text != user.firstName) {
        _firstNameController.text = user.firstName;
      }
      if (_lastNameController.text != user.lastName) {
        _lastNameController.text = user.lastName;
      }
      if (_emailController.text != user.email) {
        _emailController.text = user.email;
      }
    }

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
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFFF0F4F8) : Colors.black87,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your account and preferences',
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        isDark ? const Color(0xFFB4C1D8) : Colors.grey.shade600,
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
              ? Theme.of(context).primaryColor.withValues(
                    alpha: isDark ? 0.24 : 0.10,
                  )
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          // Navbar style: no border, just subtle purple fill
          border: isSelected
              ? const Border(
                  bottom: BorderSide(color: Color(0xFF6366F1), width: 2),
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF6366F1)
                  : (isDark ? const Color(0xFFB4C1D8) : Colors.grey[600]),
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
                    ? const Color(0xFF6366F1)
                    : (isDark ? const Color(0xFFB4C1D8) : Colors.grey[600]),
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
    final initials = user != null && user.firstName.isNotEmpty
        ? '${user.firstName[0]}${user.lastName.isNotEmpty ? user.lastName[0] : ''}'
            .toUpperCase()
        : 'U';

    return SettingsCard(
      title: 'Profile Information',
      description: 'Update your personal information and profile picture',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar section
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppTheme.primary,
                    foregroundColor: AppTheme.primaryForeground,
                    backgroundImage: _selectedImageBase64 != null
                        ? MemoryImage(
                            base64Decode(_selectedImageBase64!.split(',')[1]))
                        : (user?.avatar != null
                            ? NetworkImage(user!.avatar!)
                            : null) as ImageProvider?,
                    child: _selectedImageBase64 == null && user?.avatar == null
                        ? Text(
                            initials,
                            style: AppTheme.heading2.copyWith(
                              color: AppTheme.primaryForeground,
                            ),
                          )
                        : null,
                  ),
                  if (_selectedImageBase64 != null)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.upload, size: 18),
                      label: const Text('Change Photo'),
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
                  label: 'First Name',
                  controller: _firstNameController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomInput(
                  label: 'Last Name',
                  controller: _lastNameController,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          CustomInput(
            label: 'Email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            enabled: false,
          ),

          const SizedBox(height: 24),

          // Save button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _isProfileLoading ? null : _saveProfile,
                child: _isProfileLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Save Changes'),
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
          // Current Password
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Password',
                style: AppTheme.label.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.darkForeground
                      : AppTheme.foreground,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _currentPasswordController,
                obscureText: !_showCurrentPassword,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showCurrentPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppTheme.mutedForeground,
                    ),
                    onPressed: () {
                      setState(() {
                        _showCurrentPassword = !_showCurrentPassword;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // New Password
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New Password',
                style: AppTheme.label.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.darkForeground
                      : AppTheme.foreground,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _newPasswordController,
                obscureText: !_showNewPassword,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showNewPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppTheme.mutedForeground,
                    ),
                    onPressed: () {
                      setState(() {
                        _showNewPassword = !_showNewPassword;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Confirm New Password
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confirm New Password',
                style: AppTheme.label.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.darkForeground
                      : AppTheme.foreground,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_showConfirmPassword,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppTheme.mutedForeground,
                    ),
                    onPressed: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _isPasswordLoading ? null : _changePassword,
                child: _isPasswordLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Update Password'),
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
