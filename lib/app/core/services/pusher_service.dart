import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pusher_client_fixed/pusher_client_fixed.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_go/app/core/services/api_client.dart';
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

  Timer? _statusUpdateTimer;
  bool _lastReportedStatus = false;
  final _statusLock = Lock(); 
  bool _isAppActive = true;

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
        '9cc5c988880ae2d93c71',
        PusherOptions(
          cluster: 'eu',
        ),
        autoConnect: false,
        enableLogging: true,
      );

      // Connect to Pusher
      _pusherClient!.connect();

      // Setup connection status handlers
      _pusherClient!.onConnectionStateChange((state) {
        debugPrint("Pusher connection state: ${state!.currentState}");

        // Update online status when connection changes
        if (state.currentState == 'connected') {
          _updateOnlineStatusWithDebounce(true);
        } else if (state.currentState == 'disconnected' ||
            state.currentState == 'disconnecting') {
          _updateOnlineStatusWithDebounce(false);
        }
      });

      _pusherClient!.onConnectionError((error) {
        debugPrint("Pusher connection error: ${error!.message}");
      });

      // Subscribe to a standard channel instead of presence channel
      _storeChannel = _pusherClient!.subscribe('store-$storeId');

      // Add any other event listeners needed
      _storeChannel!.bind('new-product', (event) {
        if (event != null && event.data != null) {
          _handleNewProductEvent(event.data!);
        }
      });

      // Save current store ID to preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_store_id', storeId);

      // Set initial online status
      updateUserOnlineStatus(true);

      Logger().i("Pusher initialized for store: $storeId and user: $appUserId");
    } catch (e) {
      Logger().e("Failed to initialize Pusher: $e");
    }
  }

  // Update online status with debounce to prevent too many API calls
  void _updateOnlineStatusWithDebounce(bool isOnline) {
    // Cancel any pending timer
    _statusUpdateTimer?.cancel();

    // Set a new timer (300ms debounce)
    _statusUpdateTimer = Timer(const Duration(milliseconds: 300), () {
      // Only update if the app is active and the status has changed
      if (_isAppActive) {
        updateUserOnlineStatus(isOnline);
      }
    });
  }

  // Handle new product notifications
  void _handleNewProductEvent(String eventData) {
    try {
      final data = jsonDecode(eventData);

      // Use Get.snackbar which doesn't need direct Overlay access
      Get.snackbar(
        'New Product Available!',
        '${data['productName']} is now available in the store',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.black,
        margin: const EdgeInsets.all(10),
        onTap: (_) {
          Get.toNamed(
            '/product-details',
            arguments: {'productId': data['productId']},
          );
        },
      );
    } catch (e) {
      Logger().e("Error handling new product event: $e");
    }
  }

  // Update app active state
  void setAppActive(bool isActive) {
    _isAppActive = isActive;
    updateUserOnlineStatus(isActive);
  }

  // Disconnect from Pusher
  Future<void> disconnect({bool skipStatusUpdate = false}) async {
    if (!skipStatusUpdate) {
      // Update status to offline before disconnecting
      if (_pusherClient != null && _currentUserId != null) {
        await updateUserOnlineStatus(false);
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

      debugPrint("Pusher disconnected");
    }
  }

  // Method to update user online status
  Future<void> updateUserOnlineStatus(bool isOnline) async {
    // Cancel any pending timer
    _statusUpdateTimer?.cancel();

    // Set a new timer (500ms debounce)
    _statusUpdateTimer = Timer(const Duration(milliseconds: 500), () async {
      await _statusLock.synchronized(() async {
        // Only update if the status has actually changed
        if (_lastReportedStatus != isOnline) {
          try {
            final payload = {
              'isOnline': isOnline,
              'lastSeen': DateTime.now().toIso8601String(),
            };
            final apiClient = Get.find<ApiClient>();
            await apiClient.post('/users/status', data: payload);
            _lastReportedStatus = isOnline; // Track what we last sent
            Logger().i("User online status updated: $isOnline");
          } catch (e) {
            Logger().e("Failed to update online status: $e");
          }
        } else {
          Logger().d("Skipping duplicate online status update: $isOnline");
        }
      });
    });
  }

}
