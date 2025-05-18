// filepath: c:\Users\wassi\OneDrive\Documents\Projects\mobile\fashion_template\lib\app\core\services\pusher_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pusher_client_fixed/pusher_client_fixed.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_go/app/core/config/app_config.dart';
import 'package:store_go/app/core/config/app_notification_type.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/app/core/services/theme_aware_snackbar_service.dart';
import 'package:synchronized/synchronized.dart';

class PusherService {
  // Singleton pattern
  static final PusherService _instance = PusherService._internal();
  factory PusherService() => _instance;
  PusherService._internal();

  PusherClient? _pusherClient;
  Channel? _storeChannel;
  String? _currentStoreId;
  String? _currentUserId;

  // Status management
  Timer? _statusUpdateTimer;
  bool _lastReportedStatus = false;
  final _statusLock = Lock();

  // Simplified state tracking
  bool _isAppInForeground = true; // Managed by LifecycleObserver
  bool _isUserActive = true; // Managed by ActivityDetector

  final Logger _logger = Logger();

  // Flutter notification service
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Initialize Pusher for a specific store
  Future<void> initializePusher(String storeId, String appUserId) async {
    if (_pusherClient != null &&
        _currentStoreId == storeId &&
        _currentUserId == appUserId) {
      // Already initialized for this store and user
      return;
    }

    // Close existing connection if any
    await disconnect();

    _currentStoreId = storeId;
    _currentUserId = appUserId;

    try {
      // Initialize Pusher client
      _pusherClient = PusherClient(
        AppConfig.publicPusherKey,
        PusherOptions(cluster: AppConfig.publicPusherCluster),
        autoConnect: false,
        enableLogging: true,
      );

      // Connect to Pusher
      _pusherClient!.connect();

      // Setup connection status handlers
      _pusherClient!.onConnectionStateChange((state) {
        _logger.d("Pusher connection state: ${state!.currentState}");

        // Update online status when connection changes
        if (state.currentState == 'connected') {
          _calculateAndUpdateStatus();
        } else if (state.currentState == 'disconnected' ||
            state.currentState == 'disconnecting') {
          _updateStatusWithDebounce(false, force: true);
        }
      });

      _pusherClient!.onConnectionError((error) {
        _logger.e("Pusher connection error: ${error!.message}");
      });

      // Subscribe to a standard channel instead of presence channel
      _storeChannel = _pusherClient!.subscribe('store-$storeId');

      // Add any other event listeners needed
      _storeChannel!.bind(AppNotificationType.newProduct, (event) {
        if (event != null && event.data != null) {
          _handleNewProductEvent(event.data!);
        }
      });

      // Add the promotion event listener
      _storeChannel!.bind(AppNotificationType.newPromotion, (event) {
        if (event != null && event.data != null) {
          _handleNewPromotionEvent(event.data!);
        }
      });

      // Save current store ID to preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_store_id', storeId);

      // Set initial online status
      _calculateAndUpdateStatus(force: true);

      _logger.d("Pusher initialized for store: $storeId and user: $appUserId");
    } catch (e) {
      _logger.e("Failed to initialize Pusher: $e");
    }
  }

  // Calculate the effective online status based on foreground and activity states
  void _calculateAndUpdateStatus({bool force = false}) {
    // User is considered online if app is in foreground AND user is active
    bool effectiveStatus = _isAppInForeground && _isUserActive;
    _updateStatusWithDebounce(effectiveStatus, force: force);

    _logger.d(
      "Calculated status: $effectiveStatus (appForeground: $_isAppInForeground, userActive: $_isUserActive)",
    );
  }

  // Update online status with debounce to prevent too many API calls
  void _updateStatusWithDebounce(bool isOnline, {bool force = false}) {
    // Cancel any pending timer
    _statusUpdateTimer?.cancel();

    // Set a new timer (300ms debounce)
    _statusUpdateTimer = Timer(const Duration(milliseconds: 300), () {
      _sendStatusUpdate(isOnline, force: force);
    });
  }

  // Core method to send status updates to the server
  Future<void> _sendStatusUpdate(bool isOnline, {bool force = false}) async {
    await _statusLock.synchronized(() async {
      // Only update if forced or status has changed
      if (force || _lastReportedStatus != isOnline) {
        try {
          _logger.d(
            "Sending status update to server: $isOnline (force: $force)",
          );

          final payload = {
            'isOnline': isOnline,
            'lastSeen': DateTime.now().toIso8601String(),
          };

          final apiClient = Get.find<ApiClient>();
          await apiClient.post('/users/status', data: payload);

          _lastReportedStatus = isOnline;
          _logger.d("User online status updated successfully to: $isOnline");
        } catch (e) {
          _logger.e("Failed to update online status: $e");
        }
      } else {
        _logger.d("Skipping duplicate online status update: $isOnline");
      }
    });
  }

  // Public API for updating app foreground state (called by LifecycleObserver)
  Future<void> setAppForegroundState(bool isInForeground) async {
    _isAppInForeground = isInForeground;
    _logger.d("App foreground state set to: $isInForeground");

    // Calculate and update status
    _calculateAndUpdateStatus(force: true);
  }

  // Public API for updating user activity state (called by ActivityDetector)
  Future<void> setUserActivityState(bool isActive) async {
    _isUserActive = isActive;
    _logger.d("User activity state set to: $isActive");

    // Calculate and update status
    _calculateAndUpdateStatus(force: true);
  }

  // Handle new product notifications
  void _handleNewProductEvent(String eventData) {
    try {
      final data = jsonDecode(eventData);
      final String? imageUrl = data['imageUrl'];
      
      // Use the theme-aware service from GetX dependency injection
      final snackbarService = Get.find<ThemeAwareSnackbarService>();
      
      snackbarService.showProductNotification(
        title: 'New Product Available!',
        message: '${data['productName']} is now available in the store',
        imageUrl: imageUrl,
        data: data,
        onTap: (_) {
          Get.toNamed(
            AppRoute.productDetail.replaceAll(':id', data["productId"]),
          );
        },
      );
    } catch (e) {
      _logger.e("Error handling new product event: $e");
    }
  }

  // Handle new promotion notifications
  void _handleNewPromotionEvent(String eventData) {
    try {
      final data = jsonDecode(eventData);
      final String? imageUrl = data['promotionImage'];
      final String promotionId = data['promotionId'] ?? '';
      final String? discountDisplay = data['discountDisplay'];
      
      // Use the theme-aware service from GetX dependency injection
      final snackbarService = Get.find<ThemeAwareSnackbarService>();
      
      snackbarService.showPromotionNotification(
        title: 'New Promotion Available!',
        message: '${data['name']} - Limited time offer',
        imageUrl: imageUrl,
        discountDisplay: discountDisplay,
        data: data,
        onTap: (_) {
          // Navigate to promotion details or promotions list
          if (promotionId.isNotEmpty) {
            Get.toNamed('/promotions/details/$promotionId');
          } else {
            Get.toNamed('/promotions');
          }
        },
      );
    } catch (e) {
      _logger.e("Error handling new promotion event: $e");
    }
  }

  // Disconnect from Pusher
  Future<void> disconnect({bool skipStatusUpdate = false}) async {
    if (!skipStatusUpdate) {
      // Update status to offline before disconnecting
      if (_pusherClient != null && _currentUserId != null) {
        await _sendStatusUpdate(false, force: true);
      }
    }

    // Clear timers
    _statusUpdateTimer?.cancel();

    if (_pusherClient != null) {
      if (_storeChannel != null && _currentStoreId != null) {
        // Use the regular channel name instead of presence channel
        _pusherClient!.unsubscribe('store-$_currentStoreId');
        _storeChannel = null;
      }

      await _pusherClient!.disconnect();
      _pusherClient = null;
      _currentStoreId = null;
      _currentUserId = null;

      _logger.d("Pusher disconnected");
    }
  }

  // Reset state (useful when user logs out)
  void resetState() {
    _lastReportedStatus = false;
    _isAppInForeground = true;
    _isUserActive = true;
    _logger.d("PusherService state reset");
  }

  // For debugging
  void traceState() {
    _logger.d(
      "STATE TRACE: _lastReportedStatus=$_lastReportedStatus, _isAppInForeground=$_isAppInForeground, _isUserActive=$_isUserActive",
    );
  }
}
