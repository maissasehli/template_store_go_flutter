import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/services/enhanced_image_cache.dart';

class ImagePreloaderManager extends GetxService {
  final EnhancedImageCache _cacheService = Get.find<EnhancedImageCache>();
  
  // Observable loading status
  final RxBool onboardingImagesLoaded = false.obs;
  final RxBool authImagesLoaded = false.obs;
  final RxMap<String, bool> specificImageStatus = <String, bool>{}.obs;

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
    onboardingImagesLoaded.value = true;
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
    authImagesLoaded.value = true;
  }

  // Preload a mix of asset and network images
  Future<void> preloadMixedImages(
    BuildContext context,
    List<String> assetPaths,
    List<String> networkUrls,
  ) async {
    await _cacheService.precacheImages(context, assetPaths, networkUrls);
    
    // Update status for each image
    for (final path in assetPaths) {
      specificImageStatus[path] = true;
    }
    for (final url in networkUrls) {
      specificImageStatus[url] = true;
    }
  }

  // Preload product images (mostly network)
  Future<void> preloadProductImages(
    BuildContext context,
    List<String> productImageUrls,
  ) async {
    await _cacheService.precacheImages(context, [], productImageUrls);
    
    // Update status for each image
    for (final url in productImageUrls) {
      specificImageStatus[url] = true;
    }
  }
  
  // Check if a specific image is loaded
  bool isImageLoaded(String path, {bool isAsset = true}) {
    if (specificImageStatus.containsKey(path)) {
      return specificImageStatus[path] ?? false;
    }
    return _cacheService.isImageCached(path, isAsset: isAsset);
  }

  // Initialize the service
  Future<ImagePreloaderManager> init() async {
    return this;
  }
}