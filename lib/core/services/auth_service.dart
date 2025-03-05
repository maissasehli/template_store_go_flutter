import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes.dart';
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
        data: {
          'first_name': firstName,
          'last_name': lastName,
        },
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
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
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

  // Password Reset Method
  Future<bool> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.flutter://reset-callback/',
      );

      _showSuccessAlert('Password reset email has been sent');
      return true;
    } on AuthException catch (e) {
      _handleAuthException(e);
      return false;
    } catch (e) {
      _showErrorAlert('An unexpected error occurred');
      return false;
    }
  }

  // Sign Out Method
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await supabase.auth.signOut();
      _showSuccessAlert('Successfully signed out');
      Get.offAllNamed(AppRoute.login);
    } catch (e) {
      _showErrorAlert('Sign out failed');
    }
  }
}