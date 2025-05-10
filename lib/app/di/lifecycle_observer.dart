import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/app/core/config/app_config.dart';
import 'package:store_go/app/core/services/pusher_service.dart';
import 'package:store_go/features/auth/services/auth_service.dart';
import 'package:store_go/features/auth/services/token_manager.dart';

class LifecycleObserver extends GetxController with WidgetsBindingObserver {
  final AuthService _authService = Get.find<AuthService>();
  final TokenManager _tokenManager = Get.find<TokenManager>();
  late final PusherService _pusherService;
  final Logger _logger = Logger();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _pusherService = Get.find<PusherService>();

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
      _logger.d("App lifecycle: RESUMED");
      // Initialize Pusher if needed when app is resumed
      await _initializePusherIfNeeded();

      // Update app foreground state to true (app is in foreground)
      await _pusherService.setAppForegroundState(true);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _logger.d(
        "App lifecycle: ${state == AppLifecycleState.paused ? 'PAUSED' : 'INACTIVE'}",
      );

      // Update app foreground state to false (app is in background)
      await _pusherService.setAppForegroundState(false);
    } else if (state == AppLifecycleState.detached) {
      _logger.d("App lifecycle: DETACHED");

      // Update app foreground state to false before disconnecting
      await _pusherService.setAppForegroundState(false);

      // Disconnect Pusher with skipStatusUpdate=true since we already updated status
      await _pusherService.disconnect(skipStatusUpdate: true);
    }
  }

  // Helper method to initialize Pusher if user is logged in
  Future<void> _initializePusherIfNeeded() async {
    try {
      final storeId = AppConfig.storeId;
      final userId = await _tokenManager.getUserId();

      if (userId != null) {
        // Initialize or reconnect Pusher
        await _pusherService.initializePusher(storeId, userId);
      } else {
        _logger.w("Cannot initialize Pusher: User ID is null");
      }
    } catch (e) {
      _logger.e("Failed to initialize Pusher: $e");
    }
  }
}
