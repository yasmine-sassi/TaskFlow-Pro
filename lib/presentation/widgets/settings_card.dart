import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Settings card component matching the React prototype Card design
class SettingsCard extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget child;
  final EdgeInsets? padding;

  const SettingsCard({
    super.key,
    this.title,
    this.description,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.card,
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.border,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || description != null)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: AppTheme.heading3.copyWith(
                        color: isDark
                            ? AppTheme.darkForeground
                            : AppTheme.foreground,
                      ),
                    ),
                  if (description != null) ...[
                    const SizedBox(height: 4),
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
          if (title != null || description != null)
            Divider(
              height: 1,
              thickness: 1,
              color: isDark ? AppTheme.darkBorder : AppTheme.border,
            ),
          Padding(
            padding: padding ?? const EdgeInsets.all(24),
            child: child,
          ),
        ],
      ),
    );
  }
}
