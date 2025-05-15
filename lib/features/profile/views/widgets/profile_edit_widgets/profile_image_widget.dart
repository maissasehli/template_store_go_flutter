import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/profile/controllers/edit_profile_controller.dart';

class ProfileImageWidget extends StatelessWidget {
  final EditProfileController controller;

  const ProfileImageWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasSelectedImage = controller.selectedImage.value != null;
      final avatarUrl = controller.user.value?.avatar;

      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 100.87,
            height: 100.87,
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
                      : avatarUrl != null && avatarUrl.isNotEmpty
                      ? Image.network(
                        avatarUrl,
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
