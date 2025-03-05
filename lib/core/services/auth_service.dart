import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes.dart';
import 'package:store_go/view/screens/auth/resetpassword.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // Initialize Google Sign In with client ID from environment variables
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: dotenv.env['GOOGLE_CLIENT_ID'],
    scopes: ['email', 'profile'],
  );

  // Centralized error handling method
  void _showErrorAlert(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
    );
  }

  // Centralized success handling method
  void _showSuccessAlert(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
    );
  }

  // Comprehensive Sign Up Method
  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final authResponse = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'first_name': firstName, 'last_name': lastName},
      );

      if (authResponse.user != null) {
        _showSuccessAlert('Account created successfully');
        Get.offNamed(AppRoute.emailsentconfirmation);
        return true;
      }
      return false;
    } on AuthException catch (e) {
      _handleAuthException(e);
      return false;
    } catch (e) {
      _showErrorAlert('An unexpected error occurred during sign up');
      return false;
    }
  }

  // Comprehensive Sign In Method
  Future<bool> signIn({required String email, required String password}) async {
    try {
      final authResponse = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user != null) {
        _showSuccessAlert('Successfully logged in');
        Get.offAllNamed(AppRoute.home);
        return true;
      }
      return false;
    } on AuthException catch (e) {
      _handleAuthException(e);
      return false;
    } catch (e) {
      _showErrorAlert('An unexpected error occurred during sign in');
      return false;
    }
  }

  // Handle Authentication Exceptions
  void _handleAuthException(AuthException e) {
    if (e.message.contains('User already exists')) {
      _showErrorAlert('You already have an account with this email');
    } else if (e.message.contains('Invalid login credentials')) {
      _showErrorAlert('Invalid email or password');
    } else if (e.message.contains('Email not confirmed')) {
      _showErrorAlert('Please confirm your email before signing in');
    } else {
      _showErrorAlert('Authentication failed');
    }
  }

Future<bool> handlePasswordRecovery() async {
  try {
    final session = supabase.auth.currentSession;
    
    if (session != null) {
      // Utilisez Get.to() pour naviguer vers la page de réinitialisation
      Get.to(() => ResetPasswordPage());
      return true;
    }
    
    return false;
  } catch (e) {
    // Gestion des erreurs
    return false;
  }
}
  // Méthode de réinitialisation de mot de passe améliorée
  Future<bool> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.flutter://reset-password',
      );

      _showSuccessAlert('Email de réinitialisation envoyé');
      Get.toNamed(AppRoute.emailsentconfirmationresetpassword);
      return true;
    } on AuthException catch (e) {
      _handleAuthException(e);
      return false;
    } catch (e) {
      _showErrorAlert('Une erreur est survenue lors de la réinitialisation du mot de passe');
      return false;
    }
  }

  // Méthode pour mettre à jour le mot de passe
  Future<bool> updatePassword(String newPassword) async {
  try {
    // Update the password
    await supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );

    _showSuccessAlert('Password updated successfully');
    Get.offAllNamed(AppRoute.login);
    return true;
  } on AuthException catch (e) {
    _handleAuthException(e);
    return false;
  } catch (e) {
    _showErrorAlert('Error updating password');
    return false;
  }
}

  // Déconnexion
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await supabase.auth.signOut();
      _showSuccessAlert('Déconnexion réussie');
      Get.offAllNamed(AppRoute.login);
    } catch (e) {
      _showErrorAlert('Échec de la déconnexion');
    }
  }

  // Écouteur d\'événements d\'authentification
}
