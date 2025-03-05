// File: lib/controller/auth/google_auth_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class GoogleAuthController extends GetxController {
  final supabase = Supabase.instance.client;
  final isLoading = false.obs;
  
  // Initialize Google Sign In with client ID from environment variables
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: dotenv.env['GOOGLE_CLIENT_ID'],
    scopes: ['email', 'profile'],
  );
  
  // Method to handle Google Sign In
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      
      // Start the Google Sign In process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in flow
        throw 'Sign in canceled';
      }
      
      // Get authentication details from Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Get the ID token
      final idToken = googleAuth.idToken;
      
      if (idToken == null) {
        throw 'No ID Token found';
      }
      
      // Sign in to Supabase with Google OAuth
      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: googleAuth.accessToken,
      );
      
      if (response.user != null) {
        // Successfully signed in
        Get.offAllNamed('/home'); // Navigate to home screen
      } else {
        throw 'Failed to sign in with Google';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Method to sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await supabase.auth.signOut();
      Get.offAllNamed('/login'); // Navigate back to login screen
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign out: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}