import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileSetupController extends GetxController {
  final RxnString selectedGender = RxnString(null);
  final RxnString selectedAgeRange = RxnString(null);

  final List<String> ageRanges = [
    '13-17',
    '18-24',
    '25-34',
    '35-44',
    '45-54',
    '55-64',
    '65+'
  ];

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  void selectAgeRange(String? ageRange) {
    selectedAgeRange.value = ageRange;
  }

  bool get isFormValid => 
    selectedGender.value != null && selectedAgeRange.value != null;

  void finishUserProfileSetup() {
    if (isFormValid) {
      Get.snackbar(
        'Succès', 
        'Profil configuré',
        snackPosition: SnackPosition.BOTTOM,
      );
      // TODO: Add navigation to next screen
      // Get.to(() => NextScreen());
    } else {
      Get.snackbar(
        'Erreur', 
        'Veuillez remplir tous les champs',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}