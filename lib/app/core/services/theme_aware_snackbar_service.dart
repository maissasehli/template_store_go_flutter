import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_color_extension.dart';
import 'package:store_go/app/shared/controllers/theme_controller.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';

class ThemeAwareSnackbarService {
  // Singleton pattern
  static final ThemeAwareSnackbarService _instance =
      ThemeAwareSnackbarService._internal();
  factory ThemeAwareSnackbarService() => _instance;
  ThemeAwareSnackbarService._internal();

  // Show a product notification that respects the app theme
  void showProductNotification({
    required String title,
    required String message,
    required String? imageUrl,
    required Map<String, dynamic> data,
    required Function(dynamic) onTap,
  }) {
    // Get theme controller
    final ThemeController themeController = Get.find<ThemeController>();
    final ThemeData currentTheme = themeController.theme;

    // Get colors from theme extension
    final appColors = currentTheme.extension<AppColorExtension>()!;
    final bool isRtl = LocalizationService.isRtl(Get.context!);

    // Use theme colors from AppColorExtension
    final backgroundColor = appColors.card;
    final textColor = appColors.cardForeground;
    final mutedColor = appColors.mutedForeground;

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 5),
      backgroundColor: backgroundColor,
      colorText: textColor,
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      padding: const EdgeInsets.all(12),
      titleText: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Text(
            title,
            style: LocalizationService.getLocalizedTextStyle(
              Get.context!,
              TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
      messageText: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: 60,
                height: 60,
                margin: EdgeInsets.only(
                  right: isRtl ? 0 : 12,
                  left: isRtl ? 12 : 0,
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: appColors.secondary,
                      child: Icon(Icons.image_not_supported, color: mutedColor),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: appColors.secondary,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: appColors.primary,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          // Content column
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: LocalizationService.getLocalizedTextStyle(
                    Get.context!,
                    TextStyle(fontSize: 14, color: textColor),
                  ),
                ),
                if (data.containsKey('price'))
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'notifications.price'.translate().replaceAll(
                        '{price}',
                        '${data['price']}',
                      ),
                      style: LocalizationService.getLocalizedTextStyle(
                        Get.context!,
                        TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  // Show a promotion notification that respects the app theme
  void showPromotionNotification({
    required String title,
    required String message,
    required String? imageUrl,
    required Map<String, dynamic> data,
    required Function(dynamic) onTap,
    String? discountDisplay,
  }) {
    // Get theme controller
    final ThemeController themeController = Get.find<ThemeController>();
    final ThemeData currentTheme = themeController.theme;
    final bool isRtl = LocalizationService.isRtl(Get.context!);

    // Get colors from theme extension
    final appColors = currentTheme.extension<AppColorExtension>()!;

    // Use theme colors from AppColorExtension
    final backgroundColor = appColors.card;
    final textColor = appColors.cardForeground;
    final accentColor = appColors.accent;

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 5),
      backgroundColor: backgroundColor,
      colorText: textColor,
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      padding: const EdgeInsets.all(12),
      titleText: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Text(
            title,
            style: LocalizationService.getLocalizedTextStyle(
              Get.context!,
              TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
      messageText: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Promotion image
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: 60,
              height: 60,
              margin: EdgeInsets.only(
                right: isRtl ? 0 : 12,
                left: isRtl ? 12 : 0,
              ),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child:
                  imageUrl != null
                      ? Center(
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.local_offer_outlined,
                              color: accentColor,
                              size: 30,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: accentColor,
                              ),
                            );
                          },
                        ),
                      )
                      : Icon(
                        Icons.local_offer_outlined,
                        color: accentColor,
                        size: 30,
                      ),
            ),
          ),
          // Promotion details
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'] ?? 'notifications.new_promotion'.translate(),
                  style: LocalizationService.getLocalizedTextStyle(
                    Get.context!,
                    TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                if (data.containsKey('description'))
                  Text(
                    data['description'],
                    style: LocalizationService.getLocalizedTextStyle(
                      Get.context!,
                      TextStyle(fontSize: 13, color: textColor),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    discountDisplay ??
                        'notifications.special_offer'.translate(),
                    style: LocalizationService.getLocalizedTextStyle(
                      Get.context!,
                      TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
