import 'package:flutter/material.dart';

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
  final Color productCard;

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
    required this.productCard,
  });
}
