import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/services/pusher_service.dart';

class ActivityDetector extends StatefulWidget {
  final Widget child;
  final Duration inactivityTimeout;

  const ActivityDetector({
    super.key,
    required this.child,
    this.inactivityTimeout = const Duration(
      minutes: 3,
    ), // Reduced from 5 to 3 min
  });

  @override
  State<ActivityDetector> createState() => _ActivityDetectorState();
}

class _ActivityDetectorState extends State<ActivityDetector>
    with WidgetsBindingObserver {
  Timer? _inactivityTimer;
  bool _isActive = true;
  final PusherService _pusherService = Get.find<PusherService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startInactivityTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // App came to foreground
      _handleUserActivity();
      _pusherService.setAppActive(true);
    } else if (state == AppLifecycleState.paused) {
      // App went to background
      setState(() {
        _isActive = false;
      });
      _pusherService.setAppActive(false);
    }
  }

  void _startInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(widget.inactivityTimeout, _handleInactivity);
  }

  void _handleInactivity() {
    if (_isActive) {
      setState(() {
        _isActive = false;
      });
      // Update status to "away" but not fully offline
      _pusherService.updateUserOnlineStatus(false);
    }
  }

  void _handleUserActivity() {
    _startInactivityTimer();
    if (!_isActive) {
      setState(() {
        _isActive = true;
      });
      // User is active again
      _pusherService.updateUserOnlineStatus(true);
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
