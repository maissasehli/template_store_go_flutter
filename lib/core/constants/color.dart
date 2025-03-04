// theme_constants.dart
// This file contains all UI-related constants to maintain consistent branding throughout the app

import 'package:flutter/material.dart';

class AppColor {
  // Primary brand colors
  static const Color primaryColor = Color(0xFFFFFFFF); // Main brand color
  static const Color secondaryColor = Color(0xFF191919); // Accent color
  static const Color backgroundColor = Color(0xFF000000); // Background color

  // Text colors
  static const Color textPrimaryColor = Color(0xFF000000); // Primary text
  static const Color textSecondaryColor = Color(0xFFC2C2C2); // Secondary text
  static const Color textLightColor =
      Color(0xFF000000); // Light text (for dark backgrounds)

  // input fields
  static const Color inputBackgroundColor = Color.fromARGB(255, 241, 241, 241);
  static const Color inputTextColor = Color.fromARGB(255, 129, 129, 129);
  static const double globalBorderRadius = 50;
  // Success, warning, error colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFE53935);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF191919), Color(0xFF000000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text styles
  // Heading styles - large
  static const TextStyle headingLarge = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w900,
    color: textPrimaryColor,
    fontFamily: 'RedditSans',
  );

  // Heading styles - medium
  static const TextStyle headingMedium = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
    fontFamily: 'RedditSans',
  );

  // Heading styles - small
  static const TextStyle headingSmall = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
    fontFamily: 'RedditSans',
  );

  // Body styles - large
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16.0,
    color: textPrimaryColor,
    fontFamily: 'RedditSans',
  );

  // Body styles - medium
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14.0,
    color: textPrimaryColor,
    fontFamily: 'RedditSans',
  );

  // Body styles - small
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12.0,
    color: textSecondaryColor,
    fontFamily: 'RedditSans',
  );

  // Spacing constants
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Shadow
  static const List<BoxShadow> lightShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
}
class AppColorExtension {
  // Language Screen Specific Colors
  static const Color languageCardBackground = Color(0xFFF5F5F5);
  static const Color languageCardSelectedBorder = Color(0xFF000000);
  static const Color languageCardUnselectedBorder = Colors.transparent;
  
  static const Color languageCardTextPrimary = Color(0xFF000000);
  static const Color languageCardTextSecondary = Color(0xFF666666);
  
  static const Color languageContinueButtonBackground = Color(0xFF000000);
  static const Color languageContinueButtonText = Color(0xFFFFFFFF);
  
  static const Color languageIconBackground = Color(0xFFE0E0E0);
  static const Color languageIconForeground = Color(0xFF000000);
}
