import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../../presentation/providers/projects_provider.dart';
import '../../presentation/providers/user_provider.dart' hide User;

class CreateProjectDialog extends ConsumerStatefulWidget {
  const CreateProjectDialog({super.key});

  @override
  ConsumerState<CreateProjectDialog> createState() =>
      _CreateProjectDialogState();
}

class _CreateProjectDialogState extends ConsumerState<CreateProjectDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String _selectedColor = '#8B5CF6';
  List<String> _selectedOwners = [];
  List<String> _selectedEditors = [];
  List<String> _selectedViewers = [];
  List<User> _allUsers = [];
  bool _isLoadingUsers = true;
  bool _isCreatingProject = false;

  final List<Map<String, String>> _colorOptions = [
    {'name': 'Blue', 'value': '#3B82F6'},
    {'name': 'Purple', 'value': '#8B5CF6'},
    {'name': 'Pink', 'value': '#EC4899'},
    {'name': 'Green', 'value': '#10B981'},
    {'name': 'Orange', 'value': '#F97316'},
    {'name': 'Red', 'value': '#EF4444'},
    {'name': 'Cyan', 'value': '#06B6D4'},
    {'name': 'Yellow', 'value': '#EAB308'},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final apiClient = AuthApiClientFactory.dio;
      if (apiClient == null) {
        print('Error: API client not initialized');
        setState(() {
          _isLoadingUsers = false;
        });
        return;
      }

      final response = await apiClient.get('/users');
      print('Users response: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> usersList;

        // Check if response.data is already a List or wrapped in an object
        if (response.data is List) {
          usersList = response.data as List<dynamic>;
        } else if (response.data is Map<String, dynamic>) {
          // Backend might wrap the response, check common keys
          final dataMap = response.data as Map<String, dynamic>;
          if (dataMap.containsKey('data')) {
            usersList = dataMap['data'] as List<dynamic>;
          } else if (dataMap.containsKey('users')) {
            usersList = dataMap['users'] as List<dynamic>;
          } else {
            // If no wrapper found, the map itself might be the issue
            print('Unexpected response structure: $dataMap');
            setState(() {
              _isLoadingUsers = false;
            });
            return;
          }
        } else {
          print('Unexpected response type: ${response.data.runtimeType}');
          setState(() {
            _isLoadingUsers = false;
          });
          return;
        }

        final users = User.fromJsonList(usersList);
        setState(() {
          _allUsers = users;
          _isLoadingUsers = false;
        });
      }
    } catch (e) {
      print('Error fetching users: $e');
      setState(() {
        _isLoadingUsers = false;
      });
    }
  }

  Future<void> _createProject(BuildContext context) async {
    if (_nameController.text.isEmpty) return;

    setState(() {
      _isCreatingProject = true;
    });

    try {
      final apiClient = AuthApiClientFactory.dio;
      if (apiClient == null) {
        throw Exception('API client not initialized');
      }

      final user = ref.read(userProvider);
      if (user?.id == null) {
        throw Exception('User not logged in');
      }

      // Prepare the payload according to CreateProjectDto
      final payload = {
        'name': _nameController.text,
        'description': _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        'color': _selectedColor,
        'ownerId': user!.id,
        'editors': _selectedEditors,
        'viewers': _selectedViewers,
      };

      print('Creating project with payload: $payload');

      final response = await apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.projects}',
        data: payload,
      );

      print('Project created successfully: ${response.data}');

      // Refresh the projects list
      ref.invalidate(projectsProvider);

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Project "${_nameController.text}" created successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error creating project: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create project: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingProject = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hexColor) {
    hexColor = hexColor.replaceFirst('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 600,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2749) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Create New Project',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFFF0F4F8) : Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),

                // Project Name
                Text(
                  'Project Name',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFFF0F4F8) : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'e.g. Website Redesign',
                    hintStyle: TextStyle(
                      color:
                          isDark ? const Color(0xFFB4C1D8) : Colors.grey[400],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark
                            ? const Color(0xFF2D3A5F)
                            : Colors.grey[300]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF8B5CF6),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF151B3D) : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  style: TextStyle(
                    color: isDark ? const Color(0xFFF0F4F8) : Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // Description
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFFF0F4F8) : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Brief description of the project...',
                    hintStyle: TextStyle(
                      color:
                          isDark ? const Color(0xFFB4C1D8) : Colors.grey[400],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark
                            ? const Color(0xFF2D3A5F)
                            : Colors.grey[300]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF8B5CF6),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF151B3D) : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  style: TextStyle(
                    color: isDark ? const Color(0xFFF0F4F8) : Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // Project Color
                Text(
                  'Project Color',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFFF0F4F8) : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _colorOptions.map((colorOption) {
                    final isSelected = _selectedColor == colorOption['value'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = colorOption['value']!;
                        });
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: _hexToColor(colorOption['value']!),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                isSelected ? Colors.white : Colors.transparent,
                            width: isSelected ? 3 : 0,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: _hexToColor(colorOption['value']!)
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 24)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Members Section
                Text(
                  'Members',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFFF0F4F8) : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                // Owners
                Text(
                  'Owners',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? const Color(0xFFB4C1D8) : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          isDark ? const Color(0xFF2D3A5F) : Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _isLoadingUsers
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : DropdownButton<String>(
                            isExpanded: true,
                            hint: Text(
                              _selectedOwners.isEmpty
                                  ? 'Select owners...'
                                  : '${_selectedOwners.length} owner(s) selected',
                              style: TextStyle(
                                color: isDark
                                    ? const Color(0xFFB4C1D8)
                                    : Colors.grey[600],
                              ),
                            ),
                            value: null,
                            underline: const SizedBox(),
                            items: _allUsers.map((user) {
                              return DropdownMenuItem<String>(
                                value: user.id,
                                child: Text(
                                  user.fullName,
                                  style: TextStyle(
                                    color: isDark
                                        ? const Color(0xFFF0F4F8)
                                        : Colors.black87,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null &&
                                  !_selectedOwners.contains(value)) {
                                setState(() {
                                  _selectedOwners.add(value);
                                });
                              }
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 12),

                // Editors
                Text(
                  'Editors',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? const Color(0xFFB4C1D8) : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          isDark ? const Color(0xFF2D3A5F) : Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _isLoadingUsers
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : DropdownButton<String>(
                            isExpanded: true,
                            hint: Text(
                              _selectedEditors.isEmpty
                                  ? 'Select editors...'
                                  : '${_selectedEditors.length} editor(s) selected',
                              style: TextStyle(
                                color: isDark
                                    ? const Color(0xFFB4C1D8)
                                    : Colors.grey[600],
                              ),
                            ),
                            value: null,
                            underline: const SizedBox(),
                            items: _allUsers.map((user) {
                              return DropdownMenuItem<String>(
                                value: user.id,
                                child: Text(
                                  user.fullName,
                                  style: TextStyle(
                                    color: isDark
                                        ? const Color(0xFFF0F4F8)
                                        : Colors.black87,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null &&
                                  !_selectedEditors.contains(value)) {
                                setState(() {
                                  _selectedEditors.add(value);
                                });
                              }
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 12),

                // Viewers
                Text(
                  'Viewers',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? const Color(0xFFB4C1D8) : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          isDark ? const Color(0xFF2D3A5F) : Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _isLoadingUsers
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : DropdownButton<String>(
                            isExpanded: true,
                            hint: Text(
                              _selectedViewers.isEmpty
                                  ? 'Select viewers...'
                                  : '${_selectedViewers.length} viewer(s) selected',
                              style: TextStyle(
                                color: isDark
                                    ? const Color(0xFFB4C1D8)
                                    : Colors.grey[600],
                              ),
                            ),
                            value: null,
                            underline: const SizedBox(),
                            items: _allUsers.map((user) {
                              return DropdownMenuItem<String>(
                                value: user.id,
                                child: Text(
                                  user.fullName,
                                  style: TextStyle(
                                    color: isDark
                                        ? const Color(0xFFF0F4F8)
                                        : Colors.black87,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null &&
                                  !_selectedViewers.contains(value)) {
                                setState(() {
                                  _selectedViewers.add(value);
                                });
                              }
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFFB4C1D8)
                              : Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed:
                          _nameController.text.isEmpty || _isCreatingProject
                              ? null
                              : () => _createProject(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _nameController.text.isEmpty || _isCreatingProject
                                ? Colors.grey
                                : const Color(0xFF8B5CF6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: _isCreatingProject
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Create Project',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
