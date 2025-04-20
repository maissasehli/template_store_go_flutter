import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/app/core/config/app_config.dart';
import 'package:store_go/app/core/services/pusher_service.dart'; // Add this import
import 'package:store_go/features/auth/services/auth_service.dart';
import 'package:store_go/features/auth/services/token_manager.dart';

class LifecycleObserver extends GetxController with WidgetsBindingObserver {
  final AuthService _authService = Get.find<AuthService>();
  final TokenManager _tokenManager = Get.find<TokenManager>();
  late final PusherService _pusherService; // Add this

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _pusherService = Get.find<PusherService>(); // Initialize the reference

    // If user is already logged in, initialize Pusher
    _updateLoginStatus();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    // Disconnect Pusher when observer is closed
    _pusherService.disconnect();
    super.onClose();
  }
  // Method to update the login status
  Future<void> _updateLoginStatus() async {
    final isLoggedIn = await _authService.isAuthenticated();
    // Initialize Pusher if needed
    if (isLoggedIn) {
      _initializePusherIfNeeded();
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // Handle token refresh and other resumption logic
      _authService.handleAppResume();

      // Re-initialize Pusher connection if needed
      final isLoggedIn = await _authService.isAuthenticated();
    if (isLoggedIn) {
      _initializePusherIfNeeded();
    }
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // Optionally disconnect Pusher to save resources when app is in background
      // Uncomment if you want to disconnect when app goes to background
      // _pusherService.disconnect();
    }
  }

  // Helper method to initialize Pusher if user is logged in
  Future<void> _initializePusherIfNeeded() async{
    try {
      final storeId = AppConfig.storeId;
      final userId = await _tokenManager.getUserId();

      // Initialize or reconnect Pusher
      _pusherService.initializePusher(storeId, userId!);
        } catch (e) {
      Logger().e("Failed to initialize Pusher: $e");
    }
  }
}
