import 'package:flutter/material.dart';

class AppTheme {
  // ============================
  // COLOR PALETTE - MAIN COLORS
  // ============================

  // Light Theme Colors
  static const Color lightPrimary =
      Color(0xFF1A1A1A); // Espresso Black - Primary Button
  static const Color lightSecondary =
      Color(0xFF4E6E58); // Olive Green - AppBar/Header
  static const Color lightAccent = Color(0xFF9CCC9C); // Sage Green - Accent
  static const Color lightSurface = Color(0xFFFFFFFF); // Pure White - Card
  static const Color lightBackground =
      Color(0xFFF5F1EC); // Latte Cream - Background
  static const Color lightError = Color(0xFFF44336);
  static const Color lightSuccess = Color(0xFF4CAF50);
  static const Color lightWarning = Color(0xFFFF9800);
  static const Color lightDivider = Color(0xFFD7CCC8); // Soft Brown - Divider

  // Dark Theme Colors
  static const Color darkPrimary =
      Color(0xFF4E6E58); // Olive Green - Primary Button
  static const Color darkSecondary =
      Color(0xFF8B4513); // Dark Brown - AppBar/Header
  static const Color darkAccent = Color(0xFF9CCC9C); // Sage Green - Accent/CTA
  static const Color darkSurface = Color(0xFF1E1E1E); // Dark Grey - Card
  static const Color darkBackground =
      Color(0xFF1A1A1A); // Espresso Black - Background
  static const Color darkError = Color(0xFFCF6679);
  static const Color darkSuccess = Color(0xFF03DAC6);
  static const Color darkWarning = Color(0xFFFFB74D);

  // Neutral Colors
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ============================
  // TEXT STYLES
  // ============================

  // Headers
  static TextStyle header1(bool isDarkMode) => TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        fontFamily: 'Montserrat',
        color: isDarkMode
            ? const Color(0xFFEAEAEA)
            : const Color(0xFF2B2B2B), // Text Utama
        letterSpacing: 2,
      );

  static TextStyle header2(bool isDarkMode) => TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        fontFamily: 'Montserrat',
        color: isDarkMode
            ? const Color(0xFFEAEAEA)
            : const Color(0xFF2B2B2B), // Text Utama
        letterSpacing: 1.5,
      );

  static TextStyle header3(bool isDarkMode) => TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        fontFamily: 'Montserrat',
        color: isDarkMode
            ? const Color(0xFFEAEAEA)
            : const Color(0xFF2B2B2B), // Text Utama
        letterSpacing: 1,
      );

  // Title Styles
  static TextStyle titleLarge(bool isDarkMode) => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: isDarkMode
            ? const Color(0xFFEAEAEA)
            : const Color(0xFF2B2B2B), // Text Utama
      );

  static TextStyle titleMedium(bool isDarkMode) => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDarkMode
            ? const Color(0xFFEAEAEA)
            : const Color(0xFF2B2B2B), // Text Utama
      );

  static TextStyle titleSmall(bool isDarkMode) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDarkMode
            ? const Color(0xFFEAEAEA)
            : const Color(0xFF2B2B2B), // Text Utama
      );

  // Body Text
  static TextStyle bodyLarge(bool isDarkMode) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: isDarkMode
            ? const Color(0xFFBDBDBD)
            : const Color(0xFF2B2B2B), // Text Sekunder / Text Utama
      );

  static TextStyle bodyMedium(bool isDarkMode) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: isDarkMode
            ? const Color(0xFFBDBDBD)
            : const Color(0xFF2B2B2B), // Text Sekunder / Text Utama
      );

  static TextStyle bodySmall(bool isDarkMode) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: isDarkMode
            ? const Color(0xFFBDBDBD)
            : const Color(0xFF2B2B2B), // Text Sekunder / Text Utama
      );

  // Button Text
  static TextStyle buttonTextLarge(bool isDarkMode) => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: isDarkMode ? Colors.black : Colors.white,
      );

  static TextStyle buttonTextMedium(bool isDarkMode) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDarkMode ? Colors.black : Colors.white,
      );

  static TextStyle buttonTextSmall(bool isDarkMode) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDarkMode ? Colors.black : Colors.white,
      );

  // Caption & Overline
  static TextStyle caption(bool isDarkMode) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: isDarkMode ? grey500 : grey500,
      );

  static TextStyle overline(bool isDarkMode) => TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: isDarkMode ? grey500 : grey500,
        letterSpacing: 1.5,
      );

  // ============================
  // THEME DATA
  // ============================

  static ThemeData get lightTheme {
    final base = ThemeData.light();

    return base.copyWith(
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        secondary: lightSecondary,
        surface: lightSurface,
        background: lightBackground,
        error: lightError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: grey900,
        onBackground: grey900,
        onError: Colors.white,
      ),

      // Scaffold & Background
      scaffoldBackgroundColor: lightBackground,
      canvasColor: lightBackground,

      // App Bar
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          fontFamily: 'Montserrat',
          color: Colors.white,
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        backgroundColor: Colors.white,
        elevation: 20,
        selectedItemColor: lightPrimary,
        unselectedItemColor: grey500,
        selectedLabelStyle:
            const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      ),

      // Elevated Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: lightPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: buttonTextMedium(false),
          elevation: 4,
        ),
      ),

      // Outlined Buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightPrimary,
          side: const BorderSide(color: lightPrimary, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: buttonTextMedium(false),
        ),
      ),

      // Text Buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightPrimary,
          textStyle: bodyMedium(false).copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: grey50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: grey200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightError, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: bodyMedium(false).copyWith(color: grey400),
        labelStyle: bodyMedium(false).copyWith(color: grey600),
        floatingLabelStyle: bodyMedium(false).copyWith(color: lightPrimary),
      ),

      // Cards
      cardTheme: base.cardTheme.copyWith(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),

      // Dialogs
      dialogTheme: base.dialogTheme.copyWith(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
      ),

      // Chips
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: grey100,
        selectedColor: lightPrimary,
        labelStyle: bodyMedium(false),
        secondaryLabelStyle: bodyMedium(false).copyWith(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Icons
      iconTheme: const IconThemeData(
        color: lightPrimary,
      ),

      // Text Theme
      textTheme: base.textTheme.copyWith(
        displayLarge: header1(false),
        displayMedium: header2(false),
        displaySmall: header3(false),
        headlineMedium: titleLarge(false),
        headlineSmall: titleMedium(false),
        titleLarge: titleSmall(false),
        bodyLarge: bodyLarge(false),
        bodyMedium: bodyMedium(false),
        bodySmall: bodySmall(false),
        labelLarge: buttonTextMedium(false),
        labelMedium: buttonTextSmall(false),
        labelSmall: overline(false),
      ),

      // Divider
      dividerTheme: base.dividerTheme.copyWith(
        color: lightDivider,
        thickness: 1,
        space: 1,
      ),

      // Misc
      useMaterial3: false,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark();

    return base.copyWith(
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        secondary: darkSecondary,
        surface: darkSurface,
        background: darkBackground,
        error: darkError,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.black,
      ),

      // Scaffold & Background
      scaffoldBackgroundColor: darkBackground,
      canvasColor: darkBackground,

      // App Bar
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          fontFamily: 'Montserrat',
          color: Colors.white,
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        backgroundColor: darkSurface,
        elevation: 20,
        selectedItemColor: darkPrimary,
        unselectedItemColor: grey400,
        selectedLabelStyle:
            const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      ),

      // Elevated Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: darkPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: buttonTextMedium(true),
          elevation: 4,
        ),
      ),

      // Outlined Buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkPrimary,
          side: const BorderSide(color: darkPrimary, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: buttonTextMedium(true),
        ),
      ),

      // Text Buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkPrimary,
          textStyle: bodyMedium(true).copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: grey800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: grey700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkError, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: bodyMedium(true).copyWith(color: grey500),
        labelStyle: bodyMedium(true).copyWith(color: grey400),
        floatingLabelStyle: bodyMedium(true).copyWith(color: darkPrimary),
      ),

      // Cards
      cardTheme: base.cardTheme.copyWith(
        color: darkSurface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),

      // Dialogs
      dialogTheme: base.dialogTheme.copyWith(
        backgroundColor: darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
      ),

      // Chips
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: grey800,
        selectedColor: darkPrimary,
        labelStyle: bodyMedium(true),
        secondaryLabelStyle: bodyMedium(true).copyWith(color: Colors.black),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Icons
      iconTheme: const IconThemeData(
        color: darkPrimary,
      ),

      // Text Theme
      textTheme: base.textTheme.copyWith(
        displayLarge: header1(true),
        displayMedium: header2(true),
        displaySmall: header3(true),
        headlineMedium: titleLarge(true),
        headlineSmall: titleMedium(true),
        titleLarge: titleSmall(true),
        bodyLarge: bodyLarge(true),
        bodyMedium: bodyMedium(true),
        bodySmall: bodySmall(true),
        labelLarge: buttonTextMedium(true),
        labelMedium: buttonTextSmall(true),
        labelSmall: overline(true),
      ),

      // Divider
      dividerTheme: base.dividerTheme.copyWith(
        color: grey800,
        thickness: 1,
        space: 1,
      ),

      // Misc
      useMaterial3: false,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  // ============================
  // SHADOWS & EFFECTS
  // ============================

  // Light Theme Shadows
  static List<BoxShadow> lightCardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 15,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> lightElevatedShadow = [
    BoxShadow(
      color: lightPrimary.withOpacity(0.2),
      blurRadius: 15,
      spreadRadius: 3,
      offset: const Offset(0, 4),
    ),
  ];

  // Dark Theme Shadows
  static List<BoxShadow> darkCardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.4),
      blurRadius: 15,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> darkElevatedShadow = [
    BoxShadow(
      color: darkPrimary.withOpacity(0.3),
      blurRadius: 15,
      spreadRadius: 3,
      offset: const Offset(0, 4),
    ),
  ];

  // Button Shadows
  static List<BoxShadow> getButtonShadow(bool isDarkMode) => [
        BoxShadow(
          color: isDarkMode
              ? darkPrimary.withOpacity(0.4)
              : lightPrimary.withOpacity(0.3),
          blurRadius: 10,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
      ];

  // ============================
  // BORDER RADIUS
  // ============================

  static BorderRadius borderRadiusSmall = BorderRadius.circular(8);
  static BorderRadius borderRadiusMedium = BorderRadius.circular(12);
  static BorderRadius borderRadiusLarge = BorderRadius.circular(16);
  static BorderRadius borderRadiusXLarge = BorderRadius.circular(20);
  static BorderRadius borderRadiusCircle = BorderRadius.circular(999);
}
