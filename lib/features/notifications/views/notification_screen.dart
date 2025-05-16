import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/features/notifications/controller/notification_controller.dart';
import 'package:store_go/features/notifications/views/widgets/empty_notification_state.dart';
import 'package:store_go/features/notifications/views/widgets/notification_item.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) {
    // Controller to manage notifications state
    final controller = Get.put(NotificationsController());

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        leading: IconButton(
          icon: ThemeAwareSvg(
            assetPath: AssetConfig.backArrow,
            height: 24,
            width: 24,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.foreground(context),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AppColors.foreground(context)),
            onSelected: (value) {
              if (value == 'mark_all_read') {
                controller.markAllAsRead();
              } else if (value == 'delete_all') {
                _showDeleteConfirmationDialog(context, controller);
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'mark_all_read',
                    child: Text(
                      'Mark all as read',
                      style: TextStyle(color: AppColors.foreground(context)),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete_all',
                    child: Text(
                      'Delete all',
                      style: TextStyle(color: AppColors.destructive(context)),
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary(context)),
          );
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Failed to load notifications',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.foreground(context),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchAllNotifications(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary(context),
                    foregroundColor: AppColors.primaryForeground(context),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(
                    'Try Again',
                    style: TextStyle(
                      color: AppColors.primaryForeground(context),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return controller.hasNotifications.value
            ? _buildNotificationsList(controller)
            : const EmptyNotificationState();
      }),
      floatingActionButton: Obx(() {
        return controller.hasNotifications.value
            ? FloatingActionButton(
              onPressed: () => controller.fetchAllNotifications(),
              backgroundColor: AppColors.primary(context),
              foregroundColor: AppColors.primaryForeground(context),
              child: const Icon(Icons.refresh),
            )
            : const SizedBox.shrink();
      }),
    );
  }

  Widget _buildNotificationsList(NotificationsController controller) {
    return Builder(
      builder: (BuildContext context) {
        return RefreshIndicator(
          onRefresh: controller.refreshNotifications,
          color: AppColors.primary(context),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return NotificationItem(notification: notification);
            },
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    NotificationsController controller,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.card(context),
          title: Text(
            'Delete All Notifications',
            style: TextStyle(color: AppColors.cardForeground(context)),
          ),
          content: Text(
            'Are you sure you want to delete all notifications? This action cannot be undone.',
            style: TextStyle(color: AppColors.cardForeground(context)),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.primary(context)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(color: AppColors.destructive(context)),
              ),
              onPressed: () {
                controller.deleteAllNotifications();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
