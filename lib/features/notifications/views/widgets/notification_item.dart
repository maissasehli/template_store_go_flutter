import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/notifications/controller/notification_controller.dart';
import 'package:store_go/features/notifications/model/notification_model.dart';
import 'package:intl/intl.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const NotificationItem({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationsController>();
    
    // Format the date
    String formattedDate = '';
    try {
      final dateTime = DateTime.parse(notification.createdAt);
      formattedDate = DateFormat('MMM d, yyyy • h:mm a').format(dateTime);
    } catch (e) {
      formattedDate = 'Unknown date';
    }

    return Dismissible(
      key: Key(notification.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        controller.deleteNotification(notification.id);
      },
      child: GestureDetector(
        onTap: () {
          if (!notification.isRead) {
            controller.markAsRead(notification.id);
          }
          // Handle notification tap based on type and data
          _handleNotificationTap(notification);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.grey[100] : Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: notification.isRead ? Colors.grey.withOpacity(0.2) : Colors.blue.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _getNotificationIcon(notification.type),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.content,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!notification.isRead)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getNotificationIcon(String type) {
    IconData iconData;
    Color iconColor;

    switch (type.toLowerCase()) {
      case 'order':
        iconData = Icons.shopping_bag_outlined;
        iconColor = Colors.green;
        break;
      case 'promo':
        iconData = Icons.local_offer_outlined;
        iconColor = Colors.orange;
        break;
      case 'system':
        iconData = Icons.info_outline;
        iconColor = Colors.blue;
        break;
      default:
        iconData = Icons.notifications_outlined;
        iconColor = Colors.grey[700]!;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, size: 20, color: iconColor),
    );
  }

  void _handleNotificationTap(NotificationModel notification) {
    // Handle navigation based on notification type and data
    if (notification.data == null) return;

    switch (notification.type.toLowerCase()) {
      case 'order':
        if (notification.data!.containsKey('orderId')) {
          Get.toNamed('/orders/details', arguments: notification.data!['orderId']);
        }
        break;
      case 'product':
        if (notification.data!.containsKey('productId')) {
          Get.toNamed('/products/details', arguments: notification.data!['productId']);
        }
        break;
      case 'promo':
        Get.toNamed('/promotions');
        break;
      default:
        // Default action or no action
        break;
    }
  }
}