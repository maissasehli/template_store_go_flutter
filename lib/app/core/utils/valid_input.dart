import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';

String? validInput(String val, int min, int max, String type) {
  // Check if empty
  if (val.isEmpty) {
    return 'validation.empty'.translate();
  }

  // Check length
  if (val.length < min) {
    return 'validation.too_short'.translate().replaceAll(
      '{min}',
      min.toString(),
    );
  }
  if (val.length > max) {
    return 'validation.too_long'.translate().replaceAll(
      '{max}',
      max.toString(),
    );
  }

  // Validate according to type
  switch (type) {
    case "username":
      if (!GetUtils.isUsername(val)) {
        return 'validation.invalid_username'.translate();
      }
      break;

    case "email":
      if (!GetUtils.isEmail(val)) {
        return 'validation.invalid_email'.translate();
      }
      break;

    case "password":
      // We don't have a specific method in GetUtils for password validation
      // So we use isLengthGreaterOrEqual for minimum length
      if (!GetUtils.isLengthGreaterOrEqual(val, 8)) {
        return 'validation.password_too_short'.translate();
      }
      // Check if contains at least one letter and one number
      if (!val.contains(RegExp(r'[A-Za-z]')) ||
          !val.contains(RegExp(r'[0-9]'))) {
        return 'validation.password_requirement'.translate();
      }
      break;

    case "phone":
      if (!GetUtils.isPhoneNumber(val)) {
        return 'validation.invalid_phone'.translate();
      }
      // Check specifically for length of 8 digits
      if (val.length != 8) {
        return 'validation.phone_length'.translate();
      }
      break;
  }

  return null;
}
