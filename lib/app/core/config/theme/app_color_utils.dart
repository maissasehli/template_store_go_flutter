import 'package:flutter/material.dart';
import 'package:store_go/app/core/config/theme/app_color_extension.dart';

/// Enum that corresponds to all available colors in AppColorExtension
/// This provides type safety and better IDE completion when selecting colors
enum AppColorName {
  background,
  foreground,
  primary,
  primaryForeground,
  secondary,
  secondaryForeground,
  accent,
  accentForeground,
  muted,
  mutedForeground,
  card,
  cardForeground,
  border,
  input,
  destructive,
  destructiveForeground,
  productCard,
}

/// Extension methods for AppColorExtension to work with AppColorName enum
extension AppColorExtensionUtils on AppColorExtension {
  /// Gets a color from the theme extension based on the AppColorName enum
  ///
  /// This provides a type-safe way to access colors from the theme extension
  /// Example: `colorExtension.getColor(AppColorName.primary)`
  Color getColor(AppColorName name) {
    switch (name) {
      case AppColorName.background:
        return background;
      case AppColorName.foreground:
        return foreground;
      case AppColorName.primary:
        return primary;
      case AppColorName.primaryForeground:
        return primaryForeground;
      case AppColorName.secondary:
        return secondary;
      case AppColorName.secondaryForeground:
        return secondaryForeground;
      case AppColorName.accent:
        return accent;
      case AppColorName.accentForeground:
        return accentForeground;
      case AppColorName.muted:
        return muted;
      case AppColorName.mutedForeground:
        return mutedForeground;
      case AppColorName.card:
        return card;
      case AppColorName.cardForeground:
        return cardForeground;
      case AppColorName.border:
        return border;
      case AppColorName.input:
        return input;
      case AppColorName.destructive:
        return destructive;
      case AppColorName.destructiveForeground:
        return destructiveForeground;
      case AppColorName.productCard:
        return productCard;
    }
  }
}

/// Helper methods for working with theme colors
class AppColorUtils {
  /// Gets a color from the current theme using AppColorName
  ///
  /// This is a convenience method to get a color from the current theme
  /// using the AppColorName enum without having to manually extract
  /// the AppColorExtension.
  ///
  /// Example: `AppColorUtils.getThemeColor(context, AppColorName.primary)`
  static Color getThemeColor(BuildContext context, AppColorName name) {
    final extension = Theme.of(context).extension<AppColorExtension>();
    if (extension != null) {
      return extension.getColor(name);
    }

    // Fallback to theme's color scheme if extension not found
    switch (name) {
      case AppColorName.primary:
        return Theme.of(context).colorScheme.primary;
      case AppColorName.primaryForeground:
        return Theme.of(context).colorScheme.onPrimary;
      case AppColorName.secondary:
        return Theme.of(context).colorScheme.secondary;
      case AppColorName.secondaryForeground:
        return Theme.of(context).colorScheme.onSecondary;
      case AppColorName.background:
        return Theme.of(context).colorScheme.surface;
      case AppColorName.foreground:
        return Theme.of(context).colorScheme.onSurface;
      case AppColorName.destructive:
        return Theme.of(context).colorScheme.error;
      case AppColorName.destructiveForeground:
        return Theme.of(context).colorScheme.onError;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }
}
