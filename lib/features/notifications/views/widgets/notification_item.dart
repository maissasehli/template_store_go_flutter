import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/notifications/controller/notification_controller.dart';
import 'package:store_go/features/notifications/model/notification_model.dart';
import 'package:intl/intl.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

class NotificationItem extends StatefulWidget {
  final NotificationModel notification;

  const NotificationItem({super.key, required this.notification});

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  // Add a local variable to track read state
  late bool _isRead;

  @override
  void initState() {
    super.initState();
    // Initialize local read state from widget
    _isRead = widget.notification.isRead;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // If notification is already read, set animation to end value
    if (_isRead) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(NotificationItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update local read state when widget updates
    _isRead = widget.notification.isRead;

    // If notification is now read but wasn't before, animate
    if (widget.notification.isRead && !oldWidget.notification.isRead) {
      _animationController.forward();
    }
  }

  // Get notification title based on type and data
  String _getNotificationTitle() {
    final notificationType = widget.notification.type.toLowerCase();

    switch (notificationType) {
      case 'product':
        return 'notifications.product_notification_title'.translate();
      case 'promo':
        return 'notifications.promo_notification_title'.translate();
      case 'order':
        return 'notifications.order_notification_title'.translate();
      case 'system':
        return 'notifications.system_notification_title'.translate();
      default:
        return widget.notification.title;
    }
  }

  // Get notification content based on type and data
  String _getNotificationContent() {
    final data = widget.notification.data;
    final notificationType = widget.notification.type.toLowerCase();

    if (data == null) {
      return widget.notification.content;
    }

    switch (notificationType) {
      case 'product':
        final productName = data['productName'] ?? '';
        final price = data['price'] ?? '';
        return 'notifications.product_notification_content'
            .translate()
            .replaceAll('{productName}', productName)
            .replaceAll('{price}', price);

      case 'promo':
        final promotionName = data['promotionName'] ?? '';
        final discountValue = data['discountValue'] ?? '';
        final discountType = data['discountType'] ?? 'percentage';

        String discountText = discountValue;
        if (discountType.toLowerCase() == 'percentage') {
          discountText = '$discountValue%';
        }

        return 'notifications.promo_notification_content'
            .translate()
            .replaceAll('{promotionName}', promotionName)
            .replaceAll('{discount}', discountText);

      case 'order':
        final orderId = data['orderId'] ?? '';
        final status = data['status'] ?? '';
        return 'notifications.order_notification_content'
            .translate()
            .replaceAll('{orderId}', orderId)
            .replaceAll('{status}', status);

      default:
        return widget.notification.content;
    }
  }

  // Get image URL from data if available
  String? _getImageUrl() {
    final data = widget.notification.data;
    if (data == null) return null;

    return data['imageUrl'] as String?;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationsController>();
    final bool isRtl = LocalizationService.isRtl(context);

    // Format the date
    String formattedDate = '';
    try {
      final dateTime = DateTime.parse(widget.notification.createdAt);
      formattedDate = DateFormat('MMM d, yyyy • h:mm a').format(dateTime);
    } catch (e) {
      formattedDate = 'notifications.unknown_date'.translate();
    }

    // Get notification content
    final notificationTitle = _getNotificationTitle();
    final notificationContent = _getNotificationContent();
    final imageUrl = _getImageUrl();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(widget.notification.id),
        background: Container(
          alignment: isRtl ? Alignment.centerLeft : Alignment.centerRight,
          padding: EdgeInsets.only(right: isRtl ? 0 : 20, left: isRtl ? 20 : 0),
          decoration: BoxDecoration(
            color: AppColors.destructive(context).withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.delete,
            color: AppColors.destructiveForeground(context),
          ),
        ),
        direction:
            isRtl ? DismissDirection.startToEnd : DismissDirection.endToStart,
        onDismissed: (_) {
          controller.deleteNotification(widget.notification.id);
        },
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            onTap: () {
              if (!_isRead) {
                // Mark as read and update local state immediately
                setState(() {
                  _isRead = true;
                });

                // Run the animation
                _animationController.forward();

                // Call the controller to update the backend
                controller.markAsRead(widget.notification.id);
              }
              // Handle notification tap based on type and data
              _handleNotificationTap(widget.notification);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    _isRead
                        ? AppColors.card(context)
                        : AppColors.primary(context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      _isRead
                          ? AppColors.border(context)
                          : AppColors.primary(context).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  _getNotificationIcon(widget.notification.type, context),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          isRtl
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [
                        // Title row with unread indicator
                        Row(
                
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                notificationTitle,
                                style:
                                    LocalizationService.getLocalizedTextStyle(
                                      context,
                                      TextStyle(
                                        fontSize: 15,
                                        fontWeight:
                                            _isRead
                                                ? FontWeight.w500
                                                : FontWeight.w600,
                                        color: AppColors.foreground(context),
                                      ),
                                    ),
                              ),
                            ),
                            if (!_isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppColors.primary(context),
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Notification content
                        Text(
                          notificationContent,
                          style: LocalizationService.getLocalizedTextStyle(
                            context,
                            TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.mutedForeground(context),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Optional image
                        if (imageUrl != null)
                          Container(
                            alignment:
                                isRtl
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                            padding: const EdgeInsets.only(
                              top: 4.0,
                              bottom: 8.0,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                imageUrl,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 80,
                                    width: 80,
                                    color: AppColors.muted(context),
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: AppColors.mutedForeground(context),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                        // Date
                        Text(
                          formattedDate,
                          style: LocalizationService.getLocalizedTextStyle(
                            context,
                            TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.mutedForeground(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getNotificationIcon(String type, BuildContext context) {
    IconData iconData;
    Color iconColor;

    switch (type.toLowerCase()) {
      case 'order':
        iconData = Icons.shopping_bag_outlined;
        iconColor = Colors.green; // Keep color for visual distinction
        break;
      case 'promo':
        iconData = Icons.local_offer_outlined;
        iconColor = Colors.orange; // Keep color for visual distinction
        break;
      case 'system':
        iconData = Icons.info_outline;
        iconColor = AppColors.primary(context);
        break;
      case 'product':
        iconData = Icons.shopping_cart_outlined;
        iconColor = AppColors.accent(context);
        break;
      default:
        iconData = Icons.notifications_outlined;
        iconColor = AppColors.mutedForeground(context);
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
          Get.toNamed(
            '/orders/details',
            arguments: notification.data!['orderId'],
          );
        }
        break;
      case 'product':
        if (notification.data!.containsKey('productId')) {
          Get.toNamed(
            '/products/details',
            arguments: notification.data!['productId'],
          );
        }
        break;
      case 'promo':
        if (notification.data!.containsKey('promotionId')) {
          Get.toNamed(
            '/promotions/details/${notification.data!['promotionId']}',
          );
        } else {
          Get.toNamed('/promotions');
        }
        break;
      default:
        // Default action or no action
        break;
    }
  }
}
