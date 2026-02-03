import 'package:flutter/material.dart';

class CreateProjectDialog extends StatefulWidget {
  const CreateProjectDialog({super.key});

  @override
  State<CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<CreateProjectDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String _selectedColor = '#8B5CF6';
  List<String> _selectedOwners = [];
  List<String> _selectedEditors = [];
  List<String> _selectedViewers = [];

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
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text(
                        'Select owners...',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFFB4C1D8)
                              : Colors.grey[600],
                        ),
                      ),
                      value: null,
                      underline: const SizedBox(),
                      items: [],
                      onChanged: (value) {},
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
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text(
                        'Select editors...',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFFB4C1D8)
                              : Colors.grey[600],
                        ),
                      ),
                      value: null,
                      underline: const SizedBox(),
                      items: [],
                      onChanged: (value) {},
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
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text(
                        'Select viewers...',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFFB4C1D8)
                              : Colors.grey[600],
                        ),
                      ),
                      value: null,
                      underline: const SizedBox(),
                      items: [],
                      onChanged: (value) {},
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
                      onPressed: _nameController.text.isEmpty
                          ? null
                          : () {
                              // TODO: Implement project creation
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Project created!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              Navigator.pop(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _nameController.text.isEmpty
                            ? Colors.grey
                            : const Color(0xFF8B5CF6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
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
