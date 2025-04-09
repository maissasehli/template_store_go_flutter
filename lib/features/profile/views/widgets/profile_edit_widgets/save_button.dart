import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/profile/controllers/edit_profile_controller.dart';

class SaveButton extends StatelessWidget {
  final EditProfileController controller;

  const SaveButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(100),
      ),
      child: TextButton(
        onPressed: () {
          controller.saveProfile();
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Obx(() {
          return controller.isUploading.value
              ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
              : const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              );
        }),
      ),
    );
  }
}
