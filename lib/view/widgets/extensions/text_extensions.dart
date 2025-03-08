import 'package:flutter/material.dart';
import 'package:store_go/core/theme/typography_extension.dart';

extension StyledText on Widget {
  Widget heading1(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: style ?? typography?.h1 ?? const TextStyle(),
      child: this,
    );
  }

  Widget heading2(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: style ?? typography?.h2 ?? const TextStyle(),
      child: this,
    );
  }

  Widget heading3(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: style ?? typography?.h3 ?? const TextStyle(),
      child: this,
    );
  }

  Widget heading4(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: style ?? typography?.h4 ?? const TextStyle(),
      child: this,
    );
  }

  Widget heading5(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: style ?? typography?.h5 ?? const TextStyle(),
      child: this,
    );
  }

  Widget subtitle1(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: style ?? typography?.subtitle1 ?? const TextStyle(),
      child: this,
    );
  }

  Widget subtitle2(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: style ?? typography?.subtitle2 ?? const TextStyle(),
      child: this,
    );
  }

  Widget bodyLarge(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: style ?? typography?.bodyLarge ?? const TextStyle(),
      child: this,
    );
  }

  Widget body(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: style ?? typography?.bodyMedium ?? const TextStyle(),
      child: this,
    );
  }

  Widget bodySmall(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: style ?? typography?.bodySmall ?? const TextStyle(),
      child: this,
    );
  }

  Widget button(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: style ?? typography?.buttonText ?? const TextStyle(),
      child: this,
    );
  }

  Widget caption(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: style ?? typography?.caption ?? const TextStyle(),
      child: this,
    );
  }

  Widget overline(BuildContext context, {TextStyle? style}) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    return DefaultTextStyle(
      style: style ?? typography?.overline ?? const TextStyle(),
      child: this,
    );
  }

}
