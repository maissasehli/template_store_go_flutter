import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/profile/models/user_model.dart';
import 'package:store_go/features/profile/repositories/profile_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileController extends GetxController {
  final ProfileRepository _repository;
  final logger = Logger();

  // Observable variables
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isUploading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);

  // Text controllers for form fields
  late TextEditingController fullNameController;
  late TextEditingController userNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  // Constructor with dependency injection
  EditProfileController(this._repository);

  @override
  void onInit() {
    super.onInit();
    fetchUserData();

    // Initialize controllers
    fullNameController = TextEditingController();
    userNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  // Fetch user data
  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final userData = await _repository.getCurrentUser();
      user.value = userData;

      // Populate form controllers
      fullNameController.text = user.value?.name ?? '';
      userNameController.text =
          user.value?.name.split(' ').first.toLowerCase() ?? '';
      emailController.text = user.value?.email ?? '';
      phoneController.text = ''; // Phone not in the model, add if needed

      logger.d('User data fetched successfully: ${user.value?.name}');
    } catch (e) {
      logger.e('Error fetching user data: $e');
      hasError.value = true;
      errorMessage.value = 'Failed to load profile data. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // Pick image from gallery or camera
  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      logger.e('Error picking image: $e');
      Get.snackbar(
        'Error',
        'Failed to pick image. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Upload avatar
  Future<void> uploadAvatar() async {
    if (selectedImage.value == null) return;

    try {
      isUploading.value = true;
      final updatedUser = await _repository.uploadAvatar(selectedImage.value!);
      user.value = updatedUser;

      Get.snackbar(
        'Success',
        'Avatar uploaded successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      logger.e('Error uploading avatar: $e');
      Get.snackbar(
        'Error',
        'Failed to upload avatar. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploading.value = false;
    }
  }

  // Save profile updates
  Future<void> saveProfile() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // First upload avatar if selected
      if (selectedImage.value != null) {
        await uploadAvatar();
      }

      // Prepare user data for update
      final userData = {
        'name': fullNameController.text.trim(),
        'email': emailController.text.trim(),
        // Add phone if needed: 'phone': phoneController.text.trim(),
      };

      // Update profile
      final updatedUser = await _repository.updateProfile(userData);
      user.value = updatedUser;

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.back();
    } catch (e) {
      logger.e('Error saving profile: $e');
      hasError.value = true;
      errorMessage.value = 'Failed to save profile. Please try again.';
      Get.snackbar(
        'Error',
        'Failed to save profile. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
