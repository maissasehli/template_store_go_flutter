import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/shared/widgets/universal_cached_image.dart';
import 'package:store_go/features/profile/models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel? user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile Image
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: UniversalCachedImage(
              imagePath: user?.avatar ?? "none",
              source: ImageSource.network,
              width: 100.87,
              height: 100.87,
              fit: BoxFit.cover,
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
