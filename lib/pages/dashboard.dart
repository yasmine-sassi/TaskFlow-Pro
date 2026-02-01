import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/user.dart';
import '../data/models/project_model.dart';
import '../data/models/task_model.dart';
import '../core/network/api_client.dart';
import 'main_layout.dart';
import 'tasks.dart';
import 'Projects.dart';
import 'settings_page.dart';

extension HexColor on String {
  Color toColor() {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

// Dashboard Page
class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  TaskModel? selectedTask;
  final AuthApiClient? apiClient = AuthApiClientFactory.instance;
  List<ProjectModel> userProjects = [];
  List<TaskModel> tasks = [];
  User currentUser = User(
    id: '',
    email: '',
    firstName: '',
    lastName: '',
    role: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    getcurrentUser();
    loadprojects();
    loadtasks();
  }

  Future<void> getcurrentUser() async {
    final response = await apiClient!.getMe();
    setState(() {
      currentUser = response;
    });
  }

  Future<void> loadprojects() async {
    final response = await apiClient!.getProjects();
    setState(() {
      userProjects = response.data;
    });
  }

  Future<void> loadtasks() async {
    final response = await apiClient!.getMyTasks();
    setState(() {
      tasks = response.data;
    });
  }

  // bool get isAdmin => currentUser.role == 'admin';

  int get todoCount => tasks.where((t) => t.status == 'TODO').length;

  int get inProgressCount =>
      tasks.where((t) => t.status == 'IN_PROGRESS').length;

  int get doneCount => tasks.where((t) => t.status == 'DONE').length;

  // int get overdueCount => tasks.where((t) {
  //       final isPastDue = t.dueDate.isBefore(DateTime.now());
  //       final isNotToday = !_isToday(t.dueDate  );
  //       return t.status != 'DONE' && isPastDue && isNotToday;
  //     }).length;

  List<TaskModel> get recentTasks {
    final sortedTasks = List<TaskModel>.from(tasks)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sortedTasks.take(5).toList();
  }

  List<TaskModel> get highPriorityTasks {
    return tasks
        .where((t) => t.priority == 'HIGH' && t.status != 'DONE')
        .take(3)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appTitle: 'Dashboard',
      dashboardContent: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            _buildStatsGrid(),
            const SizedBox(height: 24),
            _buildProjectsOverview(),
            const SizedBox(height: 24),
            _buildContentGrid(),
          ],
        ),
      ),
      tasksContent: const TasksPage(),
      projectsContent: const ProjectsPage(),
      profileContent: const SettingsPage(),
    );
  }

  Widget _buildWelcomeSection() {
    final firstName = currentUser.firstName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, $firstName!',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Here's what's happening with your tasks today.",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    final stats = [
      _StatItem(
        title: 'To Do',
        value: todoCount,
        icon: Icons.list_alt,
        backgroundColor: Colors.blue[50]!,
        iconColor: Colors.blue[700]!,
      ),
      _StatItem(
        title: 'In Progress',
        value: inProgressCount,
        icon: Icons.schedule,
        backgroundColor: Colors.amber[50]!,
        iconColor: Colors.amber[700]!,
      ),
      _StatItem(
        title: 'Completed',
        value: doneCount,
        icon: Icons.check_circle,
        backgroundColor: Colors.green[50]!,
        iconColor: Colors.green[700]!,
      ),
      // _StatItem(
      //   title: 'Overdue',
      //   value: overdueCount,
      //   icon: Icons.warning,
      //   backgroundColor: Colors.red[50]!,
      //   iconColor: Colors.red[700]!,
      // ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900
            ? 4
            : constraints.maxWidth > 600
                ? 2
                : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.5,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) => _StatCard(stat: stats[index]),
        );
      },
    );
  }

  Widget _buildProjectsOverview() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Projects',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to projects page
                  },
                  child: const Text('View all'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 900
                    ? 4
                    : constraints.maxWidth > 600
                        ? 2
                        : 1;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3,
                  ),
                  itemCount: userProjects.take(4).length,
                  itemBuilder: (context, index) {
                    final project = userProjects[index];
                    final taskCount =
                        tasks.where((t) => t.projectId == project.id).length;
                    return _ProjectCard(
                      project: project,
                      taskCount: taskCount,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildRecentActivity()),
              const SizedBox(width: 24),
              Expanded(child: _buildHighPriority()),
            ],
          );
        } else {
          return Column(
            children: [
              _buildRecentActivity(),
              const SizedBox(height: 24),
              _buildHighPriority(),
            ],
          );
        }
      },
    );
  }

  Widget _buildRecentActivity() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            if (recentTasks.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    'No recent activity',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else if (userProjects.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    'No projects available',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              ...recentTasks.map((task) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TaskCard(
                      task: task,
                      project: userProjects.firstWhere(
                        (p) => p.id == task.projectId,
                        orElse: () => userProjects.first,
                      ),
                      onTap: () => setState(() => selectedTask = task),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildHighPriority() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'High Priority',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            if (highPriorityTasks.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    'No high priority tasks pending',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else if (userProjects.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    'No projects available',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              ...highPriorityTasks.map((task) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TaskCard(
                      task: task,
                      project: userProjects.firstWhere(
                        (p) => p.id == task.projectId,
                        orElse: () => userProjects.first,
                      ),
                      onTap: () => setState(() => selectedTask = task),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}

// Stat Item Model
class _StatItem {
  final String title;
  final int value;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  _StatItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });
}

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final _StatItem stat;

  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: stat.backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                stat.icon,
                color: stat.iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${stat.value}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    stat.title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
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

// Project Card Widget
class _ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final int taskCount;

  const _ProjectCard({
    required this.project,
    required this.taskCount,
  });

  @override
  Widget build(BuildContext context) {
    final projectColor = project.color?.toColor() ?? Colors.grey;

    return InkWell(
      onTap: () {
        // Navigate to projects page
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: projectColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.folder_open,
                color: projectColor,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    project.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$taskCount tasks',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
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

// Task Card Widget
class TaskCard extends StatelessWidget {
  final TaskModel task;
  final ProjectModel project;
  final VoidCallback onTap;

  const TaskCard({
    Key? key,
    required this.task,
    required this.project,
    required this.onTap,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (task.status) {
      case 'todo':
        return Colors.blue;
      case 'in_progress':
        return Colors.amber;
      case 'done':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (task.status) {
      case 'todo':
        return 'To Do';
      case 'in_progress':
        return 'In Progress';
      case 'done':
        return 'Done';
      default:
        return task.status;
    }
  }

  Color _getPriorityColor() {
    switch (task.priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectColor = project.color?.toColor() ?? Colors.grey;
    final dueDate = task.dueDate;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getPriorityColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    task.priority.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _getPriorityColor(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: projectColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  project.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: TextStyle(
                      fontSize: 11,
                      color: _getStatusColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (dueDate != null) ...[
                  const Spacer(),
                  Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM dd').format(dueDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
