import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pusher_client_fixed/pusher_client_fixed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PusherService {
  // Singleton pattern
  static final PusherService _instance = PusherService._internal();
  factory PusherService() => _instance;
  PusherService._internal();

  PusherClient? _pusherClient;
  Channel? _storeChannel;
  String? _currentStoreId;

  // Flutter notification service
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Initialize Pusher for a specific store
  Future<void> initializePusher(String storeId, String appUserId) async {
    if (_pusherClient != null && _currentStoreId == storeId) {
      // Already initialized for this store
      return;
    }

    // Close existing connection if any
    await disconnect();

    _currentStoreId = storeId;

    try {
      // Initialize Pusher client
      _pusherClient = PusherClient(
        '9cc5c988880ae2d93c71', // Replace with your actual Pusher key
        PusherOptions(
          cluster:
              'eu', // Replace with your actual Pusher cluster
          encrypted: true,
        ),
        autoConnect: false,
        enableLogging: true,
      );

      // Connect to Pusher
      _pusherClient!.connect();

      // Setup connection status handlers
      _pusherClient!.onConnectionStateChange((state) {
        debugPrint("Pusher connection state: ${state!.currentState}");
      });

      _pusherClient!.onConnectionError((error) {
        debugPrint("Pusher connection error: ${error!.message}");
      });

      // Subscribe to the store channel
      _storeChannel = _pusherClient!.subscribe('store-$storeId');

      // Listen for new product events
      _storeChannel!.bind('new-product', (event) {
        if (event != null && event.data != null) {
          _handleNewProductEvent(event.data!);
        }
      });


      // Save current store ID to preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_store_id', storeId);

      Logger().i("Pusher initialized for store: $storeId");
    } catch (e) {
      Logger().e("Failed to initialize Pusher: $e");
    }
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

  

  // Disconnect from Pusher
  Future<void> disconnect() async {
    if (_pusherClient != null) {
      if (_storeChannel != null && _currentStoreId != null) {
        _pusherClient!.unsubscribe('store-$_currentStoreId');
        _storeChannel = null;
      }

      await _pusherClient!.disconnect();
      _pusherClient = null;
      _currentStoreId = null;

      debugPrint("Pusher disconnected");
    }
  }
}
