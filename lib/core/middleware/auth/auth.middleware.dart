import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes.dart';
import 'package:store_go/core/services/auth_middleware.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final AuthMiddlewareService authService = Get.find<AuthMiddlewareService>();

    // If the user has not completed their profile, redirect to the setup page
    if (!authService.isProfileCompleted() &&
        route != AppRoute.profileSetup &&
        route != AppRoute.login &&
        route != AppRoute.signup &&
        route != AppRoute.onBoarding) {
      return const RouteSettings(name: AppRoute.profileSetup);
    }

    // If the user is already logged in and tries to access login/signup
    if (authService.isLoggedIn() &&
        (route == AppRoute.login || route == AppRoute.signup)) {
      return const RouteSettings(name: AppRoute.home);
    }

    // If the user is not logged in and tries to access protected pages
    if (!authService.isLoggedIn() &&
        route != AppRoute.login &&
        route != AppRoute.signup &&
        route != AppRoute.profileSetup &&
        route != AppRoute.onBoarding &&
        route != AppRoute.forgetPassword &&
        route != AppRoute.emailResetPasswordConfirmation) {
      return const RouteSettings(name: AppRoute.login);
    }

    return null;
  }
}
