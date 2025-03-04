import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes.dart';
import 'package:store_go/core/data/datasource/static/onbording_static.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();

  RxInt currentPage = 0.obs;
  RxBool isLastPage = false.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
    isLastPage.value = index == OnboardingStatic.pages.length - 1;
  }

  void nextPage() {
    if (currentPage.value < OnboardingStatic.pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void navigateToLogin() {
    // Implement navigation to login screen
   Get.offNamed(AppRoute.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}