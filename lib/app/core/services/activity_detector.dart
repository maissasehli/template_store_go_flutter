import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/app/core/services/pusher_service.dart';
import 'package:store_go/features/auth/services/auth_service.dart';

class ActivityDetector extends StatefulWidget {
  final Widget child;
  final Duration inactivityTimeout;

  const ActivityDetector({
    super.key,
    required this.child,
    this.inactivityTimeout = const Duration(minutes: 2), // 3 minute timeout
  });

  @override
  State<ActivityDetector> createState() => _ActivityDetectorState();
}

class _ActivityDetectorState extends State<ActivityDetector> {
  Timer? _inactivityTimer;
  final PusherService _pusherService = Get.find<PusherService>();
  final AuthService _authService = Get.find<AuthService>();
  final Logger _logger = Logger();
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _startInactivityTimer();
    // Initially set the user as active if authenticated
    _checkAndUpdateInitialActivityState();
  }

  Future<void> _checkAndUpdateInitialActivityState() async {
    final bool isAuthenticated = await _authService.isAuthenticated();
    if (isAuthenticated) {
      _pusherService.setUserActivityState(true);
    }
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  void _startInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(widget.inactivityTimeout, _handleInactivity);
  }

  Future<void> _handleInactivity() async {
    if (_isActive) {
      _logger.d(
        "INACTIVITY DETECTED: User has been inactive for ${widget.inactivityTimeout.inMinutes} minutes",
      );
      setState(() {
        _isActive = false;
      });

      // Update user activity state only if authenticated
      final bool isAuthenticated = await _authService.isAuthenticated();
      if (isAuthenticated) {
        await _pusherService.setUserActivityState(false);
      }
    }
  }

  Future<void> _handleUserActivity() async {
    // Reset the inactivity timer first
    _startInactivityTimer();

    // Only update if user was previously inactive
    if (!_isActive) {
      _logger.d("ACTIVITY DETECTED: User activity after inactivity period");
      setState(() {
        _isActive = true;
      });

      // Update user activity state only if authenticated
      final bool isAuthenticated = await _authService.isAuthenticated();
      if (isAuthenticated) {
        await _pusherService.setUserActivityState(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _handleUserActivity(),
      onPointerMove: (_) => _handleUserActivity(),
      child: widget.child,
    );
  }
}
