import 'dart:io';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/profile/repositories/profile_repository.dart';
import 'package:store_go/features/profile/models/user_model.dart';

class ProfileController extends GetxController {
  final ProfileRepository _repository;
  final logger = Logger();

  // Observable variables
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Constructor with dependency injection
  ProfileController({required ProfileRepository repository})
    : _repository = repository;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentUser();
  }

  // Fetch current user data
  Future<void> fetchCurrentUser() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final userData = await _repository.getCurrentUser();
      user.value = userData;
      logger.d('User data fetched successfully: ${user.value?.name}');
      logger.d('User avatar field: ${user.value?.avatar}');
      logger.d('Full user data: ${user.value?.toJson()}');
    } catch (e) {
      logger.e('Error fetching user: $e');
      hasError.value = true;
      errorMessage.value = 'Failed to load profile. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // Update profile
  Future<void> updateProfile(Map<String, dynamic> userData) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final updatedUser = await _repository.updateProfile(userData);
      user.value = updatedUser;
      logger.d('Profile updated successfully');

      // Notify UI that user data has been updated
      update();

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.secondary,
        colorText: Get.theme.colorScheme.onSecondary,
      );
    } catch (e) {
      logger.e('Error updating profile: $e');
      hasError.value = true;
      errorMessage.value = 'Failed to update profile. Please try again.';

      Get.snackbar(
        'Error',
        'Failed to update profile. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Upload avatar
  Future<void> uploadAvatar(File imageFile) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final updatedUser = await _repository.uploadAvatar(imageFile);
      user.value = updatedUser;
      logger.d('Avatar uploaded successfully');

      // Notify UI that user data has been updated
      update();

      Get.snackbar(
        'Success',
        'Avatar uploaded successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.secondary,
        colorText: Get.theme.colorScheme.onSecondary,
      );
    } catch (e) {
      logger.e('Error uploading avatar: $e');
      hasError.value = true;
      errorMessage.value = 'Failed to upload avatar. Please try again.';

      Get.snackbar(
        'Error',
        'Failed to upload avatar. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
