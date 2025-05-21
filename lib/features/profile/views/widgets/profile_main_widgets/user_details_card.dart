import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/profile/models/user_model.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

class UserDetailsCard extends StatelessWidget {
  final UserModel? user;

  const UserDetailsCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final bool isRtl = LocalizationService.isRtl(context);
    final TextDirection textDirection =
        isRtl ? TextDirection.rtl : TextDirection.ltr;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment:
            isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: textDirection,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                user?.name ?? 'profile.user'.translate(),
                style: LocalizationService.getLocalizedTextStyle(
                  context,
                  TextStyle(
                    fontSize: 16,
                    color: AppColors.foreground(context),
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Gabarito',
                  ),
                ),
              ),
              _buildEditProfileButton(context),
            ],
          ),
          Align(
            alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              user?.email ?? 'email@example.com',
              style: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(
                  fontSize: 15,
                  color: AppColors.mutedForeground(context),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          if (user?.gender != null)
            Align(
              alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                '${'profile.gender'.translate()}: ${user?.gender}',
                style: LocalizationService.getLocalizedTextStyle(
                  context,
                  TextStyle(
                    fontSize: 15,
                    color: AppColors.mutedForeground(context),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          if (user?.ageRange != null)
            Align(
              alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                '${'profile.age_range'.translate()}: ${user?.ageRange}',
                style: LocalizationService.getLocalizedTextStyle(
                  context,
                  TextStyle(
                    fontSize: 15,
                    color: AppColors.mutedForeground(context),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEditProfileButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.toNamed('/edit-profile');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary(context),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        minimumSize: const Size(0, 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(66.3),
        ),
      ),
      child: Text(
        'profile.edit_profile'.translate(),
        style: LocalizationService.getLocalizedTextStyle(
          context,
          TextStyle(
            fontSize: 12,
            color: AppColors.primaryForeground(context),
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
