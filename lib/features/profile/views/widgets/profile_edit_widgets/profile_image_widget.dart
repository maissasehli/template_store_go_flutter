import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/profile/controllers/edit_profile_controller.dart';
import 'package:store_go/app/core/config/app_config.dart';
import 'package:logger/logger.dart';

class ProfileImageWidget extends StatelessWidget {
  final EditProfileController controller;
  static final Logger logger = Logger();

  const ProfileImageWidget({super.key, required this.controller});

  String? _getFullImageUrl(String? imagePath) {
    logger.d('ProfileImageWidget: Raw image path from user: $imagePath');
    logger.d('ProfileImageWidget: AppConfig.baseUrl: ${AppConfig.baseUrl}');

    if (imagePath == null || imagePath.isEmpty) {
      logger.d(
        'ProfileImageWidget: Image path is null or empty, returning null',
      );
      return null;
    }

    // If the image path is already a full URL, return it as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      logger.d(
        'ProfileImageWidget: Image path is already a full URL: $imagePath',
      );
      return imagePath;
    }

    // Otherwise, combine with base URL
    final fullUrl = '${AppConfig.baseUrl}$imagePath';
    logger.d('ProfileImageWidget: Combined URL: $fullUrl');
    return fullUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasSelectedImage = controller.selectedImage.value != null;
      logger.d(
        'ProfileImageWidget: Building widget, hasSelectedImage: $hasSelectedImage',
      );
      logger.d(
        'ProfileImageWidget: Controller user: ${controller.user.value?.name}',
      );
      logger.d(
        'ProfileImageWidget: Controller user avatar: ${controller.user.value?.avatar}',
      );

      final imageUrl = _getFullImageUrl(controller.user.value?.avatar);
      logger.d('ProfileImageWidget: Final image URL to display: $imageUrl');

      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(77),
              border: Border.all(color: AppColors.border(context), width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(77),
              child:
                  hasSelectedImage
                      ? Image.file(
                        controller.selectedImage.value!,
                        fit: BoxFit.cover,
                      )
                      : imageUrl != null
                      ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.muted(context).withAlpha(51),
                            child: Center(
                              child: Icon(
                                Icons.person_outline,
                                color: AppColors.muted(context),
                                size: 40,
                              ),
                            ),
                          );
                        },
                      )
                      : Container(
                        color: AppColors.muted(context).withAlpha(51),
                        child: Center(
                          child: Icon(
                            Icons.person_outline,
                            color: AppColors.muted(context),
                            size: 40,
                          ),
                        ),
                      ),
            ),
          ),
          GestureDetector(
            onTap: () => _showImageSourceActionSheet(context),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary(context),
              child:
                  controller.isUploading.value
                      ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryForeground(context),
                        ),
                      )
                      : Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: AppColors.primaryForeground(context),
                      ),
            ),
          ),
        ],
      );
    });
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background(context),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.all(UIConfig.paddingMedium),
                child: Text(
                  'Select Photo',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: AppColors.primary(context),
                ),
                title: Text(
                  'Choose from Gallery',
                  style: TextStyle(color: AppColors.foreground(context)),
                ),
                onTap: () {
                  Get.back();
                  controller.pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: AppColors.primary(context),
                ),
                title: Text(
                  'Take a Photo',
                  style: TextStyle(color: AppColors.foreground(context)),
                ),
                onTap: () {
                  Get.back();
                  controller.pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
