import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/services/image_cache.dart';

class ImagePreloaderManager extends GetxService {
  final ImageCacheService _cacheService = Get.find<ImageCacheService>();

  // Preload onboarding images
  Future<void> preloadOnboardingImages(BuildContext context) async {
    final imagesToPreload = [
      AssetConfig.onBoardingHeaderMain,
      AssetConfig.onBoardingHeaderLeft,
      AssetConfig.onBoardingHeaderRight,
      AssetConfig.onBoardingIconLogo,
      AssetConfig.onBoardingIconBag,
    ];

    await _cacheService.precacheImages(context, imagesToPreload);
  }

  // Preload auth-related images
  Future<void> preloadAuthImages(BuildContext context) async {
    final imagesToPreload = [
      AssetConfig.appleIcon,
      AssetConfig.googleIcon,
      AssetConfig.facebookIcon,
      AssetConfig.sendMail,
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
