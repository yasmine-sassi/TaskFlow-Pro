import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sidebar.dart';
import '../presentation/providers/projects_provider.dart';
import '../presentation/providers/tasks_provider.dart';
import '../domain/entities/project.dart';
import '../domain/entities/task.dart';
import 'package:intl/intl.dart';

class MainLayout extends ConsumerStatefulWidget {
  final Widget dashboardContent;
  final Widget? tasksContent;
  final Widget? projectsContent;
  final Widget? profileContent;
  final String appTitle;

  const MainLayout({
    super.key,
    required this.dashboardContent,
    this.tasksContent,
    this.projectsContent,
    this.profileContent,
    this.appTitle = 'Admin Dashboard',
  });

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  int _selectedIndex = 0;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  bool _showSearchResults = false;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus && _searchController.text.isNotEmpty) {
        setState(() {
          _showSearchResults = true;
        });
      }
    });
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Tasks';
      case 2:
        return 'Projects';
      case 3:
        return 'Profile';
      default:
        return widget.appTitle;
    }
  }

  Widget _getPageContent(int index) {
    if (_showSearchResults && _searchController.text.isNotEmpty) {
      return _buildSearchResults();
    }

    switch (index) {
      case 0:
        return widget.dashboardContent;
      case 1:
        return widget.tasksContent ?? _buildPlaceholder('Tasks');
      case 2:
        return widget.projectsContent ?? _buildPlaceholder('Projects');
      case 3:
        return widget.profileContent ?? _buildPlaceholder('Profile');
      default:
        return widget.dashboardContent;
    }
  }

  Widget _buildSearchResults() {
    final query = _searchController.text.toLowerCase();
    final projectsAsync = ref.watch(projectsProvider);
    final tasksAsync = ref.watch(tasksProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Search Results for "${_searchController.text}"',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _showSearchResults = false;
                });
              },
              icon: const Icon(Icons.close, size: 18),
              label: const Text('Clear Search'),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Projects Results
        projectsAsync.when(
          data: (projects) {
            final filteredProjects = projects.where((project) {
              return project.name.toLowerCase().contains(query) ||
                  (project.description?.toLowerCase().contains(query) ?? false);
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Projects (${filteredProjects.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                if (filteredProjects.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No projects found',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  ...filteredProjects
                      .map((project) => _buildProjectCard(project)),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text('Error loading projects: $error'),
        ),

        const SizedBox(height: 32),

        // Tasks Results
        tasksAsync.when(
          data: (tasks) {
            final filteredTasks = tasks.where((task) {
              return task.title.toLowerCase().contains(query) ||
                  (task.description?.toLowerCase().contains(query) ?? false);
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tasks (${filteredTasks.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                if (filteredTasks.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No tasks found',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  ...filteredTasks.map((task) => _buildTaskCard(task)),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text('Error loading tasks: $error'),
        ),
      ],
    );
  }

  Widget _buildProjectCard(Project project) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          setState(() {
            _selectedIndex = 2; // Navigate to Projects
            _showSearchResults = false;
            _searchController.clear();
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.folder,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (project.description?.isNotEmpty ?? false)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          project.description!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Active',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (project.members?.isNotEmpty ?? false)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '${project.members?.length ?? 0} members',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    Color statusColor;
    switch (task.status) {
      case 'DONE':
        statusColor = Colors.green;
        break;
      case 'IN_PROGRESS':
        statusColor = Colors.blue;
        break;
      case 'IN_REVIEW':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    Color priorityColor;
    switch (task.priority) {
      case 'CRITICAL':
        priorityColor = Colors.red;
        break;
      case 'HIGH':
        priorityColor = Colors.orange;
        break;
      case 'MEDIUM':
        priorityColor = Colors.yellow[700]!;
        break;
      default:
        priorityColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          setState(() {
            _selectedIndex = 1; // Navigate to Tasks
            _showSearchResults = false;
            _searchController.clear();
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.task_alt,
                  color: statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (task.description?.isNotEmpty ?? false)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          task.description!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          task.status.replaceAll('_', ' '),
                          style: TextStyle(
                            fontSize: 11,
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: priorityColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          task.priority,
                          style: TextStyle(
                            fontSize: 11,
                            color: priorityColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (task.dueDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Due ${DateFormat('MMM dd').format(task.dueDate!)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '$title Page',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

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
            Text(
              _getPageTitle(_selectedIndex),
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 24),
            // Search Field
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search tasks and projects...',
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  prefixIcon:
                      Icon(Icons.search, color: Colors.grey[400], size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear,
                              color: Colors.grey[400], size: 20),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _showSearchResults = false;
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1.5,
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 14),
                onChanged: (value) {
                  setState(() {
                    _showSearchResults = value.isNotEmpty;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Sidebar(
          selectedIndex: _selectedIndex,
          onItemSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _getPageContent(_selectedIndex),
      ),
    );
  }
}
