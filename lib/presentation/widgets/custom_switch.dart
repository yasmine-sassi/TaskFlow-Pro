import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Custom switch matching the React prototype Switch component
class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const CustomSwitch({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          color: value ? AppTheme.primary : AppTheme.border,
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(2),
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

/// Setting row with label, description, and trailing switch
class SettingSwitchRow extends StatelessWidget {
  final String label;
  final String? description;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? leading;

  const SettingSwitchRow({
    super.key,
    required this.label,
    this.description,
    required this.value,
    this.onChanged,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.label.copyWith(
                  color: isDark ? AppTheme.darkForeground : AppTheme.foreground,
                ),
              ),
              if (description != null) ...[
                const SizedBox(height: 2),
                Text(
                  description!,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.mutedForeground,
                  ),
                ),
              ],
            ],
          ),
        ),
        CustomSwitch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
