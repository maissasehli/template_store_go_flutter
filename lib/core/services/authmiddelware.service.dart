import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_go/core/constants/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthMiddlewareService extends GetxService {
  late SharedPreferences sharedPreferences;
  final supabase = Supabase.instance.client;

  Future<AuthMiddlewareService> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    
    // Vérifier si l'utilisateur est connecté avec Supabase au démarrage
    final session = supabase.auth.currentSession;
    if (session != null) {
      await sharedPreferences.setBool('is_logged_in', true);
    }
    
    return this;
  }
  
  // Enregistrer les informations du profil utilisateur
  Future<void> saveUserProfile(String gender, String ageRange) async {
    await sharedPreferences.setString('user_gender', gender);
    await sharedPreferences.setString('user_age_range', ageRange);
    await sharedPreferences.setBool('profile_completed', true);
    
    // Mettre à jour les métadonnées utilisateur dans Supabase si l'utilisateur est connecté
    final user = supabase.auth.currentUser;
    if (user != null) {
      await supabase.auth.updateUser(
        UserAttributes(
          data: {
            'gender': gender,
            'age_range': ageRange,
          },
        ),
      );
    }
  }

  // Vérifier si le profil est complété
  bool isProfileCompleted() {
    return sharedPreferences.getBool('profile_completed') ?? false;
  }

  // Vérifier si l'utilisateur est connecté (via SharedPreferences et Supabase)
  bool isLoggedIn() {
    // Vérifier d'abord dans SharedPreferences
    bool isLoggedInLocal = sharedPreferences.getBool('is_logged_in') ?? false;
    
    // Vérifier également avec Supabase
    final session = supabase.auth.currentSession;
    
    // Mettre à jour SharedPreferences si nécessaire
    if (session != null && !isLoggedInLocal) {
      sharedPreferences.setBool('is_logged_in', true);
      return true;
    } else if (session == null && isLoggedInLocal) {
      sharedPreferences.setBool('is_logged_in', false);
      return false;
    }
    
    return isLoggedInLocal;
  }
  
  // Enregistrer la session utilisateur après connexion
  Future<void> saveUserSession(User user) async {
    await sharedPreferences.setString('user_id', user.id);
    await sharedPreferences.setBool('is_logged_in', true);
    
    // Facultatif: enregistrer d'autres informations utilisateur
    if (user.userMetadata != null) {
      if (user.userMetadata!['first_name'] != null) {
        await sharedPreferences.setString('first_name', user.userMetadata!['first_name']);
      }
      if (user.userMetadata!['last_name'] != null) {
        await sharedPreferences.setString('last_name', user.userMetadata!['last_name']);
      }
    }
  }
  
  // Méthode pour forcer une déconnexion locale (sans déconnecter Supabase)
  Future<void> clearLocalSession() async {
    await sharedPreferences.remove('user_id');
    await sharedPreferences.remove('first_name');
    await sharedPreferences.remove('last_name');
    await sharedPreferences.setBool('is_logged_in', false);
    await sharedPreferences.setBool('profile_completed', false);
  }
}
