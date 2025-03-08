import 'package:flutter/material.dart';

// Define color tokens in this file
class AppColors {
  // Base colors
  static const background = Color(0xFFFFFFFF);
  static const foreground = Color(0xFF000000);

  // Primary colors
  static const primary = Color(0xFF0070F3);
  static const primaryForeground = Color(0xFFFFFFFF);

  // Secondary colors
  static const secondary = Color(0xFFF5F5F5);
  static const secondaryForeground = Color(0xFF111111);

  // Accent colors
  static const accent = Color(0xFFEC4899);
  static const accentForeground = Color(0xFFFFFFFF);

  // Muted colors
  static const muted = Color(0xFFF5F5F5);
  static const mutedForeground = Color(0xFF737373);

  // Card colors
  static const card = Color(0xFFFFFFFF);
  static const cardForeground = Color(0xFF000000);

  // Border color
  static const border = Color(0xFFE5E5E5);

  // Input color
  static const input = Color(0xFFE5E5E5);

  // Destructive action colors
  static const destructive = Color(0xFFFF0000);
  static const destructiveForeground = Color(0xFFFFFFFF);
}

// Define color data structure
class AppColorsData {
  final Color background;
  final Color foreground;
  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color secondaryForeground;
  final Color accent;
  final Color accentForeground;
  final Color muted;
  final Color mutedForeground;
  final Color card;
  final Color cardForeground;
  final Color border;
  final Color input;
  final Color destructive;
  final Color destructiveForeground;

  const AppColorsData({
    required this.background,
    required this.foreground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.accent,
    required this.accentForeground,
    required this.muted,
    required this.mutedForeground,
    required this.card,
    required this.cardForeground,
    required this.border,
    required this.input,
    required this.destructive,
    required this.destructiveForeground,
  });
}
