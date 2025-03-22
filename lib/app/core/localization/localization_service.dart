import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:store_go/app/core/services/storage_service.dart';

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
      "nativeName": "العربية",
      "icon": Icons.language,
    },
    {
      "name": "French",
      "code": "fr",
      "nativeName": "Français",
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
    await context.setLocale(locale);
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
}
