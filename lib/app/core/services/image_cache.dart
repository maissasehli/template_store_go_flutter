import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageCacheService extends GetxService {
  static final ImageCacheService _instance = ImageCacheService._internal();
  factory ImageCacheService() => _instance;
  ImageCacheService._internal();

  final Map<String, ImageProvider> _cachedImages = {};
  final Map<String, bool> _loadingStatus = {};

  /// Gets a cached image if available, otherwise creates a new provider
  ImageProvider getImageProvider(String path) {
    if (_cachedImages.containsKey(path)) {
      return _cachedImages[path]!;
    }

    // Create and cache for next time
    _cachedImages[path] = AssetImage(path);
    return _cachedImages[path]!;
  }

  /// Preloads an image and caches it for later use
  Future<void> cacheImage(BuildContext context, String path) async {
    // Avoid duplicate loading requests
    if (_loadingStatus[path] == true) return;

    _loadingStatus[path] = true;

    try {
      if (!_cachedImages.containsKey(path)) {
        final imageProvider = AssetImage(path);
        _cachedImages[path] = imageProvider;
        await precacheImage(imageProvider, context);
      }
      _loadingStatus[path] = false;
    } catch (e) {
      _loadingStatus[path] = false;
      debugPrint('Failed to cache image $path: $e');
    }
  }

  /// Preloads a list of images in parallel
  Future<void> precacheImages(BuildContext context, List<String> paths) async {
    await Future.wait(
      paths.map((path) => cacheImage(context, path)),
      eagerError: false, // Continue loading other images if one fails
    );
  }

  /// Checks if an image is already cached
  bool isImageCached(String path) {
    return _cachedImages.containsKey(path);
  }

  /// Clears specific images from cache
  void clearImages(List<String> paths) {
    for (final path in paths) {
      _cachedImages.remove(path);
      _loadingStatus.remove(path);
    }
  }

  /// Clears all cached images
  void clearAllImages() {
    _cachedImages.clear();
    _loadingStatus.clear();
  }

  // For debugging purposes
  int get cachedImageCount => _cachedImages.length;

  // Initialize as a GetX service
  Future<ImageCacheService> init() async {
    return this;
  }
}
