import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/services/storage_service.dart';

class SettingsLanguageController extends GetxController {
  // Observable for current language
  final RxString currentLanguage = "en".obs;

  // Get languages from service
  List<Map<String, dynamic>> get languages => LocalizationService.languages;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  // Load saved language on startup
  Future<void> _loadSavedLanguage() async {
    final String savedLocale = await StorageService.getSavedLocale() ?? 'en';
    currentLanguage.value = savedLocale;
  }

  // Change app language
  Future<void> changeLanguage(BuildContext context, String langCode) async {
    final locale = Locale(langCode);

    // First save the language code
    await StorageService.saveLocale(langCode);

    // Change the locale using EasyLocalization
    await context.setLocale(locale);

    // Update GetX state
    currentLanguage.value = langCode;

    // Force GetX to update the UI
    Get.updateLocale(locale);
    update();
  }

  // Save language and return to settings
  void saveAndReturn() {
    // No need to do anything specific here since language changes
    // are applied immediately when the user taps a language option
    Get.back();
  }
}
