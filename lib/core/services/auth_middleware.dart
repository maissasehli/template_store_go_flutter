import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthMiddlewareService extends GetxService {
  late SharedPreferences sharedPreferences;
  final supabase = Supabase.instance.client;

  Future<AuthMiddlewareService> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    
    // Check if the user is logged in with Supabase at startup
    final session = supabase.auth.currentSession;
    if (session != null) {
      await sharedPreferences.setBool('is_logged_in', true);
    }
    
    return this;
  }
  
  // Save user profile information
  Future<void> saveUserProfile(String gender, String ageRange) async {
    await sharedPreferences.setString('user_gender', gender);
    await sharedPreferences.setString('user_age_range', ageRange);
    await sharedPreferences.setBool('profile_completed', true);
    
    // Update user metadata in Supabase if the user is logged in
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

  // Check if the profile is completed
  bool isProfileCompleted() {
    return sharedPreferences.getBool('profile_completed') ?? false;
  }

  // Check if the user is logged in (via SharedPreferences and Supabase)
  bool isLoggedIn() {
    // First, check in SharedPreferences
    bool isLoggedInLocal = sharedPreferences.getBool('is_logged_in') ?? false;
    
    // Also check with Supabase
    final session = supabase.auth.currentSession;
    
    // Update SharedPreferences if necessary
    if (session != null && !isLoggedInLocal) {
      sharedPreferences.setBool('is_logged_in', true);
      return true;
    } else if (session == null && isLoggedInLocal) {
      sharedPreferences.setBool('is_logged_in', false);
      return false;
    }
    
    return isLoggedInLocal;
  }
  
  // Save user session after login
  Future<void> saveUserSession(User user) async {
    await sharedPreferences.setString('user_id', user.id);
    await sharedPreferences.setBool('is_logged_in', true);
    
    // Optional: Save additional user information
    if (user.userMetadata != null) {
      if (user.userMetadata!['first_name'] != null) {
        await sharedPreferences.setString('first_name', user.userMetadata!['first_name']);
      }
      if (user.userMetadata!['last_name'] != null) {
        await sharedPreferences.setString('last_name', user.userMetadata!['last_name']);
      }
    }
  }
  
  // Method to force a local logout (without logging out from Supabase)
  Future<void> clearLocalSession() async {
    await sharedPreferences.remove('user_id');
    await sharedPreferences.remove('first_name');
    await sharedPreferences.remove('last_name');
    await sharedPreferences.setBool('is_logged_in', false);
    await sharedPreferences.setBool('profile_completed', false);
  }
}
