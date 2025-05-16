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

      // Sort notifications: unread first, then read notifications
      notificationList.sort((a, b) {
        if (a.isRead == b.isRead) {
          // If both have the same read status, sort by date (newest first)
          return DateTime.parse(
            b.createdAt,
          ).compareTo(DateTime.parse(a.createdAt));
        }
        // Put unread notifications first
        return a.isRead ? 1 : -1;
      });

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
    // Optimistic update - update UI first
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      // Create a new list with all existing notifications
      final updatedList = List<NotificationModel>.from(notifications);

      // Update the notification in place
      final oldNotification = updatedList[index];
      final updatedNotification = NotificationModel(
        id: oldNotification.id,
        type: oldNotification.type,
        title: oldNotification.title,
        content: oldNotification.content,
        isRead: true, // Mark as read
        createdAt: oldNotification.createdAt,
        data: oldNotification.data,
      );

      // Replace the original notification
      updatedList[index] = updatedNotification;

      // Resort the list (unread first, then sorted by date)
      updatedList.sort((a, b) {
        if (a.isRead == b.isRead) {
          return DateTime.parse(
            b.createdAt,
          ).compareTo(DateTime.parse(a.createdAt));
        }
        return a.isRead ? 1 : -1;
      });

      // Update the observable list
      notifications.value = updatedList;

      // Decrease unread count
      if (unreadCount.value > 0) {
        unreadCount.value--;
      }
    }

    // Make the API call in the background
    try {
      await _repository.markNotificationAsRead(notificationId);
    } catch (e) {
      print('Error marking notification as read: $e');
      // If API call fails, we might want to fetch the list again to sync
      fetchAllNotifications();
    }
  }

  Future<void> markAllAsRead() async {
    // Optimistic update - update UI immediately
    final updatedList =
        notifications
            .map(
              (notification) => NotificationModel(
                id: notification.id,
                type: notification.type,
                title: notification.title,
                content: notification.content,
                isRead: true,
                createdAt: notification.createdAt,
                data: notification.data,
              ),
            )
            .toList();

    // Sort by date since all are now read
    updatedList.sort(
      (a, b) =>
          DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)),
    );

    notifications.value = updatedList;
    unreadCount.value = 0;

    // Make API call in background
    try {
      await _repository.markAllNotificationsAsRead();
    } catch (e) {
      print('Error marking all notifications as read: $e');
      // If API call fails, we might want to fetch again to sync
      fetchAllNotifications();
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
    await fetchAllNotifications();
    await fetchUnreadCount();
  }
}
