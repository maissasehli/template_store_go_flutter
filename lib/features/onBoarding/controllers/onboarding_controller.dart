import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/routes_constants.dart';
import 'package:store_go/app/core/data/onboarding_static.dart';

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

  void nextPage() {
    if (currentPage.value < pageCount - 1) {
      Get.offAllNamed(AppRoute.login);
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  void navigateToLogin() {
    Get.offAllNamed(AppRoute.login);
  }
}
