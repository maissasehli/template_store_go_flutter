import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/app/core/data/onboarding_static.dart';
import 'package:store_go/app/core/services/storage_service.dart';

class OnboardingController extends GetxController {
  late PageController pageController;
  var currentPage = 0.obs;

  final int pageCount = OnboardingStatic.pages.length;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  bool get isLastPage => currentPage.value == pageCount - 1;

  void next() {
    if (currentPage.value < pageCount - 1) {
      currentPage.value++;
      pageController.animateToPage(
        currentPage.value, // Using .value to get the int from RxInt
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeInOut,
      );
    } else {
      // Onboarding completed
      completeOnboarding();
    }
  }

  void onPageChanged(int index) {
    currentPage.value = index;
    update();
  }

  void completeOnboarding() async {
    // Mark onboarding as completed using the StorageService
    await StorageService.markOnboardingComplete();
    Get.offAllNamed(AppRoute.login);
  }
  
  // Add this method for the skip button
  void navigateToLogin() {
    completeOnboarding();
  }
}