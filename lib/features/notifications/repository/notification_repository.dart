import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/notifications/model/notification_model.dart';

class NotificationRepository {
  final ApiClient _apiClient;

  NotificationRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  // Get all notifications (read and unread)
  Future<List<NotificationModel>> getAllNotifications({int limit = 50, int offset = 0}) async {
    try {
      final response = await _apiClient.get(
        '/notifications/all?limit=$limit&offset=$offset',
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((item) => NotificationModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      throw Exception('Failed to load notifications: $e');
    }
  }

  // Get unread notifications
  Future<List<NotificationModel>> getUnreadNotifications({int limit = 50, int offset = 0}) async {
    try {
      final response = await _apiClient.get(
        '/notifications?limit=$limit&offset=$offset',
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((item) => NotificationModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load unread notifications');
      }
    } catch (e) {
      throw Exception('Failed to load unread notifications: $e');
    }
  }

  // Get unread notification count
  Future<int> getUnreadNotificationCount() async {
    try {
      final response = await _apiClient.get('/notifications/read');

      if (response.statusCode == 200) {
        return response.data['data']['count'] ?? 0;
      } else {
        throw Exception('Failed to get unread notification count');
      }
    } catch (e) {
      throw Exception('Failed to get unread notification count: $e');
    }
  }

  // Mark a notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _apiClient.put('/notifications/read/$notificationId');
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  // Mark all notifications as read
  Future<void> markAllNotificationsAsRead() async {
    try {
      await _apiClient.put('/notifications/read');
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  // Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _apiClient.delete('/notifications/$notificationId');
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  // Delete all notifications
  Future<void> deleteAllNotifications() async {
    try {
      await _apiClient.delete('/notifications');
    } catch (e) {
      throw Exception('Failed to delete all notifications: $e');
    }
  }
}