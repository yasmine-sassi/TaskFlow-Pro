import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/providers/projects_provider.dart';
import '../presentation/providers/user_provider.dart';
import '../presentation/widgets/project_card.dart';
import '../presentation/widgets/create_project_dialog.dart';

class ProjectsPage extends ConsumerStatefulWidget {
  const ProjectsPage({super.key});

  @override
  ConsumerState<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends ConsumerState<ProjectsPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final projectsAsync = ref.watch(projectsProvider);
    final user = ref.watch(userProvider);
    final isAdmin = (user?.role?.toUpperCase() == 'ADMIN' ||
        user?.role?.toLowerCase() == 'admin' ||
        user?.role == 'ADMIN');

    return projectsAsync.when(
      data: (projects) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Projects',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFFF0F4F8) : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${projects.length} project${projects.length != 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? const Color(0xFFB4C1D8) : Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: Icon(Icons.search,
                    color: isDark ? const Color(0xFFB4C1D8) : Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? const Color(0xFF2D3A5F) : Colors.grey[300]!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? const Color(0xFF2D3A5F) : Colors.grey[300]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF8B5CF6), width: 2),
                ),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E2749) : Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Create New Project Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isAdmin
                    ? () {
                        showDialog(
                          context: context,
                          builder: (context) => const CreateProjectDialog(),
                        );
                      }
                    : null,
                icon: const Icon(Icons.add),
                label: Text(isAdmin
                    ? 'Create New Project'
                    : 'Only admins can create projects'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor:
                      isAdmin ? Theme.of(context).primaryColor : Colors.grey,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Projects Grid
            if (projects.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Column(
                    children: [
                      Icon(
                        Icons.folder_open_outlined,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No projects yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color:
                              isDark ? const Color(0xFFF0F4F8) : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Get started by creating your first project',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? const Color(0xFFB4C1D8)
                              : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ProjectCard(project: project),
                  );
                },
              ),
          ],
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              const Text(
                'Failed to load projects',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  ref.invalidate(projectsProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
