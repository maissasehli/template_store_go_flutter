import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/profile/models/user_model.dart';
import 'package:store_go/features/profile/repositories/profile_repository.dart';
import 'package:store_go/features/profile/controllers/profile_controller.dart';
import 'package:store_go/app/core/services/theme_aware_snackbar_service.dart';
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
  final Rx<File?> selectedImage = Rx<File?>(
    null,
  ); // Text controllers for form fields
  late TextEditingController fullNameController;
  late TextEditingController phoneController;
  late TextEditingController dateOfBirthController; // Added for date of birth
  // Gender and country
  final RxString selectedCountry = "tunisia".obs;
  final RxString selectedGender = "female".obs;
  final Rx<DateTime?> selectedDateOfBirth = Rx<DateTime?>(
    null,
  ); // Added for date picker

  // Constructor with dependency injection
  EditProfileController(this._repository);
  @override
  void onInit() {
    super.onInit();
    // Initialize controllers
    fullNameController = TextEditingController();
    phoneController = TextEditingController();
    dateOfBirthController = TextEditingController(); // Added for date of birth

    fetchUserData();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    dateOfBirthController.dispose(); // Added for date of birth
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

      // Populate form controllers with detailed logging
      fullNameController.text = user.value?.name ?? '';
      logger.d('Setting name: ${user.value?.name}');

      phoneController.text = user.value?.phoneNumber ?? '';
      logger.d('Setting phone: ${user.value?.phoneNumber}');

      // Handle date of birth with multiple format support
      if (user.value?.dateOfBirth != null &&
          user.value!.dateOfBirth!.isNotEmpty) {
        final dateString = user.value!.dateOfBirth!;
        logger.d('Original date string: $dateString');

        try {
          DateTime parsedDate;

          // Try different date formats
          if (dateString.contains('T')) {
            // ISO format with time
            parsedDate = DateTime.parse(dateString);
          } else if (dateString.contains('-') && dateString.length >= 10) {
            // YYYY-MM-DD format
            parsedDate = DateTime.parse(dateString.substring(0, 10));
          } else {
            // Fallback: try direct parsing
            parsedDate = DateTime.parse(dateString);
          }

          selectedDateOfBirth.value = parsedDate;
          // Format as YYYY-MM-DD for display
          dateOfBirthController.text =
              "${parsedDate.year.toString().padLeft(4, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
          logger.d('Successfully parsed date: ${dateOfBirthController.text}');
        } catch (e) {
          logger.w('Error parsing date of birth: $e, original: $dateString');
          // If parsing fails, use the original string
          dateOfBirthController.text = dateString;
        }
      } else {
        dateOfBirthController.text = '';
        logger.d('No date of birth available');
      }

      // Set gender and country if available
      if (user.value?.gender != null) {
        selectedGender.value = user.value!.gender!.toLowerCase();
        logger.d('Setting gender: ${selectedGender.value}');
      }

      if (user.value?.country != null) {
        selectedCountry.value = user.value!.country!.toLowerCase();
        logger.d('Setting country: ${selectedCountry.value}');
      }

      logger.d('User data fetched successfully: ${user.value?.name}');
      logger.d('Phone controller text: ${phoneController.text}');
      logger.d('Date controller text: ${dateOfBirthController.text}');
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
      ThemeAwareSnackbarService().showErrorNotification(
        title: 'Error',
        message: 'Failed to pick image. Please try again.',
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
      return updatedUser.avatar; // Changed back to avatar to match API response
    } catch (e) {
      logger.e('Error uploading avatar: $e');
      ThemeAwareSnackbarService().showErrorNotification(
        title: 'Error',
        message: 'Failed to upload avatar. Please try again.',
      );
      return null;
    } finally {
      isUploading.value = false;
    }
  }

  // Save profile updates with optimistic UI
  Future<void> saveProfile() async {
    logger.d('Save profile button pressed');

    try {
      // Validate form data first
      if (fullNameController.text.trim().isEmpty) {
        ThemeAwareSnackbarService().showErrorNotification(
          title: 'Validation Error',
          message: 'Name cannot be empty',
        );
        return;
      }

      // Create optimistic user data immediately
      final optimisticUserData = _createOptimisticUserData();
      logger.d('Created optimistic user data: ${optimisticUserData.name}');

      // Update local user state immediately for optimistic UI
      user.value = optimisticUserData;

      // Try to update ProfileController immediately if it exists
      try {
        final profileController = Get.find<ProfileController>();
        profileController.user.value = optimisticUserData;
        logger.d('Updated ProfileController with optimistic data');
      } catch (e) {
        logger.d('ProfileController not found, continuing without update: $e');
      }

      logger.d('About to navigate back to profile screen');

      // Navigate back to profile page immediately with optimistic updates
      // Use Get.back() to return to the previous screen
      Get.back();

      // Show success message after navigation
      // Using a slight delay to ensure navigation completes first
      Future.delayed(const Duration(milliseconds: 300), () {
        ThemeAwareSnackbarService().showSuccessNotification(
          title: 'Success',
          message: 'Profile updated successfully',
          duration: const Duration(seconds: 2),
        );
      });

      // Now perform the actual API calls in the background (don't await)
      _performBackgroundUpdate(optimisticUserData);
    } catch (e) {
      logger.e('Error in optimistic update: $e');
      // If optimistic update fails, show error immediately
      ThemeAwareSnackbarService().showErrorNotification(
        title: 'Error',
        message: 'Failed to prepare profile update. Please try again.',
      );
    }
  }

  // Create optimistic user data based on form inputs
  UserModel _createOptimisticUserData() {
    final currentUser = user.value;
    if (currentUser == null) {
      throw Exception('No current user data available');
    }

    logger.d('Creating optimistic data from current user: ${currentUser.name}');
    logger.d(
      'Form data - Name: ${fullNameController.text}, Phone: ${phoneController.text}',
    );

    return UserModel(
      id: currentUser.id,
      storeId: currentUser.storeId,
      name:
          fullNameController.text.trim().isNotEmpty
              ? fullNameController.text.trim()
              : currentUser.name,
      email: currentUser.email,
      avatar: currentUser.avatar, // Keep current avatar for now
      gender:
          selectedGender.value.isNotEmpty
              ? selectedGender.value
              : currentUser.gender,
      country:
          selectedCountry.value.isNotEmpty
              ? selectedCountry.value
              : currentUser.country,
      phoneNumber:
          phoneController.text.trim().isNotEmpty
              ? phoneController.text.trim()
              : currentUser.phoneNumber,
      dateOfBirth:
          dateOfBirthController.text.trim().isNotEmpty
              ? dateOfBirthController.text.trim()
              : currentUser.dateOfBirth,
      ageRange: currentUser.ageRange,
      status: currentUser.status,
      isOnline: currentUser.isOnline,
      lastSeen: currentUser.lastSeen,
      createdAt: currentUser.createdAt,
      updatedAt: DateTime.now(), // Update timestamp
    );
  }

  // Perform the actual API update in the background
  Future<void> _performBackgroundUpdate(UserModel optimisticData) async {
    logger.d('Starting background update');

    try {
      String? avatarUrl;

      // First upload avatar if selected
      if (selectedImage.value != null) {
        logger.d('Uploading avatar');
        isUploading.value = true;
        try {
          avatarUrl = await uploadAvatar();
          logger.d('Avatar uploaded successfully: $avatarUrl');
        } catch (e) {
          logger.e('Avatar upload failed: $e');
          // Continue with profile update even if avatar upload fails
        } finally {
          isUploading.value = false;
        }
      }

      // Prepare user data for update
      final userData = <String, dynamic>{
        'name': fullNameController.text.trim(),
        'gender': selectedGender.value,
        'country': selectedCountry.value,
      };

      // Add phone if available
      if (phoneController.text.trim().isNotEmpty) {
        userData['phone_number'] = phoneController.text.trim();
      }

      // Add date of birth if available
      if (dateOfBirthController.text.trim().isNotEmpty) {
        userData['date_of_birth'] = dateOfBirthController.text.trim();
      }

      // Add avatar if it was updated
      if (avatarUrl != null) {
        userData['avatar'] = avatarUrl;
      }

      logger.d('Updating profile with data: $userData');

      // Update profile via API
      final updatedUser = await _repository.updateProfile(userData);
      logger.d('Profile updated successfully via API');

      // Update both controllers with the real API response
      user.value = updatedUser;
      try {
        final profileController = Get.find<ProfileController>();
        profileController.user.value = updatedUser;
        logger.d('Updated ProfileController with API response');
      } catch (e) {
        logger.d('ProfileController not found during background update: $e');
      }

      logger.d('Background profile update completed successfully');
    } catch (e) {
      logger.e('Background profile update failed: $e');

      // Show user-friendly error message
      ThemeAwareSnackbarService().showErrorNotification(
        title: 'Update Failed',
        message: _getReadableErrorMessage(e),
      );

      // Revert optimistic changes on failure
      try {
        await _revertOptimisticChanges();
      } catch (revertError) {
        logger.e('Failed to revert optimistic changes: $revertError');
      }
    } finally {
      // Make sure loading states are reset
      isLoading.value = false;
      isUploading.value = false;
    }
  }

  // Revert optimistic changes if API call fails
  Future<void> _revertOptimisticChanges() async {
    try {
      // Fetch fresh data from API to revert changes
      final freshUserData = await _repository.getCurrentUser();
      user.value = freshUserData;

      // Update ProfileController with fresh data
      try {
        final profileController = Get.find<ProfileController>();
        profileController.user.value = freshUserData;
        logger.d('Reverted ProfileController to fresh data');
      } catch (e) {
        logger.d('ProfileController not found during revert');
      }

      // Update form fields with fresh data
      _populateFormFields(freshUserData);
    } catch (e) {
      logger.e('Failed to revert optimistic changes: $e');
    }
  }

  // Helper method to populate form fields
  void _populateFormFields(UserModel userData) {
    fullNameController.text = userData.name;
    phoneController.text = userData.phoneNumber ?? '';

    if (userData.dateOfBirth != null && userData.dateOfBirth!.isNotEmpty) {
      try {
        final parsedDate = DateTime.parse(userData.dateOfBirth!);
        selectedDateOfBirth.value = parsedDate;
        dateOfBirthController.text =
            "${parsedDate.year.toString().padLeft(4, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
      } catch (e) {
        dateOfBirthController.text = userData.dateOfBirth!;
      }
    }

    if (userData.gender != null) {
      selectedGender.value = userData.gender!.toLowerCase();
    }

    if (userData.country != null) {
      selectedCountry.value = userData.country!.toLowerCase();
    }
  }

  // Convert technical errors to user-friendly messages
  String _getReadableErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') || errorString.contains('connection')) {
      return 'Please check your internet connection and try again.';
    } else if (errorString.contains('timeout')) {
      return 'The request took too long. Please try again.';
    } else if (errorString.contains('unauthorized') ||
        errorString.contains('401')) {
      return 'Your session has expired. Please log in again.';
    } else if (errorString.contains('forbidden') ||
        errorString.contains('403')) {
      return 'You don\'t have permission to perform this action.';
    } else if (errorString.contains('not found') ||
        errorString.contains('404')) {
      return 'The requested information was not found.';
    } else if (errorString.contains('server') || errorString.contains('500')) {
      return 'Our servers are experiencing issues. Please try again later.';
    } else if (errorString.contains('validation') ||
        errorString.contains('invalid')) {
      return 'Please check your information and try again.';
    } else {
      return 'Something went wrong. Please try again.';
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

  // Show date picker for date of birth
  Future<void> selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateOfBirth.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: Get.locale,
    );

    if (picked != null && picked != selectedDateOfBirth.value) {
      selectedDateOfBirth.value = picked;
      // Format date as YYYY-MM-DD for API
      dateOfBirthController.text =
          "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  // Validate date of birth format
  bool isValidDateOfBirth(String dateString) {
    if (dateString.isEmpty) return true; // Optional field

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      return date.isBefore(now) && date.isAfter(DateTime(1900));
    } catch (e) {
      return false;
    }
  }
}
