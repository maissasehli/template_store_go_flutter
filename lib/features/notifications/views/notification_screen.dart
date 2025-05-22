import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/features/notifications/controller/notification_controller.dart';
import 'package:store_go/features/notifications/views/widgets/empty_notification_state.dart';
import 'package:store_go/features/notifications/views/widgets/notification_item.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

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
            assetPath:
                LocalizationService.isRtl(context)
                    ? AssetConfig.arrowRight
                    : AssetConfig.arrowLeft,
            height: 24,
            width: 24,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'notifications.title'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              color: AppColors.foreground(context),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
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
                      'notifications.mark_all_read'.translate(),
                      style: LocalizationService.getLocalizedTextStyle(
                        context,
                        TextStyle(color: AppColors.foreground(context)),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete_all',
                    child: Text(
                      'notifications.delete_all'.translate(),
                      style: LocalizationService.getLocalizedTextStyle(
                        context,
                        TextStyle(color: AppColors.destructive(context)),
                      ),
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
                  'notifications.load_error'.translate(),
                  style: LocalizationService.getLocalizedTextStyle(
                    context,
                    TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.foreground(context),
                    ),
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
                    'common.try_again'.translate(),
                    style: LocalizationService.getLocalizedTextStyle(
                      context,
                      TextStyle(color: AppColors.primaryForeground(context)),
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
            'notifications.delete_confirmation_title'.translate(),
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(color: AppColors.cardForeground(context)),
            ),
          ),
          content: Text(
            'notifications.delete_confirmation_message'.translate(),
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(color: AppColors.cardForeground(context)),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'common.cancel'.translate(),
                style: LocalizationService.getLocalizedTextStyle(
                  context,
                  TextStyle(color: AppColors.primary(context)),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'common.delete'.translate(),
                style: LocalizationService.getLocalizedTextStyle(
                  context,
                  TextStyle(color: AppColors.destructive(context)),
                ),
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
