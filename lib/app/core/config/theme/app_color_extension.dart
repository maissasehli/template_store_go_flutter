import 'package:flutter/material.dart';
import 'package:store_go/app/core/config/theme/app_colors_data.dart';

class AppColorExtension extends ThemeExtension<AppColorExtension> {
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
  AppColorExtension({
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

  @override
  ThemeExtension<AppColorExtension> copyWith({
    Color? background,
    Color? foreground,
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? accent,
    Color? accentForeground,
    Color? muted,
    Color? mutedForeground,
    Color? card,
    Color? cardForeground,
    Color? border,
    Color? input,
    Color? destructive,
    Color? destructiveForeground,
    Color? productCard,
  }) {
    return AppColorExtension(
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      accent: accent ?? this.accent,
      accentForeground: accentForeground ?? this.accentForeground,
      muted: muted ?? this.muted,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      card: card ?? this.card,
      cardForeground: cardForeground ?? this.cardForeground,
      border: border ?? this.border,
      input: input ?? this.input,
      destructive: destructive ?? this.destructive,
      destructiveForeground:
          destructiveForeground ?? this.destructiveForeground,
      productCard: productCard ?? this.productCard,
    );
  }

  @override
  ThemeExtension<AppColorExtension> lerp(
    covariant ThemeExtension<AppColorExtension>? other,
    double t,
  ) {
    if (other is! AppColorExtension) {
      return this;
    }

    return AppColorExtension(
      background: Color.lerp(background, other.background, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryForeground:
          Color.lerp(primaryForeground, other.primaryForeground, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryForeground:
          Color.lerp(secondaryForeground, other.secondaryForeground, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentForeground:
          Color.lerp(accentForeground, other.accentForeground, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      mutedForeground: Color.lerp(mutedForeground, other.mutedForeground, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardForeground: Color.lerp(cardForeground, other.cardForeground, t)!,
      border: Color.lerp(border, other.border, t)!,
      input: Color.lerp(input, other.input, t)!,
      destructive: Color.lerp(destructive, other.destructive, t)!,
      destructiveForeground:
          Color.lerp(destructiveForeground, other.destructiveForeground, t)!,
      productCard: Color.lerp(productCard, other.productCard, t)!,
    );
  }

  // Helper method to create from AppColorsData
  static AppColorExtension fromAppColorsData(AppColorsData colors) {
    return AppColorExtension(
      background: colors.background,
      foreground: colors.foreground,
      primary: colors.primary,
      primaryForeground: colors.primaryForeground,
      secondary: colors.secondary,
      secondaryForeground: colors.secondaryForeground,
      accent: colors.accent,
      accentForeground: colors.accentForeground,
      muted: colors.muted,
      mutedForeground: colors.mutedForeground,
      card: colors.card,
      cardForeground: colors.cardForeground,
      border: colors.border,
      input: colors.input,
      destructive: colors.destructive,
      destructiveForeground: colors.destructiveForeground,
      productCard: colors.productCard,
    );
  }
  
}

