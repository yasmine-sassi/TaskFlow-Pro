import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Tab button for settings tabs matching the React prototype TabsTrigger
class SettingsTabButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const SettingsTabButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<SettingsTabButton> createState() => _SettingsTabButtonState();
}

class _SettingsTabButtonState extends State<SettingsTabButton> {
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
                ? (isDark ? AppTheme.darkCard : AppTheme.card)
                : (_isHovered
                    ? (isDark
                        ? AppTheme.darkCard.withValues(alpha: 0.5)
                        : AppTheme.card.withValues(alpha: 0.5))
                    : Colors.transparent),
            border: widget.isActive
                ? Border(
                    bottom: BorderSide(
                      color: AppTheme.primary,
                      width: 2,
                    ),
                  )
                : null,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppTheme.radiusSm),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: widget.isActive
                    ? (isDark ? AppTheme.darkForeground : AppTheme.foreground)
                    : AppTheme.mutedForeground,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: AppTheme.bodyMedium.copyWith(
                  color: widget.isActive
                      ? (isDark ? AppTheme.darkForeground : AppTheme.foreground)
                      : AppTheme.mutedForeground,
                  fontWeight:
                      widget.isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tab bar for settings tabs
class SettingsTabBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChanged;
  final List<SettingsTab> tabs;

  const SettingsTabBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppTheme.darkBorder : AppTheme.border,
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            tabs.length,
            (index) => SettingsTabButton(
              label: tabs[index].label,
              icon: tabs[index].icon,
              isActive: currentIndex == index,
              onTap: () => onTabChanged(index),
            ),
          ),
        ),
      ),
    );
  }
}

/// Settings tab data model
class SettingsTab {
  final String label;
  final IconData icon;
  final Widget content;

  const SettingsTab({
    required this.label,
    required this.icon,
    required this.content,
  });
}
