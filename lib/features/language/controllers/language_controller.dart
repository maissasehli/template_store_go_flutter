import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/services/storage_service.dart';

class LanguageController extends GetxController {
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
    await LocalizationService.changeLanguage(context, langCode);
    currentLanguage.value = langCode;
    update();
  }

  // Save mark language as selected and navigate to onboarding page
  Future<void> onSaveLanguage(BuildContext context) async {
    await StorageService.markLanguageSelected();
    Get.toNamed(AppRoute.onBoarding);
  }
}
