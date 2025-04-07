import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/services/enhanced_image_cache.dart';

class ImagePreloaderManager extends GetxService {
  final EnhancedImageCache _cacheService = Get.find<EnhancedImageCache>();

  // Preload onboarding images
  Future<void> preloadOnboardingImages(BuildContext context) async {
    final assetImages = [
      AssetConfig.onBoardingHeaderMain,
      AssetConfig.onBoardingHeaderLeft,
      AssetConfig.onBoardingHeaderRight,
      AssetConfig.onBoardingIconLogo,
      AssetConfig.onBoardingIconBag,
    ];

    await _cacheService.precacheImages(context, assetImages, []);
  }

  // Preload auth-related images
  Future<void> preloadAuthImages(BuildContext context) async {
    final assetImages = [
      AssetConfig.appleIcon,
      AssetConfig.googleIcon,
      AssetConfig.facebookIcon,
      AssetConfig.sendMail,
    ];

    await _cacheService.precacheImages(context, assetImages, []);
  }

  // Preload a mix of asset and network images
  Future<void> preloadMixedImages(
    BuildContext context,
    List<String> assetPaths,
    List<String> networkUrls,
  ) async {
    await _cacheService.precacheImages(context, assetPaths, networkUrls);
  }

  // Preload product images (mostly network)
  Future<void> preloadProductImages(
    BuildContext context,
    List<String> productImageUrls,
  ) async {
    await _cacheService.precacheImages(context, [], productImageUrls);
  }

  // Initialize the service
  Future<ImagePreloaderManager> init() async {
    return this;
  }
}
