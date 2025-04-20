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
          // Bell icon with circular background and shadow
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF686868).withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 26.1,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Center(
              child: _buildBellIcon(),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Notification yet',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.toNamed('/categories'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: const Text(
              'Explore Categories',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBellIcon() {
    try {
      // Use Image.asset for PNG files
      return Image.asset(
        AssetConfig.bell,
        width: 70,
        height: 70,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackIcon();
        },
      );
    } catch (e) {
      // Fallback in case of any other error
      return _buildFallbackIcon();
    }
  }

  Widget _buildFallbackIcon() {
    return const Icon(
      Icons.notifications_outlined,
      size: 47,
      color: Colors.grey,
    );
  }
}