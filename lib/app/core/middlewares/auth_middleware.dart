import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/features/auth/services/auth_service.dart';
import 'package:store_go/features/auth/services/token_manager.dart';

class AuthMiddleware extends GetMiddleware {
  final AuthService _authService = Get.find<AuthService>();
  final TokenManager _tokenManager = Get.find<TokenManager>();

  @override
  RouteSettings? redirect(String? route) {
    _checkAuthentication(route);
    return null;
  }

  // Fire and forget authentication check
  void _checkAuthentication(String? route) async {
    try {
      // Skip middleware check for public routes
      if (AppRoute.publicRoutes.contains(route)) {
        return;
      }

      final isAuthenticated = await _authService.isAuthenticated();
      final hasValidToken = await _tokenManager.checkAndRefreshTokenIfNeeded();

      if (!isAuthenticated || !hasValidToken) {
        Logger().w('AuthMiddleware: Not authenticated, redirecting to login');
        Get.offAllNamed(AppRoute.login);
      }
    } catch (e) {
      Logger().e('Error in AuthMiddleware: $e');
    }
  }
}
