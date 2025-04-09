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
      logger.i('User data fetched successfully: ${user.value?.name}');
    } catch (e) {
      logger.e('Error fetching user: $e');
      hasError.value = true;
      errorMessage.value = 'Failed to load profile. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh user data
  Future<void> refreshUserData() async {
    await fetchCurrentUser();
  }

  // Update profile
  Future<void> updateProfile(Map<String, dynamic> userData) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final updatedUser = await _repository.updateProfile(userData);
      user.value = updatedUser;
      logger.i('Profile updated successfully');
    } catch (e) {
      logger.e('Error updating profile: $e');
      hasError.value = true;
      errorMessage.value = 'Failed to update profile. Please try again.';
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
      logger.i('Avatar uploaded successfully');
    } catch (e) {
      logger.e('Error uploading avatar: $e');
      hasError.value = true;
      errorMessage.value = 'Failed to upload avatar. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }
}
