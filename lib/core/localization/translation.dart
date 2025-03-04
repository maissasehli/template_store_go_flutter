import 'package:get/get.dart';

class MyTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "ar": {
          "Select Language": "اختر اللغة",
          "Continue": "متابعة",
          "English": "الإنجليزية",
          "Arabic": "العربية",
          "French": "الفرنسية",
        },
        "en": {
          "Select Language": "Select Language",
          "Continue": "Continue",
          "English": "English",
          "Arabic": "Arabic",
          "French": "French",
        },
        "fr": {
          "Select Language": "Choisir la langue",
          "Continue": "Continuer",
          "English": "Anglais",
          "Arabic": "Arabe",
          "French": "Français",
        },
      };
}