import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/app/core/services/storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppMiddleware extends GetMiddleware {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  @override
  int? get priority => 1; // Higher priority gets handled first
  
  @override
  RouteSettings? redirect(String? route) {
    // We can't directly return Futures in this method
    // Instead, we'll use Get.offAllNamed in the future completion handlers
    
    if (route == AppRoute.login || route == AppRoute.onBoarding) {
      _handleAuthRoutes(route!);
      return null; // No immediate redirection
    }
    
    // For protected routes, verify authentication
    if (_isProtectedRoute(route)) {
      _verifyAuth(route);
      return null; // No immediate redirection
    }
    
    return null; // No redirection needed
  }
  
  void _handleAuthRoutes(String route) async {
    // Check if we have a saved token
    final isAuthenticated = await _checkAuthStatus();
    
    if (isAuthenticated) {
      // User is already logged in, redirect to home
      Get.offAllNamed(AppRoute.mainContainer);
    } else {
      // Check if onboarding is completed
      final isCompleted = await _isOnboardingCompleted();
      
      if (route == AppRoute.onBoarding && isCompleted) {
        // Onboarding already completed, go to login
        Get.offAllNamed(AppRoute.login);
      } else if (route == AppRoute.login && !isCompleted) {
        // Onboarding not completed, go to onboarding
        Get.offAllNamed(AppRoute.onBoarding);
      }
      // Otherwise, no redirection needed
    }
  }
  
  void _verifyAuth(String? route) async {
    final isAuthenticated = await _checkAuthStatus();
    
    if (!isAuthenticated) {
      // Not authenticated, check if onboarding is needed
      final isCompleted = await _isOnboardingCompleted();
      
      if (isCompleted) {
        // Onboarding done, go to login
        Get.offAllNamed(AppRoute.login);
      } else {
        // Need to complete onboarding first
        Get.offAllNamed(AppRoute.onBoarding);
      }
    }
    // User is authenticated, no redirection needed
  }
  
Future<bool> _checkAuthStatus() async {
  final token = await _secureStorage.read(key: 'access_token');
  if (token == null) return false;

  // Check if token is expired
  final expiresAtStr = await _secureStorage.read(key: 'expires_at');
  if (expiresAtStr != null) {
    final expiresAt = DateTime.parse(expiresAtStr);
    if (DateTime.now().isAfter(expiresAt)) {
      return false; // Token is expired
    }
  }

  return true; // Token exists and is still valid
}

  Future<bool> _isOnboardingCompleted() async {
    // Using the correct method from StorageService
    final hasSeenOnboarding = await StorageService.hasSeenOnboarding();
    return hasSeenOnboarding;
  }
  
  bool _isProtectedRoute(String? route) {
    // Add all routes that require authentication
    final List<String> protectedRoutes = [
      AppRoute.mainContainer,
      AppRoute.profile,
      // Add other protected routes here
    ];
    
    return protectedRoutes.contains(route);
  }
}