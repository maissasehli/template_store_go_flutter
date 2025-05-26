import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/shared/widgets/universal_cached_image.dart';
import 'package:store_go/features/profile/models/user_model.dart';
import 'package:store_go/app/core/config/app_config.dart';
import 'package:logger/logger.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel? user;
  static final Logger logger = Logger();

  const ProfileHeader({super.key, required this.user});

  String? _getFullImageUrl(String? imagePath) {
    logger.d('ProfileHeader: Raw image path from user: $imagePath');
    logger.d('ProfileHeader: AppConfig.baseUrl: ${AppConfig.baseUrl}');

    if (imagePath == null || imagePath.isEmpty) {
      logger.d('ProfileHeader: Image path is null or empty, returning null');
      return null;
    }

    // If the image path is already a full URL, return it as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      logger.d('ProfileHeader: Image path is already a full URL: $imagePath');
      return imagePath;
    }

    // Otherwise, combine with base URL
    final fullUrl = '${AppConfig.baseUrl}$imagePath';
    logger.d('ProfileHeader: Combined URL: $fullUrl');
    return fullUrl;
  }

  @override
  Widget build(BuildContext context) {
    logger.d('ProfileHeader: Building widget for user: ${user?.name}');
    logger.d('ProfileHeader: User object: $user');
    logger.d('ProfileHeader: User avatar field: ${user?.avatar}');

    final imageUrl = _getFullImageUrl(user?.avatar);
    logger.d('ProfileHeader: Final image URL to display: $imageUrl');

    return Column(
      children: [
        // Profile Image
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child:
                imageUrl != null
                    ? UniversalCachedImage(
                      imagePath: imageUrl,
                      source: ImageSource.network,
                      width: 100.87,
                      height: 100.87,
                      fit: BoxFit.cover,
                      errorWidget: Container(
                        width: 100.87,
                        height: 100.87,
                        color: AppColors.muted(context).withAlpha(51),
                        child: Center(
                          child: Icon(
                            Icons.person_outline,
                            color: AppColors.muted(context),
                            size: 40,
                          ),
                        ),
                      ),
                    )
                    : Container(
                      width: 100.87,
                      height: 100.87,
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
        const SizedBox(height: 12),
        // User Name and Username
        Center(
          child: Text(
            user?.name ?? 'User',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: AppColors.foreground(context),
            ),
          ),
        ),
        Center(
          child: Text(
            '@${user?.name.toLowerCase().replaceAll(' ', '') ?? 'username'}',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.mutedForeground(context),
              fontFamily: 'Poppins',
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
