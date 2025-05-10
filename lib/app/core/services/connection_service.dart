
import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ConnectionService extends GetxService {
  final _connectivity = Connectivity();
  final _logger = Logger();
  final RxBool isConnected = true.obs;
  late StreamSubscription<ConnectivityResult> _subscription;

  // For debouncing connection changes to avoid flickering notifications
  Timer? _debounceTimer;
  // Track if the snackbar is currently shown to prevent duplicates
  bool _isSnackbarActive = false;
  // Timer for periodic connectivity checks
  Timer? _periodicCheckTimer;

  Future<ConnectionService> init() async {
    // Check initial connection status with actual internet check
    await checkInternetConnection();

    // Listen for connection changes
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      // Debounce rapid connectivity changes
      if (_debounceTimer?.isActive ?? false) {
        _debounceTimer!.cancel();
      }

      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        // Do a real connectivity check instead of just relying on connectivity result
        checkInternetConnection();
      });
    });

    // Set up periodic checks every 30 seconds
    _periodicCheckTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      checkInternetConnection();
    });

    return this;
  }

  // Method to check actual internet connectivity, not just network interface
  Future<bool> checkInternetConnection() async {
    ConnectivityResult connectivityResult =
        await _connectivity.checkConnectivity();

    // If device reports no connectivity, we're definitely offline
    if (connectivityResult == ConnectivityResult.none) {
      _updateConnectionStatus(false);
      return false;
    }

    // Do an actual internet check by pinging a reliable host
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _updateConnectionStatus(true);
        return true;
      }
    } catch (_) {
      _updateConnectionStatus(false);
      return false;
    }

    // Default fallback if the above check somehow fails but doesn't throw
    _updateConnectionStatus(false);
    return false;
  }

  void _updateConnectionStatus(bool connected) {
    final wasConnected = isConnected.value;
    isConnected.value = connected;

    _logger.i('Connection status changed: ${isConnected.value}');

    // Only show notification when connection status changes
    if (wasConnected != isConnected.value) {
      _showConnectionStatusNotification(isConnected.value);
    }
  }

  void _showConnectionStatusNotification(bool connected) {
    // Prevent showing if a snackbar is already active
    if (_isSnackbarActive) {
      // log snackbar active detected
      _logger.i('Snackbar is already active, not showing another one.');
      Get.closeCurrentSnackbar();
    }

    _isSnackbarActive = true;

    final snackbar = GetSnackBar(
      title: connected ? 'Connected' : 'No Connection',
      message:
          connected
              ? 'Your internet connection has been restored'
              : 'You are currently offline',
      backgroundColor: connected ? Colors.green : Colors.red,
      messageText: Text(
        connected
            ? 'Your internet connection has been restored'
            : 'You are currently offline',
        style: const TextStyle(color: Colors.white),
      ),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(8),
      borderRadius: 8.0,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutCirc,
      snackStyle: SnackStyle.FLOATING,
      onTap: (_) {
        _isSnackbarActive = false;
        Get.closeCurrentSnackbar();
      },
    );

    Get.showSnackbar(snackbar);
    Future.delayed(snackbar.duration ?? const Duration(seconds: 3), () {
      _isSnackbarActive = false;
    });
  }

  @override
  void onClose() {
    _subscription.cancel();
    _debounceTimer?.cancel();
    _periodicCheckTimer?.cancel();
    super.onClose();
  }
}
