import 'package:easy_localization/easy_localization.dart';

extension TranslationExtension on String {
  String translate() => this.tr();
  
  // Add support for translations with parameters
  String translateWithParam(Map<String, String> params) {
    String translated = this.tr();
    params.forEach((key, value) {
      translated = translated.replaceAll('{$key}', value);
    });
    return translated;
  }
}
