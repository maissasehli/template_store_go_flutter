import 'package:get/get_utils/src/get_utils/get_utils.dart';

String? validInput(String val, int min, int max, String type) {
  // Vérification si vide
  if (val.isEmpty) {
    return "Can't be empty";
  }

  // Vérification de la longueur
  if (val.length < min) {
    return "Can't be less than $min characters";
  }
  if (val.length > max) {
    return "Can't be more than $max characters";
  }

  // Validation selon le type
  switch (type) {
    case "username":
      if (!GetUtils.isUsername(val)) {
        return "Username can only contain letters, numbers and underscore";
      }
      break;

    case "email":
      if (!GetUtils.isEmail(val)) {
        return "Not a valid email";
      }
      break;

    case "password":
      // GetUtils n'a pas de méthode spécifique pour la validation de mot de passe
      // Nous utilisons donc isLengthGreaterOrEqual pour la longueur minimale
      if (!GetUtils.isLengthGreaterOrEqual(val, 8)) {
        return "Password must be at least 8 characters";
      }
      // Vérifie si contient au moins une lettre et un chiffre
      if (!val.contains(RegExp(r'[A-Za-z]')) || !val.contains(RegExp(r'[0-9]'))) {
        return "Password must contain both letters and numbers";
      }
      break;

    case "phone":
      if (!GetUtils.isPhoneNumber(val)) {
        return "Not a valid phone number";
      }
      // Vérifie spécifiquement la longueur de 8 chiffres
      if (val.length != 8) {
        return "Phone number must be 8 digits";
      }
      break;
  }

  return null;
}