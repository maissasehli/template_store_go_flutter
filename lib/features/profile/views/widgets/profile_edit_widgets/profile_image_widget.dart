import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
              border: Border.all(
                color: Colors.purple.withOpacity(0.3),
                width: 2,
              ),
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
                          return Image.asset(
                            'assets/images/profile_avatar.png',
                            fit: BoxFit.cover,
                          );
                        },
                      )
                      : Image.asset(
                        'assets/images/profile_avatar.png',
                        fit: BoxFit.cover,
                      ),
            ),
          ),
          GestureDetector(
            onTap: () => _showImageSourceActionSheet(context),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.purple,
              child:
                  controller.isUploading.value
                      ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : Icon(Icons.camera_alt, size: 16, color: Colors.white),
            ),
          ),
        ],
      );
    });
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Get.back();
                  controller.pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
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
