import 'dart:ui';
import 'package:get/get.dart';
import 'package:store_go/core/services/services.dart';

class LocaleController extends GetxController {
  Locale? language;
  
  MyServices myServices = Get.find();
  
  changeLang(String langcode) {
    Locale locale = Locale(langcode);
    myServices.sharedPreferences.setString("lang", langcode);
    Get.updateLocale(locale);
    language = locale;
    update();
  }
  
  @override
  void onInit() {
    String? sharedPrefLang = myServices.sharedPreferences.getString("lang");
    if (sharedPrefLang == "ar") {
      language = const Locale("ar");
    } else if (sharedPrefLang == "en") {
      language = const Locale("en");
    } else if (sharedPrefLang == "fr") {
      language = const Locale("fr");
    } else {
      language = Locale(Get.deviceLocale!.languageCode);
    }
    
    super.onInit();
  }
}