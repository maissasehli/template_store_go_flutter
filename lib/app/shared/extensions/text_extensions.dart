import 'package:flutter/material.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/theme/app_typography_extension.dart';

extension StyledText on Widget {
  Widget heading1(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: LocalizationService.applyArabicFontIfNeeded(
        context,
        style ?? typography?.h1 ?? const TextStyle(),
      ),
      child: this,
    );
  }

  Widget heading2(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: LocalizationService.applyArabicFontIfNeeded(
        context,
        style ?? typography?.h2 ?? const TextStyle(),
      ),
      child: this,
    );
  }

  Widget heading3(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: LocalizationService.applyArabicFontIfNeeded(
        context,
        style ?? typography?.h3 ?? const TextStyle(),
      ),
      child: this,
    );
  }

  Widget heading4(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: LocalizationService.applyArabicFontIfNeeded(
        context,
        style ?? typography?.h4 ?? const TextStyle(),
      ),
      child: this,
    );
  }

  Widget heading5(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: LocalizationService.applyArabicFontIfNeeded(
        context,
        style ?? typography?.h5 ?? const TextStyle(),
      ),
      child: this,
    );
  }

  Widget subtitle1(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: LocalizationService.applyArabicFontIfNeeded(
        context,
        style ?? typography?.subtitle1 ?? const TextStyle(),
      ),
      child: this,
    );
  }

  Widget subtitle2(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: LocalizationService.applyArabicFontIfNeeded(
        context,
        style ?? typography?.subtitle2 ?? const TextStyle(),
      ),
      child: this,
    );
  }

  Widget bodyLarge(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: LocalizationService.applyArabicFontIfNeeded(
        context,
        style ?? typography?.bodyLarge ?? const TextStyle(),
      ),
      child: this,
    );
  }

  Widget body(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: LocalizationService.applyArabicFontIfNeeded(
        context,
        style ?? typography?.bodyMedium ?? const TextStyle(),
      ),
      child: this,
    );
  }

  Widget bodySmall(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: LocalizationService.applyArabicFontIfNeeded(
        context,
        style ?? typography?.bodySmall ?? const TextStyle(),
      ),
      child: this,
    );
  }

  Widget button(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: LocalizationService.applyArabicFontIfNeeded(
        context,
        style ?? typography?.buttonText ?? const TextStyle(),
      ),
      child: this,
    );
  }

  Widget caption(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: LocalizationService.applyArabicFontIfNeeded(
        context,
        style ?? typography?.caption ?? const TextStyle(),
      ),
      child: this,
    );
  }

  Widget overline(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: LocalizationService.applyArabicFontIfNeeded(
        context,
        style ?? typography?.overline ?? const TextStyle(),
      ),
      child: this,
    );
  }
}
