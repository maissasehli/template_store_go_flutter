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
    final isLoggedIn = await _authService.isAuthenticated();

    if (!isLoggedIn) return;

    if (state == AppLifecycleState.resumed) {
      // App is in foreground - user is "online"
      await _initializePusherIfNeeded();

      // Update online status directly
      final pusherService = Get.find<PusherService>();
      await pusherService.updateUserOnlineStatus(true);
    } else if (state == AppLifecycleState.paused) {
      // App is in background - user is "away" or "offline"
      final pusherService = Get.find<PusherService>();
      await pusherService.updateUserOnlineStatus(false);
    } else if (state == AppLifecycleState.detached) {
      // App is being destroyed/terminated
      final pusherService = Get.find<PusherService>();

      // Update status to offline before disconnecting
      await pusherService.updateUserOnlineStatus(false);

      // Disconnect Pusher with skipStatusUpdate=true since we already updated status
      await pusherService.disconnect(skipStatusUpdate: true);

      Logger().i("App is being destroyed, user status updated to offline");
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
