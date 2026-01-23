import 'package:flutter/material.dart';
import 'sidebar.dart';

class MainLayout extends StatefulWidget {
  final Widget dashboardContent;
  final Widget? tasksContent;
  final Widget? projectsContent;
  final Widget? profileContent;
  final String appTitle;

  const MainLayout({
    Key? key,
    required this.dashboardContent,
    this.tasksContent,
    this.projectsContent,
    this.profileContent,
    this.appTitle = 'Admin Dashboard',
  }) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  prefixIcon:
                      Icon(Icons.search, color: Colors.grey[400], size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear,
                              color: Colors.grey[400], size: 20),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
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
                  setState(() {});
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
