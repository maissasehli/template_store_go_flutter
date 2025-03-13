import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/assets_constants.dart';
import 'package:store_go/core/services/image_cache.dart';

class ImagePreloaderManager extends GetxService {
  final ImageCacheService _cacheService = Get.find<ImageCacheService>();

  // Preload onboarding images
  Future<void> preloadOnboardingImages(BuildContext context) async {
    final imagesToPreload = [
      ImageAsset.onBoardingHeaderMain,
      ImageAsset.onBoardingHeaderLeft,
      ImageAsset.onBoardingHeaderRight,
      ImageAsset.onBoardingIconLogo,
      ImageAsset.onBoardingIconBag,
    ];

    await _cacheService.precacheImages(context, imagesToPreload);
  }

  // Preload auth-related images
  Future<void> preloadAuthImages(BuildContext context) async {
    final imagesToPreload = [
      ImageAsset.appleIcon,
      ImageAsset.googleIcon,
      ImageAsset.facebookIcon,
      ImageAsset.sendMail,
    ];

    await _cacheService.precacheImages(context, imagesToPreload);
  }

  // Preload images for a specific screen or section
  Future<void> preloadScreenImages(
    BuildContext context,
    List<String> imagePaths,
  ) async {
    await _cacheService.precacheImages(context, imagePaths);
  }

  // Initialize the service
  Future<ImagePreloaderManager> init() async {
    return this;
  }
}
