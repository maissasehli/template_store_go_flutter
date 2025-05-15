import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/profile/controllers/edit_profile_controller.dart';
import 'package:store_go/features/profile/views/widgets/profile_edit_widgets/profile_form.dart';
import 'package:store_go/features/profile/views/widgets/profile_edit_widgets/profile_image_widget.dart';
import 'package:store_go/features/profile/views/widgets/profile_edit_widgets/profile_name_display.dart';

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
    return Theme(
      data: Theme.of(context),
      child: Scaffold(
        backgroundColor: AppColors.background(context),
        appBar: AppBar(
          backgroundColor: AppColors.background(context),
          elevation: 0,
               leading: Container(
          margin: EdgeInsets.only(left: UIConfig.marginMedium),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.secondary(context),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, 
                    color: AppColors.secondaryForeground(context),
              size: 20),
            onPressed: () => Get.back(),
          ),
        ),
          title: Text(
            'Edit Profile',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.foreground(context),
                  fontWeight: FontWeight.bold,
                ),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary(context),
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: UIConfig.paddingLarge,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: UIConfig.marginLarge),
                    // Profile Image
                    ProfileImageWidget(controller: controller),
                    SizedBox(height: UIConfig.marginMedium),
                    // Profile Name Display
                    ProfileNameDisplay(controller: controller),
                    SizedBox(height: UIConfig.marginLarge),
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
                    SizedBox(height: UIConfig.marginLarge),
                    // Save Button
                    _buildSaveButton(context),
                    SizedBox(height: UIConfig.marginLarge),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: AppColors.primary(context),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular),
      ),
      child: TextButton(
        onPressed: () {
          controller.saveProfile();
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: UIConfig.paddingLarge,
            vertical: UIConfig.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular),
          ),
        ),
        child: Obx(() {
          return controller.isUploading.value
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: AppColors.primaryForeground(context),
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Save',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primaryForeground(context),
                        fontWeight: FontWeight.bold,
                      ),
                );
        }),
      ),
    );
  }
}