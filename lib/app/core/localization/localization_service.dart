import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/localization/language_font_utility.dart';
import 'package:store_go/app/core/services/storage_service.dart';
import 'package:store_go/app/core/theme/app_typography.dart';

class LocalizationService {
  // Available languages
  static final List<Map<String, dynamic>> languages = [
    {
      "name": "English",
      "code": "en",
      "nativeName": "English",
      "icon": Icons.language,
    },
    {
      "name": "Arabic",
      "code": "ar",
      "nativeName": "???????",
      "icon": Icons.language,
    },
    {
      "name": "French",
      "code": "fr",
      "nativeName": "Fran�ais",
      "icon": Icons.language,
    },
  ];

  // Change app language
  static Future<void> changeLanguage(
    BuildContext context,
    String langCode,
  ) async {
    final locale = Locale(langCode);
    await StorageService.saveLocale(langCode);

    // The proper way to change locale with EasyLocalization
    await context.setLocale(locale);

    // This forces the entire app to rebuild with the new locale
    Get.updateLocale(locale);
  }

  // Check if current locale is RTL
  static bool isRtl(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }

  // Get text direction based on current locale
  static TextDirection getTextDirection(BuildContext context) {
    return isRtl(context) ? TextDirection.RTL : TextDirection.LTR;
  }

  // Get alignment based on locale (useful for certain layouts)
  static Alignment getStartAlignment(BuildContext context) {
    return isRtl(context) ? Alignment.centerRight : Alignment.centerLeft;
  }

  static Alignment getEndAlignment(BuildContext context) {
    return isRtl(context) ? Alignment.centerLeft : Alignment.centerRight;
  }

  // Get EdgeInsets that respect text direction
  static EdgeInsets getDirectionalEdgeInsets(
    BuildContext context,
    double start,
    double top,
    double end,
    double bottom,
  ) {
    return isRtl(context)
        ? EdgeInsets.fromLTRB(end, top, start, bottom)
        : EdgeInsets.fromLTRB(start, top, end, bottom);
  }

  // Get the appropriate font family based on the current locale
  static String getFontFamilyForContext(BuildContext context) {
    return LanguageFontUtility.getFontFamilyForLanguage(
      context.locale.languageCode,
    );
  }

  // Apply the appropriate font to a text style based on context
  static TextStyle getLocalizedTextStyle(
    BuildContext context,
    TextStyle baseStyle,
  ) {
    return LanguageFontUtility.getTextStyle(
      context: context,
      baseStyle: baseStyle,
    );
  }

  // Override the app theme's typography for Arabic text
  static TextStyle applyArabicFontIfNeeded(
    BuildContext context,
    TextStyle style,
  ) {
    // If the current locale is Arabic, use NotoKufiArabic font
    if (context.locale.languageCode == 'ar') {
      return style.copyWith(fontFamily: AppTypography.arabicFont);
    }
    return style;
  }

  // Create a themed TextStyle that will apply the correct font for each language
  static TextStyle createThemedTextStyle(TextStyle baseStyle) {
    // This will be applied through themes and doesn't have direct access to BuildContext
    // The font will be properly set when used in widgets via MaterialLocalizations
    return baseStyle.copyWith(
      fontFamily: AppTypography.primaryFont, // Default font
      // Using fontFamilyFallback ensures Arabic text will find NotoKufiArabic when needed
      fontFamilyFallback: [AppTypography.arabicFont],
    );
  }
}
