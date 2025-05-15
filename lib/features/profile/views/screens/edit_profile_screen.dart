import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/features/profile/controllers/edit_profile_controller.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/profile/views/widgets/profile_edit_widgets/profile_image_widget.dart';
import 'package:store_go/features/profile/views/widgets/profile_edit_widgets/profile_name_display.dart';
import 'package:store_go/features/profile/views/widgets/profile_edit_widgets/profile_form.dart';
import 'package:store_go/features/profile/views/widgets/profile_edit_widgets/save_button.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Get the controller
  final EditProfileController controller = Get.find<EditProfileController>();

  // Variables for dropdowns
  String _selectedCountry = "Tunisia";
  String _selectedGender = "Female";

  @override
  void initState() {
    super.initState();
    // Set gender from user model if available
    if (controller.user.value?.gender != null) {
      _selectedGender = controller.user.value!.gender!.capitalize!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        leading: IconButton(
          icon: ThemeAwareSvg(
            assetPath: AssetConfig.backArrow,
            height: 24,
            width: 24,
          ),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: AppColors.foreground(context),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                // Profile Image
                ProfileImageWidget(controller: controller),
                const SizedBox(height: 16),
                // Profile Name Display
                ProfileNameDisplay(controller: controller),
                const SizedBox(height: 24),
                // Form Fields
                ProfileForm(
                  controller: controller,
                  selectedCountry: _selectedCountry,
                  selectedGender: _selectedGender,
                  onCountryChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCountry = value;
                      });
                    }
                  },
                  onGenderChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedGender = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),
                // Save Button
                SaveButton(controller: controller),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }
}
