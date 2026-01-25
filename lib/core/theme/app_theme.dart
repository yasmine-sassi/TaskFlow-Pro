import 'package:flutter/material.dart';

/// App theme configuration matching the React prototype design system
/// Colors extracted from tailwind.config.ts and index.css
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // ==================== COLOR PALETTE ====================

  // Base colors (Light Mode)
  static const Color background = Color(0xFFF8FAFB); // hsl(210 20% 98%)
  static const Color foreground = Color(0xFF1A202C); // hsl(222 47% 11%)

  // Card/Surface
  static const Color card = Color(0xFFFFFFFF); // hsl(0 0% 100%)
  static const Color cardForeground = Color(0xFF1A202C);

  // Primary - Indigo
  static const Color primary = Color(0xFF6366F1); // hsl(239 84% 67%)
  static const Color primaryForeground = Color(0xFFFFFFFF);

  // Secondary
  static const Color secondary = Color(0xFFF1F5F9); // hsl(210 40% 96%)
  static const Color secondaryForeground = Color(0xFF1A202C);

  // Muted
  static const Color muted = Color(0xFFF1F5F9);
  static const Color mutedForeground = Color(0xFF64748B); // hsl(215 16% 47%)

  // Accent
  static const Color accent = Color(0xFFF1F5F9);
  static const Color accentForeground = Color(0xFF1A202C);

  // Destructive
  static const Color destructive = Color(0xFFEF4444); // hsl(0 84% 60%)
  static const Color destructiveForeground = Color(0xFFFFFFFF);

  // Border & Input
  static const Color border = Color(0xFFE2E8F0); // hsl(214 32% 91%)
  static const Color inputBorder = Color(0xFFE2E8F0);
  static const Color ring = Color(0xFF6366F1);

  // Sidebar - Dark Slate
  static const Color sidebarBackground = Color(0xFF1A202C); // hsl(222 47% 11%)
  static const Color sidebarForeground = Color(0xFFF8FAFB);
  static const Color sidebarMuted = Color(0xFF2D3748); // hsl(215 28% 17%)
  static const Color sidebarMutedForeground =
      Color(0xFF94A3B8); // hsl(215 20% 65%)
  static const Color sidebarAccent = Color(0xFF6366F1);
  static const Color sidebarAccentForeground = Color(0xFFFFFFFF);
  static const Color sidebarBorder = Color(0xFF2D3748);
  static const Color sidebarPrimary = Color(0xFF6366F1);

  // Status Colors
  static const Color statusTodo = Color(0xFF64748B);
  static const Color statusTodoBg = Color(0xFFF1F5F9);
  static const Color statusInProgress = Color(0xFF3B82F6); // hsl(217 91% 60%)
  static const Color statusInProgressBg = Color(0xFFDCEEFE); // hsl(214 95% 93%)
  static const Color statusDone = Color(0xFF10B981); // hsl(142 71% 45%)
  static const Color statusDoneBg = Color(0xFFD1FAE5); // hsl(143 76% 93%)

  // Priority Colors
  static const Color priorityLow = Color(0xFF10B981);
  static const Color priorityLowBg = Color(0xFFD1FAE5);
  static const Color priorityMedium = Color(0xFFF59E0B); // hsl(45 93% 47%)
  static const Color priorityMediumBg = Color(0xFFFEF3C7); // hsl(48 96% 89%)
  static const Color priorityHigh = Color(0xFFEF4444);
  static const Color priorityHighBg = Color(0xFFFEE2E2); // hsl(0 93% 94%)

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF1A202C);
  static const Color darkForeground = Color(0xFFF8FAFB);
  static const Color darkCard = Color(0xFF2D3748); // hsl(217 33% 17%)
  static const Color darkCardForeground = Color(0xFFF8FAFB);
  static const Color darkSecondary = Color(0xFF2D3748);
  static const Color darkMuted = Color(0xFF2D3748);
  static const Color darkBorder = Color(0xFF374151);

  // ==================== BORDER RADIUS ====================
  static const double radiusLg = 10.0; // var(--radius) = 0.625rem = 10px
  static const double radiusMd = 8.0;
  static const double radiusSm = 6.0;

  // ==================== TYPOGRAPHY ====================
  static const String fontFamily = 'Inter';

  static const TextStyle heading1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: -0.2,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: mutedForeground,
  );

  // ==================== SPACING ====================
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacing2xl = 48.0;

  // ==================== LIGHT THEME ====================
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: fontFamily,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: primaryForeground,
        secondary: secondary,
        onSecondary: secondaryForeground,
        error: destructive,
        onError: destructiveForeground,
        surface: card,
        onSurface: cardForeground,
      ),

      scaffoldBackgroundColor: background,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: card,
        foregroundColor: foreground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
        iconTheme: IconThemeData(color: foreground),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: border, width: 1),
        ),
        margin: const EdgeInsets.all(0),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: ring, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: destructive),
        ),
        labelStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: foreground,
        ),
        hintStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          color: mutedForeground.withValues(alpha: 0.6),
        ),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: primaryForeground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: foreground,
          side: const BorderSide(color: border),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: foreground,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: heading1,
        displayMedium: heading2,
        displaySmall: heading3,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: label,
        labelMedium: label,
        labelSmall: caption,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: foreground,
        size: 20,
      ),
    );
  }

  // ==================== DARK THEME ====================
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: fontFamily,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        onPrimary: primaryForeground,
        secondary: darkSecondary,
        onSecondary: darkForeground,
        error: destructive,
        onError: destructiveForeground,
        surface: darkCard,
        onSurface: darkCardForeground,
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkCard,
        foregroundColor: darkForeground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkForeground,
        ),
        iconTheme: IconThemeData(color: darkForeground),
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
        margin: const EdgeInsets.all(0),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: ring, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: destructive),
        ),
        labelStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: darkForeground,
        ),
        hintStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          color: mutedForeground.withValues(alpha: 0.6),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: primaryForeground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkForeground,
          side: const BorderSide(color: darkBorder),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkForeground,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: heading1.copyWith(color: darkForeground),
        displayMedium: heading2.copyWith(color: darkForeground),
        displaySmall: heading3.copyWith(color: darkForeground),
        bodyLarge: bodyLarge.copyWith(color: darkForeground),
        bodyMedium: bodyMedium.copyWith(color: darkForeground),
        bodySmall: bodySmall.copyWith(color: darkForeground),
        labelLarge: label.copyWith(color: darkForeground),
        labelMedium: label.copyWith(color: darkForeground),
        labelSmall: caption.copyWith(color: mutedForeground),
      ),
      dividerTheme: const DividerThemeData(
        color: darkBorder,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(
        color: darkForeground,
        size: 20,
      ),
    );
  }
}
