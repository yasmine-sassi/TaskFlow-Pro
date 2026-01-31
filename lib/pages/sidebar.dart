import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/network/api_client.dart';
import '../presentation/providers/tasks_provider.dart';
import '../presentation/providers/projects_provider.dart';
import '../presentation/providers/user_provider.dart';
import '../presentation/providers/app_providers.dart';
import 'loginpage.dart';

class SidebarItem {
  final String label;
  final IconData icon;
  final int index;

  SidebarItem({
    required this.label,
    required this.icon,
    required this.index,
  });
}

class Sidebar extends ConsumerWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainItems = [
      SidebarItem(label: 'Dashboard', icon: Icons.dashboard_outlined, index: 0),
      SidebarItem(label: 'Tasks', icon: Icons.checklist_rtl, index: 1),
      SidebarItem(
          label: 'Projects', icon: Icons.folder_open_outlined, index: 2),
    ];

    final bottomItems = [
      SidebarItem(label: 'Settings', icon: Icons.settings_outlined, index: 3),
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151B3D) : Colors.white,
        border: isDark
            ? Border(
                right: BorderSide(
                  color: const Color(0xFF2D3A5F),
                  width: 1,
                ),
              )
            : null,
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.shield,
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'TaskFlow Pro',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFFF0F4F8) : Colors.black87,
                  ),
                ),
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? const Color(0xFFB4C1D8) : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          // Main Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: mainItems
                  .map((item) => _buildSidebarItem(context, item))
                  .toList(),
            ),
          ),
          // Bottom Navigation Items (Settings)
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: bottomItems
                  .map((item) => _buildSidebarItem(context, item))
                  .toList(),
            ),
          ),
          // Logout Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () async {
                // Clear all providers to reset state
                ref.invalidate(tasksProvider);
                ref.invalidate(tasksRepositoryProvider);
                ref.invalidate(projectsProvider);
                ref.invalidate(projectsRepositoryProvider);
                ref.invalidate(userProvider);
                ref.invalidate(dioClientProvider);

                // Clear cached authentication data
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('access_token');
                await prefs.remove('user_data');

                // Reset the API client factory
                AuthApiClientFactory.reset();

                // Navigate to login page
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(BuildContext context, SidebarItem item) {
    final isSelected = selectedIndex == item.index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color highlightColor = Theme.of(context).primaryColor.withValues(
          alpha: isDark ? 0.24 : 0.10,
        );
    final Color textColor = isSelected
        ? (isDark ? const Color(0xFF6366F1) : Theme.of(context).primaryColor)
        : (isDark ? const Color(0xFFB4C1D8) : Colors.grey[700]!);
    final Color iconColor = isSelected
        ? (isDark ? const Color(0xFF6366F1) : Theme.of(context).primaryColor)
        : (isDark ? const Color(0xFFB4C1D8) : Colors.grey[600]!);

    return GestureDetector(
      onTap: () => onItemSelected(item.index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? highlightColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border(
                  left: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 3,
                  ),
                )
              : null,
          // Navbar style: no border, just subtle purple fill
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              color: iconColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              item.label,
              style: TextStyle(
                color: textColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
