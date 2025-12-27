import 'package:flutter/material.dart';
import '../core/network/api_client.dart';
import '../data/models/user.dart';

// Mock user model
// class User {
//   final String id;
//   final String name;
//   final String email;
//   final String avatar;
//   final String role;
//   final String status;
//   final String lastActive;

//   User({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.avatar,
//     required this.role,
//     required this.status,
//     required this.lastActive,
//   });
// }

// // Mock data
// final List<User> adminUsers = [
//   User(
//     id: '1',
//     name: 'John Doe',
//     email: 'john.doe@test.com',
//     avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=John',
//     role: 'user',
//     status: 'active',
//     lastActive: '2024-12-12',
//   ),
//   User(
//     id: '2',
//     name: 'Jane Smith',
//     email: 'admin@test.com',
//     avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Jane',
//     role: 'admin',
//     status: 'active',
//     lastActive: '2024-12-12',
//   ),
//   User(
//     id: '3',
//     name: 'Bob Johnson',
//     email: 'bob.johnson@test.com',
//     avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Bob',
//     role: 'user',
//     status: 'active',
//     lastActive: '2024-12-12',
//   ),
//   User(
//     id: '4',
//     name: 'Sarah Williams',
//     email: 'sarah.williams@test.com',
//     avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Sarah',
//     role: 'user',
//     status: 'active',
//     lastActive: '2024-12-12',
//   ),
//   User(
//     id: '5',
//     name: 'Emily Davis',
//     email: 'emily.davis@test.com',
//     avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Emily',
//     role: 'user',
//     status: 'inactive',
//     lastActive: '2024-12-01',
//   ),
// ];

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<User> users = [];
  final apiClient = AuthApiClientFactory.instance!;

  @override void initState() {
    super.initState();
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

  int get activeUsersCount =>
      users.where((u) => u.status == 'active').length;

  int get adminCount =>
      users.where((u) => u.role == 'ADMIN').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.shield, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text(
              'Admin Dashboard',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage users and monitor system activity',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),
            
            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.people,
                    iconColor: Theme.of(context).primaryColor,
                    value: users.length.toString(),
                    label: 'Total Users',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.people,
                    iconColor: Colors.green,
                    value: activeUsersCount.toString(),
                    label: 'Active Users',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _StatCard(
              icon: Icons.shield,
              iconColor: Theme.of(context).primaryColor,
              value: adminCount.toString(),
              label: 'Administrators',
            ),
            const SizedBox(height: 24),
            
            // Users Table
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'All Users',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: users.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
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
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              color: iconColor.withOpacity(0.1),
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
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
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
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        child: Text(
          user.firstName[0],
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      title: Text(
        user.fullName,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _Badge(
                label: user.role,
                color: user.role == 'admin'
                    ? Theme.of(context).primaryColor
                    : Colors.grey[600]!,
              ),
              const SizedBox(width: 8),
              _Badge(
                label: user.status,
                color: user.status == 'active' ? Colors.green : Colors.grey,
                outlined: true,
              ),
              const SizedBox(width: 8),
              Text(
                user.lastActive,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
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

