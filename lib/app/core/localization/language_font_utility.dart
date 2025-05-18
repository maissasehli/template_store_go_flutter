import 'package:flutter/material.dart';

class LanguageFontUtility {
  /// Returns the appropriate font family based on the language code
  static String getFontFamilyForLanguage(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return 'NotoKufiArabic';
      default:
        return 'Poppins'; // Default font family
    }
  }

  /// Get the appropriate font family based on the current locale
  static String getFontFamilyForLocale(Locale locale) {
    return getFontFamilyForLanguage(locale.languageCode);
  }

  /// Apply the appropriate font family to a TextStyle based on language code
  static TextStyle applyFontToStyle(TextStyle style, String languageCode) {
    return style.copyWith(fontFamily: getFontFamilyForLanguage(languageCode));
  }

  /// Apply the appropriate font family to a TextStyle based on locale
  static TextStyle applyFontToStyleWithLocale(TextStyle style, Locale locale) {
    return applyFontToStyle(style, locale.languageCode);
  }

  /// Get text style with the appropriate font family
  static TextStyle getTextStyle({
    required BuildContext context,
    required TextStyle baseStyle,
    String? languageCode,
  }) {
    final currentLanguageCode =
        languageCode ?? Localizations.localeOf(context).languageCode;
    return applyFontToStyle(baseStyle, currentLanguageCode);
  }
}
