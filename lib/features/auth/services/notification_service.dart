import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

/// Service for displaying notifications/alerts/toasts to users
class NotificationService {
  final Logger _logger = Logger();

  // Show success notification
  void showSuccess(String message) {
    _logger.i('Success: $message');
    _showSnackbar(
      message: message,
      backgroundColor: Colors.green,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  // Show error notification
  void showError(String message) {
    _logger.e('Error: $message');
    _showSnackbar(
      message: message,
      backgroundColor: Colors.red,
      icon: const Icon(Icons.error, color: Colors.white),
      duration: const Duration(seconds: 5),
    );
  }

  // Show warning notification
  void showWarning(String message) {
    _logger.w('Warning: $message');
    _showSnackbar(
      message: message,
      backgroundColor: Colors.orange,
      icon: const Icon(Icons.warning, color: Colors.white),
    );
  }

  // Show info notification
  void showInfo(String message) {
    _logger.i('Info: $message');
    _showSnackbar(
      message: message,
      backgroundColor: Colors.blue,
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }

  // Private method to show a snackbar with consistent styling
  void _showSnackbar({
    required String message,
    required Color backgroundColor,
    required Widget icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Dismiss any existing snackbars
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      '', // Title is empty as we're using a custom layout
      '', // Message is empty as we're using a custom layout
      duration: duration,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(8),
      borderRadius: 8,
      snackPosition: SnackPosition.TOP,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      messageText: Row(
        children: [
          icon,
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutCirc,
      reverseAnimationCurve: Curves.easeInCirc,
    );
  }

  // For larger notifications that need user acknowledgement
  void showAlertDialog({
    required String title,
    required String message,
    String confirmButtonText = 'OK',
    VoidCallback? onConfirm,
  }) {
    _logger.i('Alert dialog: $title - $message');

    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              if (onConfirm != null) {
                onConfirm();
              }
            },
            child: Text(confirmButtonText),
          ),
        ],
      ),
    );
  }

  // For confirmation dialogs requiring user decision
  void showConfirmDialog({
    required String title,
    required String message,
    String confirmButtonText = 'Yes',
    String cancelButtonText = 'No',
    required Function() onConfirm,
    Function()? onCancel,
  }) {
    _logger.i('Confirm dialog: $title - $message');

    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              if (onCancel != null) {
                onCancel();
              }
            },
            child: Text(cancelButtonText),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              onConfirm();
            },
            child: Text(confirmButtonText),
          ),
        ],
      ),
    );
  }
}
