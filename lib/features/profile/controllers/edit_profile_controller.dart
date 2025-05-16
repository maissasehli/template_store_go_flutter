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
  
  // Gender and country
  final RxString selectedCountry = "Tunisia".obs;
  final RxString selectedGender = "Female".obs;

  // Constructor with dependency injection
  EditProfileController(this._repository);

  @override
  void onInit() {
    super.onInit();
    // Initialize controllers
    fullNameController = TextEditingController();
    userNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    
    fetchUserData();
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
      userNameController.text = user.value?.name.split(' ').first.toLowerCase() ?? '';
      emailController.text = user.value?.email ?? '';
      phoneController.text = user.value?.phone ?? ''; 
      
      // Set gender and country if available
      if (user.value?.gender != null) {
        selectedGender.value = user.value!.gender!.capitalize!;
      }
      
      if (user.value?.country != null) {
        selectedCountry.value = user.value!.country!;
      }

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
  Future<String?> uploadAvatar() async {
    if (selectedImage.value == null) return null;

    try {
      isUploading.value = true;
      final updatedUser = await _repository.uploadAvatar(selectedImage.value!);
      user.value = updatedUser;
      
      return updatedUser.avatar;
    } catch (e) {
      logger.e('Error uploading avatar: $e');
      Get.snackbar(
        'Error',
        'Failed to upload avatar. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
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

      String? avatarUrl;
      
      // First upload avatar if selected
      if (selectedImage.value != null) {
        avatarUrl = await uploadAvatar();
      }

      // Prepare user data for update
      final userData = {
        'name': fullNameController.text.trim(),
        'email': emailController.text.trim(),
        'gender': selectedGender.value.toLowerCase(),
        'country': selectedCountry.value,
      };
      
      // Add phone if available
      if (phoneController.text.trim().isNotEmpty) {
        userData['phone'] = phoneController.text.trim();
      }
      
      // Add avatar if it was updated
      if (avatarUrl != null) {
        userData['avatar'] = avatarUrl;
      }

      // Update profile
      final updatedUser = await _repository.updateProfile(userData);
      user.value = updatedUser;
      
      // Don't try to update ProfileController - we'll handle profile updates elsewhere
      // This was causing the "ProfileController not found" error

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Go back to profile page after successful update
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
  
  // Update gender value
  void updateGender(String gender) {
    selectedGender.value = gender;
  }
  
  // Update country value
  void updateCountry(String country) {
    selectedCountry.value = country;
  }
}