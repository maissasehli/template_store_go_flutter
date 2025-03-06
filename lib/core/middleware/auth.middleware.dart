import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes.dart';
import 'package:store_go/core/services/authMiddelware.service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final AuthMiddlewareService authService = Get.find<AuthMiddlewareService>();
    
    // Si l'utilisateur n'a pas terminé son profil, rediriger vers le setup
    if (!authService.isProfileCompleted() && 
        route != AppRoute.userprofilesetup && 
        route != AppRoute.login && 
        route != AppRoute.signup &&
        route != AppRoute.onBoarding) {
      return const RouteSettings(name: AppRoute.userprofilesetup);
    }
    
    // Si l'utilisateur est déjà connecté et essaie d'accéder à login/signup
    if (authService.isLoggedIn() && 
        (route == AppRoute.login || route == AppRoute.signup)) {
      return const RouteSettings(name: AppRoute.home);
    }
    
    // Si l'utilisateur n'est pas connecté et essaie d'accéder à des pages protégées
    if (!authService.isLoggedIn() && 
        route != AppRoute.login && 
        route != AppRoute.signup && 
        route != AppRoute.userprofilesetup && 
        route != AppRoute.onBoarding && 
        route != AppRoute.forgetpassword &&
        route != AppRoute.emailsentconfirmationresetpassword) {
      return const RouteSettings(name: AppRoute.login);
    }
    
    return null; // Aucune redirection nécessaire
  }
}