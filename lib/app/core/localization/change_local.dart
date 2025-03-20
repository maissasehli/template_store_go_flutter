import 'dart:ui';
import 'package:get/get.dart';

class LocaleController extends GetxController {
  Locale? language;
  
  
  changeLang(String langcode) {
    Locale locale = Locale(langcode);
    Get.updateLocale(locale);
    language = locale;
    update();
  }
  
  @override
  void onInit() {
    
    
    super.onInit();
  }
}