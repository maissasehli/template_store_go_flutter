import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/app/core/services/api_client.dart';

class ProfileSetupController extends GetxController {
  final RxnString selectedGender = RxnString(null);
  final RxnString selectedAgeRange = RxnString(null);
  final RxBool isLoading = false.obs;
  final ApiClient api = ApiClient();

  // Updated age ranges to match API expectations
  final List<String> ageRanges = [
    '13-18',
    '19-25',
    '26-35',
    '36-45',
    '46-60',
    '60+',
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
      final logger = Logger();

      try {
        logger.i(
          'Updating user profile: Gender=${selectedGender.value}, Age Range=${selectedAgeRange.value}',
        );

        // Get user ID from secure storage
        final secureStorage = const FlutterSecureStorage();
        final userId = await secureStorage.read(key: 'user_id');

        if (userId == null) {
          logger.e('User ID not found in secure storage');
          Get.snackbar(
            'Error',
            'User ID not found. Please log in again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        // Create data object with snake_case keys to match API expectations
        final data = {
          'gender': selectedGender.value,
          'age_range':
              selectedAgeRange.value, // Changed from camelCase to snake_case
        };

        logger.i('Sending PUT request to /users/$userId');

        // Update the API endpoint to match the server route
        final response = await api.put('/users/$userId', data: data);

        logger.i('Profile update successful: ${response.statusCode}');

        // Show success message
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to home screen
        Get.offAllNamed(AppRoute.home);
      } catch (e) {
        logger.e('Error updating profile: $e');

        // Extract error message when possible
        String errorMessage = 'Unable to update profile';
        if (e is dio.DioException && e.response != null) {
          if (e.response!.data is Map && e.response!.data['message'] != null) {
            errorMessage = e.response!.data['message'];
            logger.e('Error message: $errorMessage');
          }
        }

        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    } else {
      Logger().w(
        'Form validation failed: Gender=${selectedGender.value}, Age Range=${selectedAgeRange.value}',
      );
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
