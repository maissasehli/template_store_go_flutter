import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:io';

class EnhancedImageCache extends GetxService {
  static final EnhancedImageCache _instance = EnhancedImageCache._internal();
  factory EnhancedImageCache() => _instance;
  EnhancedImageCache._internal();

  final Map<String, ImageProvider> _cachedAssetImages = {};
  final Map<String, ImageProvider> _cachedNetworkImages = {};
  final Map<String, bool> _loadingStatus = {};
  final DefaultCacheManager _cacheManager = DefaultCacheManager();

  // Get image provider based on path type
  ImageProvider getImageProvider(String path, {bool isAsset = false}) {
    if (isAsset) {
      if (_cachedAssetImages.containsKey(path)) {
        return _cachedAssetImages[path]!;
      }
      _cachedAssetImages[path] = AssetImage(path);
      return _cachedAssetImages[path]!;
    } else {
      if (_cachedNetworkImages.containsKey(path)) {
        return _cachedNetworkImages[path]!;
      }
      _cachedNetworkImages[path] = NetworkImage(path);
      return _cachedNetworkImages[path]!;
    }
  }

  // Get file for network images (allows direct file access)
  Future<File?> getImageFile(String url) async {
    try {
      final fileInfo = await _cacheManager.getFileFromCache(url);
      if (fileInfo != null) {
        return fileInfo.file;
      }

      // Not in cache, download it
      final file = await _cacheManager.getSingleFile(url);
      return file;
    } catch (e) {
      debugPrint('Failed to get cached file for $url: $e');
      return null;
    }
  }

  // Preload asset image
  Future<void> cacheAssetImage(BuildContext context, String path) async {
    if (_loadingStatus[path] == true) return;

    _loadingStatus[path] = true;

    try {
      if (!_cachedAssetImages.containsKey(path)) {
        final imageProvider = AssetImage(path);
        _cachedAssetImages[path] = imageProvider;
        await precacheImage(imageProvider, context);
      }
      _loadingStatus[path] = false;
    } catch (e) {
      _loadingStatus[path] = false;
      debugPrint('Failed to cache asset image $path: $e');
    }
  }

  // Preload network image
  Future<void> cacheNetworkImage(String url) async {
    if (_loadingStatus[url] == true) return;

    _loadingStatus[url] = true;

    try {
      await _cacheManager.getSingleFile(url);

      if (!_cachedNetworkImages.containsKey(url)) {
        _cachedNetworkImages[url] = NetworkImage(url);
      }
      _loadingStatus[url] = false;
    } catch (e) {
      _loadingStatus[url] = false;
      debugPrint('Failed to cache network image $url: $e');
    }
  }

  // Preload multiple images (both asset and network)
  Future<void> precacheImages(
    BuildContext context,
    List<String> assetPaths,
    List<String> networkUrls,
  ) async {
    final assetFutures = assetPaths.map(
      (path) => cacheAssetImage(context, path),
    );
    final networkFutures = networkUrls.map((url) => cacheNetworkImage(url));

    await Future.wait([...assetFutures, ...networkFutures], eagerError: false);
  }

  // Check if an image is cached
  bool isImageCached(String path, {bool isAsset = false}) {
    return isAsset
        ? _cachedAssetImages.containsKey(path)
        : _cachedNetworkImages.containsKey(path) ||
            // ignore: unnecessary_null_comparison
            _cacheManager.getFileFromMemory(path) != null;
  }

  // Clear specific images
  void clearImages(List<String> assetPaths, List<String> networkUrls) {
    for (final path in assetPaths) {
      _cachedAssetImages.remove(path);
      _loadingStatus.remove(path);
    }

    for (final url in networkUrls) {
      _cachedNetworkImages.remove(url);
      _loadingStatus.remove(url);
      _cacheManager.removeFile(url);
    }
  }

  // Clear all cached images
  void clearAllImages() {
    _cachedAssetImages.clear();
    _cachedNetworkImages.clear();
    _loadingStatus.clear();
    _cacheManager.emptyCache();
  }

  // Stats for debugging
  int get cachedAssetImageCount => _cachedAssetImages.length;
  int get cachedNetworkImageCount => _cachedNetworkImages.length;

  // Initialize service
  Future<EnhancedImageCache> init() async {
    return this;
  }
}
