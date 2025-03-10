import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes.dart';
import 'package:store_go/core/services/auth_middleware.dart';

class ProfileSetupController extends GetxController {
  final RxnString selectedGender = RxnString(null);
  final RxnString selectedAgeRange = RxnString(null);
  final RxBool isLoading = false.obs;

  final List<String> ageRanges = [
    '13-17',
    '18-24',
    '25-34',
    '35-44',
    '45-54',
    '55-64',
    '65+',
  ];

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  void selectAgeRange(String? ageRange) {
    selectedAgeRange.value = ageRange;
  }

  bool get isFormValid =>
      selectedGender.value != null && selectedAgeRange.value != null;

  void finishUserProfileSetup() async {
    if (isFormValid) {
      isLoading.value = true;

      try {
        final authMiddlewareService = Get.find<AuthMiddlewareService>();
        await authMiddlewareService.saveUserProfile(
          selectedGender.value!,
          selectedAgeRange.value!,
        );

        Get.snackbar(
          'Succès',
          'Profil configuré avec succès',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed(AppRoute.home);
      } catch (e) {
        Get.snackbar(
          'Erreur',
          'Impossible de sauvegarder le profil',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
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
