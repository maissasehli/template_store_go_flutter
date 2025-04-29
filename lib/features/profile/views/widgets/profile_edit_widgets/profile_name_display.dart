import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/profile/controllers/edit_profile_controller.dart';

class ProfileNameDisplay extends StatelessWidget {
  final EditProfileController controller;

  const ProfileNameDisplay({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          return Text(
            controller.user.value?.name ?? 'User Name',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          );
        }),
        Obx(() {
          final username =
              controller.user.value?.name.split(' ').first.toLowerCase() ??
              'username';
          return Text(
            '@$username',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontFamily: 'Poppins',
            ),
          );
        }),
      ],
    );
  }
}
