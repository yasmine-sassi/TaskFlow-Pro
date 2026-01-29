import 'package:flutter/material.dart';
import '../core/network/api_client.dart';
import '../data/models/user.dart';
import 'main_layout.dart';
import 'settings_page.dart';
import 'projects.dart';
import 'tasks.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<User> users = [];
  late final AuthApiClient apiClient;

  @override
  void initState() {
    super.initState();
    apiClient = AuthApiClientFactory.instance!;
    loadusers();
  }

  Future<void> loadusers() async {
    final response = await apiClient.getusers();

    setState(() {
      users = response.data;
    });
  }

  void _deleteUser(String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                users.removeWhere((user) => user.id == userId);
              });
              apiClient.deleteUser(userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User deleted successfully')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  int get activeUsersCount => users.where((u) => u.status == 'active').length;

  int get adminCount => users.where((u) => u.role == 'ADMIN').length;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MainLayout(
      appTitle: 'Admin Dashboard',
      dashboardContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manage users and monitor system activity',
            style: TextStyle(
              color: isDark ? const Color(0xFFB4C1D8) : Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),

          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.people,
                  iconColor: isDark
                      ? const Color(0xFF8B92FF)
                      : Theme.of(context).primaryColor,
                  value: users.length.toString(),
                  label: 'Total Users',
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.people,
                  iconColor: isDark ? const Color(0xFF4ADE80) : Colors.green,
                  value: activeUsersCount.toString(),
                  label: 'Active Users',
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.shield,
            iconColor: isDark
                ? const Color(0xFF8B92FF)
                : Theme.of(context).primaryColor,
            value: adminCount.toString(),
            label: 'Administrators',
            isDark: isDark,
          ),
          const SizedBox(height: 24),

          // Users Table
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151B3D) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF2D3A5F) : Colors.grey[200]!,
              ),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'All Users',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark ? const Color(0xFFF0F4F8) : Colors.black87,
                    ),
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: users.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return _UserListItem(
                        user: user,
                        onDelete: () => _deleteUser(user.id),
                        isDark: isDark,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      tasksContent: const TasksPage(),
      projectsContent: const ProjectsPage(),
      profileContent: const SettingsPage(initialTab: 0),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final bool isDark;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final Color background = isDark ? const Color(0xFF1E2749) : Colors.white;
    final Color border = isDark ? const Color(0xFF2D3A5F) : Colors.grey[200]!;
    final Color valueColor = isDark ? const Color(0xFFF0F4F8) : Colors.black87;
    final Color labelColor = isDark ? const Color(0xFFB4C1D8) : Colors.grey;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: labelColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserListItem extends StatelessWidget {
  final User user;
  final VoidCallback onDelete;
  final bool isDark;

  const _UserListItem({
    required this.user,
    required this.onDelete,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2749) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF2D3A5F) : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Avatar with gradient
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        isDark
                            ? const Color(0xFF8B92FF)
                            : Theme.of(context).primaryColor,
                        isDark
                            ? const Color(0xFF6366F1)
                            : Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: (isDark
                                ? const Color(0xFF8B92FF)
                                : Theme.of(context).primaryColor)
                            .withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      user.firstName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // User info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: Text(
                          user.fullName,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 19,
                            letterSpacing: 0.2,
                            color: isDark
                                ? const Color(0xFFF0F4F8)
                                : Colors.black87,
                            shadows: isDark
                                ? [
                                    Shadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.3),
                                      offset: const Offset(0, 1),
                                      blurRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 14,
                            color: isDark
                                ? const Color(0xFFB4C1D8)
                                : Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              user.email,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? const Color(0xFFB4C1D8)
                                    : Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _Badge(
                            label: user.role,
                            color: user.role == 'ADMIN'
                                ? (isDark
                                    ? const Color(0xFF8B92FF)
                                    : Theme.of(context).primaryColor)
                                : (isDark
                                    ? const Color(0xFF64748B)
                                    : Colors.grey[600]!),
                            icon: user.role == 'ADMIN'
                                ? Icons.shield
                                : Icons.person,
                          ),
                          const SizedBox(width: 8),
                          _Badge(
                            label: user.status,
                            color: user.status == 'active'
                                ? (isDark
                                    ? const Color(0xFF4ADE80)
                                    : Colors.green)
                                : (isDark
                                    ? const Color(0xFF94A3B8)
                                    : Colors.grey),
                            icon: user.status == 'active'
                                ? Icons.check_circle
                                : Icons.remove_circle,
                            outlined: true,
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 12,
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                user.lastActive,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? const Color(0xFF94A3B8)
                                      : Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Delete button positioned at top-right
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.red.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(10),
                  child: Center(
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final bool outlined;
  final IconData? icon;

  const _Badge({
    required this.label,
    required this.color,
    this.outlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : color.withValues(alpha: 0.15),
        border: outlined
            ? Border.all(color: color.withValues(alpha: 0.5), width: 1.5)
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 12,
              color: color,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
