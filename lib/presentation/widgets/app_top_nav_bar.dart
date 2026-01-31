import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Fixed top navigation bar matching the React prototype
/// Displays on all main pages with active state highlighting
class AppTopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  final Function(int) onNavigationChanged;
  final Widget? trailing;
  final bool isBottom;

  const AppTopNavBar({
    super.key,
    required this.currentIndex,
    required this.onNavigationChanged,
    this.trailing,
    this.isBottom = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final decoration = BoxDecoration(
      color: isDark ? AppTheme.darkCard : AppTheme.card,
      border: Border(
        top: isBottom
            ? const BorderSide(color: AppTheme.border, width: 1)
            : BorderSide.none,
        bottom: isBottom
            ? BorderSide.none
            : const BorderSide(color: AppTheme.border, width: 1),
      ),
    );

    if (isBottom) {
      // Compact bottom navigation: evenly spaced items, no brand/trailing
      return Container(
        height: 64,
        decoration: decoration,
        child: SafeArea(
          bottom: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                label: 'Dashboard',
                isActive: currentIndex == 0,
                onTap: () => onNavigationChanged(0),
              ),
              _NavItem(
                label: 'Tasks',
                isActive: currentIndex == 1,
                onTap: () => onNavigationChanged(1),
              ),
              _NavItem(
                label: 'Projects',
                isActive: currentIndex == 2,
                onTap: () => onNavigationChanged(2),
              ),
              _NavItem(
                label: 'Settings',
                isActive: currentIndex == 3,
                onTap: () => onNavigationChanged(3),
              ),
            ],
          ),
        ),
      );
    }

    // Top navigation with brand and optional trailing
    return Container(
      height: 64,
      decoration: decoration,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              // Logo and brand
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.check_box,
                      color: AppTheme.primaryForeground,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'TaskFlow Pro',
                    style: AppTheme.heading3.copyWith(
                      color: isDark
                          ? AppTheme.darkForeground
                          : AppTheme.foreground,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Nav items
              _NavItem(
                label: 'Dashboard',
                isActive: currentIndex == 0,
                onTap: () => onNavigationChanged(0),
              ),
              const SizedBox(width: 8),
              _NavItem(
                label: 'Tasks',
                isActive: currentIndex == 1,
                onTap: () => onNavigationChanged(1),
              ),
              const SizedBox(width: 8),
              _NavItem(
                label: 'Projects',
                isActive: currentIndex == 2,
                onTap: () => onNavigationChanged(2),
              ),
              const SizedBox(width: 8),
              _NavItem(
                label: 'Settings',
                isActive: currentIndex == 3,
                onTap: () => onNavigationChanged(3),
              ),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppTheme.primary.withValues(alpha: 0.1)
                : _isHovered
                    ? (isDark ? AppTheme.darkSecondary : AppTheme.secondary)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: Text(
            widget.label,
            style: AppTheme.bodyMedium.copyWith(
              color: widget.isActive
                  ? AppTheme.primary
                  : (isDark ? AppTheme.darkForeground : AppTheme.foreground),
              fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
