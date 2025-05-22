// File: lib/app/features/notification/views/widgets/empty_notification_state.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

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
              color: AppColors.card(context),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.foreground(context).withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 26.1,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Center(child: _buildBellIcon(context)),
          ),
          const SizedBox(height: 16),
          Text(
            'notifications.empty_state'.translate(),
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.foreground(context),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.toNamed('/categories'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              foregroundColor: AppColors.primaryForeground(context),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Text(
              'notifications.explore_categories'.translate(),
              style: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryForeground(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBellIcon(BuildContext context) {
    try {
      // Use Image.asset for PNG files
      return Image.asset(
        AssetConfig.bell,
        width: 70,
        height: 70,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackIcon(context);
        },
      );
    } catch (e) {
      // Fallback in case of any other error
      return _buildFallbackIcon(context);
    }
  }

  Widget _buildFallbackIcon(BuildContext context) {
    return Icon(
      Icons.notifications_outlined,
      size: 47,
      color: AppColors.muted(context),
    );
  }
}
