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
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return _UserListItem(
                      user: user,
                      onDelete: () => _deleteUser(user.id),
                    );
                  },
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

  const _UserListItem({
    required this.user,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: isDark
            ? const Color(0xFF8B92FF).withValues(alpha: 0.15)
            : Theme.of(context).primaryColor.withValues(alpha: 0.1),
        child: Text(
          user.firstName[0],
          style: TextStyle(
            color: isDark
                ? const Color(0xFF8B92FF)
                : Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      title: Text(
        user.fullName,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDark ? const Color(0xFFF0F4F8) : Colors.black87,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFFB4C1D8) : Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _Badge(
                label: user.role,
                color: user.role == 'admin'
                    ? Theme.of(context).primaryColor
                    : (isDark ? const Color(0xFFB4C1D8) : Colors.grey[600]!),
              ),
              const SizedBox(width: 8),
              _Badge(
                label: user.status,
                color: user.status == 'active'
                    ? Colors.green
                    : (isDark ? const Color(0xFFB4C1D8) : Colors.grey),
                outlined: true,
              ),
              const SizedBox(width: 8),
              Text(
                user.lastActive,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? const Color(0xFFB4C1D8) : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: onDelete,
      ),
      isThreeLine: true,
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final bool outlined;

  const _Badge({
    required this.label,
    required this.color,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : color,
        border: outlined ? Border.all(color: color, width: 1) : null,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: outlined ? color : Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
