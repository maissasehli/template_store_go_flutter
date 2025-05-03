import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_color_utils.dart';

class AppColors {
  static Color background(BuildContext context) =>
      AppColorUtils.getThemeColor(context, AppColorName.background);

  static Color foreground(BuildContext context) =>
      AppColorUtils.getThemeColor(context, AppColorName.foreground);

  static Color primary(BuildContext context) =>
      AppColorUtils.getThemeColor(context, AppColorName.primary);

  static Color primaryForeground(BuildContext context) =>
      AppColorUtils.getThemeColor(context, AppColorName.primaryForeground);

  static Color secondary(BuildContext context) =>
      AppColorUtils.getThemeColor(context, AppColorName.secondary);

  static Color secondaryForeground(BuildContext context) =>
      AppColorUtils.getThemeColor(context, AppColorName.secondaryForeground);

  static Color accent(BuildContext context) =>
      AppColorUtils.getThemeColor(context, AppColorName.accent);

  static Color accentForeground(BuildContext context) =>
      AppColorUtils.getThemeColor(context, AppColorName.accentForeground);

  static Color muted(BuildContext context) =>
      AppColorUtils.getThemeColor(context, AppColorName.muted);

  static Color mutedForeground(BuildContext context) =>
      AppColorUtils.getThemeColor(context, AppColorName.mutedForeground);

  static Color card(BuildContext context) =>
      AppColorUtils.getThemeColor(context, AppColorName.card);

  static Color cardForeground(BuildContext context) =>
      AppColorUtils.getThemeColor(context, AppColorName.cardForeground);

  static Color border(BuildContext context) =>
      AppColorUtils.getThemeColor(context, AppColorName.border);

  static Color input(BuildContext context) =>
      AppColorUtils.getThemeColor(context, AppColorName.input);

  static Color inputForeground(BuildContext context) =>
      AppColorUtils.getThemeColor(context, AppColorName.inputForeground);

  static Color destructive(BuildContext context) =>
      AppColorUtils.getThemeColor(context, AppColorName.destructive);

  static Color destructiveForeground(BuildContext context) =>
      AppColorUtils.getThemeColor(context, AppColorName.destructiveForeground);

  static Color productCard(BuildContext context) =>
      AppColorUtils.getThemeColor(context, AppColorName.productCard);
}
