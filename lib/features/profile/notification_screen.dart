import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller to manage notifications state
    final controller = Get.put(NotificationsController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Obx(() {
        return controller.hasNotifications.value
            ? _buildNotificationsList(controller)
            : _buildEmptyState();
      }),
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AssetConfig.bell,
            width: 80,
            height: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'No Notification yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.toNamed('/categories'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              'Explore Categories',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(NotificationsController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.notifications.length,
      itemBuilder: (context, index) {
        final notification = controller.notifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.notifications_outlined, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              notification.message,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Controller for managing notifications state
class NotificationsController extends GetxController {
  RxBool hasNotifications = true.obs;
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Example notifications
    notifications.addAll([
      NotificationModel(
        id: '1',
        message:
            'Gilbert, you placed an order. check your order history for full details',
        timestamp: DateTime.now(),
      ),
      NotificationModel(
        id: '2',
        message: 'Gilbert, Thank you for shopping with StoreGo!',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: '3',
        message: 'Gilbert, your Order #456065 has been shipped!',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ]);

    // For testing empty state, uncomment this line
    // hasNotifications.value = false;
  }

  void toggleNotificationsView() {
    hasNotifications.value = !hasNotifications.value;
  }

  void clearNotifications() {
    notifications.clear();
    hasNotifications.value = false;
  }

  void addNotification(NotificationModel notification) {
    notifications.add(notification);
    hasNotifications.value = true;
  }
}

// Model for notification data
class NotificationModel {
  final String id;
  final String message;
  final DateTime timestamp;

  NotificationModel({
    required this.id,
    required this.message,
    required this.timestamp,
  });
}
