import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static late SharedPreferences prefs;

  // Storage keys
  static const String hasSeenOnboardingKey = 'has_seen_onboarding';
  static const String hasSelectedLanguageKey = 'has_selected_language';
  static const String localeKey = 'app_locale';

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    Get.put<StorageService>(StorageService(), permanent: true);
  }

  // Helper methods for app state
  static Future<bool> hasSeenOnboarding() async {
    return prefs.getBool(hasSeenOnboardingKey) ?? false;
  }

  static Future<bool> hasSelectedLanguage() async {
    return prefs.getBool(hasSelectedLanguageKey) ?? false;
  }

  static Future<void> markOnboardingComplete() async {
    await prefs.setBool(hasSeenOnboardingKey, true);
  }

  static Future<void> markLanguageSelected() async {
    await prefs.setBool(hasSelectedLanguageKey, true);
  }

  // Reset app to first-time state
  static Future<void> resetAppState() async {
    await StorageService.prefs.setBool(hasSeenOnboardingKey, false);
    await StorageService.prefs.setBool(hasSelectedLanguageKey, false);
    // Be careful not to clear other important user data
  }

  static Future<String?> getSavedLocale() async {
    return prefs.getString(localeKey);
  }

  static Future<void> saveLocale(String locale) async {
    await prefs.setString(localeKey, locale);
  }

  // Load the saved locale
  static Future<void> loadSavedLocale(BuildContext context) async {
    final String? savedLocale = await StorageService.getSavedLocale();
    if (savedLocale != null && context.mounted) {
      await context.setLocale(Locale(savedLocale));
    }
  }
}
