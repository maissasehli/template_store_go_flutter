// File: lib/app/features/notification/views/widgets/empty_notification_state.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';

class EmptyNotificationState extends StatelessWidget {
  const EmptyNotificationState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Use a try-catch block to handle potential asset loading errors
          _buildAssetImage(),
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
  
  Widget _buildAssetImage() {
    try {
      return Image.asset(
        AssetConfig.bell,
        width: 80,
        height: 80,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to an icon if the asset fails to load
          return Icon(
            Icons.notifications_outlined,
            size: 80,
          );
        },
      );
    } catch (e) {
      // Fallback in case of any other error
      return Icon(
        Icons.notifications_outlined,
        size: 80,
        color: Colors.grey[300],
      );
    }
  }
}