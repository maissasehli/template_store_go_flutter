import 'package:get/get.dart';
import 'package:store_go/features/notifications/model/notification_model.dart';



// Controller for managing notifications state
class NotificationsController extends GetxController {
  // No static notifications, starting with empty list
  RxBool hasNotifications = false.obs;
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;

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
