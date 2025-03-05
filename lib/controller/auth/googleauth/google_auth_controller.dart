import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:store_go/core/constants/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleAuthController extends GetxController {
  final supabase = Supabase.instance.client;
  final isLoading = false.obs;

  // Initialize Google Sign In with more robust configuration
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: dotenv.env['GOOGLE_CLIENT_ID'],
    scopes: ['email', 'profile'],
  );

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      // Explicitly request sign out first to clear any previous sessions
      await _googleSignIn.signOut();

      // Start the Google Sign In process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw 'Sign in canceled';
      }

      // Get authentication details from Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Get the ID token and access token
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null || accessToken == null) {
        throw 'Authentication tokens missing';
      }

      // Sign in to Supabase with Google OAuth
      final AuthResponse response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user != null) {
        // Successfully signed in
        Get.offAllNamed(AppRoute.home);
      } else {
        throw 'Failed to sign in with Google';
      }
    } catch (e) {
      // More detailed error handling
      print('Google Sign-In Error: $e');
      Get.snackbar(
        'Authentication Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await supabase.auth.signOut();
      Get.offAllNamed(AppRoute.login);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign out: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}