import 'package:easy_localization/easy_localization.dart';

extension TranslationExtension on String {
  String translate() => this.tr();
}
