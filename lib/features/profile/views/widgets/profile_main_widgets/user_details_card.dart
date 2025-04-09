
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/profile/models/user_model.dart';

class UserDetailsCard extends StatelessWidget {
  final UserModel? user;

  const UserDetailsCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                user?.name ?? 'User',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.foreground(context),
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Gabarito',
                ),
              ),
              _buildEditProfileButton(context),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              user?.email ?? 'email@example.com',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.mutedForeground(context),
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(height: 4),
          if (user?.gender != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Gender: ${user?.gender}',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.mutedForeground(context),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          if (user?.ageRange != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Age Range: ${user?.ageRange}',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.mutedForeground(context),
                  fontFamily: 'Poppins',
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
        'Edit Profile',
        style: TextStyle(
          fontSize: 12,
          color: AppColors.primaryForeground(context),
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
