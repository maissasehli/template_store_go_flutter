import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/notifications/model/notification_model.dart';
import 'package:store_go/features/notifications/repository/notification_repository.dart';

class NotificationsController extends GetxController {
  final NotificationRepository _repository = NotificationRepository(
    apiClient: Get.find<ApiClient>(),
  );

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt unreadCount = 0.obs;
  final RxBool hasNotifications = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllNotifications();
    fetchUnreadCount();
  }

  Future<void> fetchAllNotifications() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final notificationList = await _repository.getAllNotifications();
      notifications.value = notificationList;
      hasNotifications.value = notificationList.isNotEmpty;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUnreadNotifications() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final notificationList = await _repository.getUnreadNotifications();
      notifications.value = notificationList;
      hasNotifications.value = notificationList.isNotEmpty;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      final count = await _repository.getUnreadNotificationCount();
      unreadCount.value = count;
    } catch (e) {
      print('Error fetching unread count: $e');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _repository.markNotificationAsRead(notificationId);
      
      // Update the notification in the list
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final updatedNotification = NotificationModel(
          id: notifications[index].id,
          type: notifications[index].type,
          title: notifications[index].title,
          content: notifications[index].content,
          isRead: true,
          createdAt: notifications[index].createdAt,
          data: notifications[index].data,
        );
        notifications[index] = updatedNotification;
      }
      
      // Update unread count
      fetchUnreadCount();
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _repository.markAllNotificationsAsRead();
      
      // Update all notifications in the list
      final updatedList = notifications.map((notification) => 
        NotificationModel(
          id: notification.id,
          type: notification.type,
          title: notification.title,
          content: notification.content,
          isRead: true,
          createdAt: notification.createdAt,
          data: notification.data,
        )
      ).toList();
      
      notifications.value = updatedList;
      unreadCount.value = 0;
    } catch (e) {
      print('Error marking all notifications as read: $e');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _repository.deleteNotification(notificationId);
      
      // Remove the notification from the list
      notifications.removeWhere((n) => n.id == notificationId);
      hasNotifications.value = notifications.isNotEmpty;
      
      // Update unread count if necessary
      fetchUnreadCount();
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  Future<void> deleteAllNotifications() async {
    try {
      await _repository.deleteAllNotifications();
      
      // Clear the list
      notifications.clear();
      hasNotifications.value = false;
      unreadCount.value = 0;
    } catch (e) {
      print('Error deleting all notifications: $e');
    }
  }

  // Pull to refresh functionality
  Future<void> refreshNotifications() async {
    return fetchAllNotifications();
  }
}