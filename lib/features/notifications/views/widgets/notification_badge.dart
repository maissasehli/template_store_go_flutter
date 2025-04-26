// lib/features/notifications/views/widgets/notification_badge.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/notifications/controller/notification_controller.dart';

class NotificationBadge extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const NotificationBadge({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GetX<NotificationsController>(
      init: Get.put(NotificationsController()),
      builder: (controller) {
        return Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: onTap,
              child: child,
            ),
            if (controller.unreadCount.value > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    controller.unreadCount.value > 9 
                        ? '9+' 
                        : controller.unreadCount.value.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}