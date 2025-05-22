import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/features/profile/controllers/edit_profile_controller.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/profile/views/widgets/profile_edit_widgets/profile_form.dart';
import 'package:store_go/features/profile/views/widgets/profile_edit_widgets/profile_image_widget.dart';
import 'package:store_go/features/profile/views/widgets/profile_edit_widgets/profile_name_display.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/theme/app_theme.dart';

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

  // Create focus node list to manage focus
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    // Set gender from user model if available
    if (controller.user.value?.gender != null) {
      _selectedGender = controller.user.value!.gender!.capitalize!;
    }
  }

  @override
  void dispose() {
    // Clean up all focus nodes
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // Helper method to unfocus all text fields
  void _unfocusAll() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocusAll, // Unfocus all fields when tapping outside
      child: Scaffold(
        backgroundColor: AppColors.background(context),
        appBar: AppBar(
          backgroundColor: AppColors.background(context),
          leading: IconButton(
            icon: ThemeAwareSvg(
              assetPath:
                  LocalizationService.isRtl(context)
                      ? AssetConfig.arrowRight
                      : AssetConfig.arrowLeft,
              height: 24,
              width: 24,
            ),
            onPressed: () => Get.back(),
          ),
          elevation: 0,
          title: Text(
            'profile.edit_profile'.translate(),
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                color: AppColors.foreground(context),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
                        _unfocusAll(); // Also unfocus when changing dropdown
                        if (value != null) {
                          setState(() {
                            _selectedCountry = value;
                          });
                        }
                      },
                      onGenderChanged: (value) {
                        _unfocusAll(); // Also unfocus when changing dropdown
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
        borderRadius: BorderRadius.circular(AppTheme.globalButtonsRadius),
      ),
      child: TextButton(
        onPressed: () {
          _unfocusAll(); // Unfocus before saving
          controller.saveProfile();
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: UIConfig.paddingLarge,
            vertical: UIConfig.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.globalButtonsRadius),
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
                'common.save'.translate(),
                style: LocalizationService.getLocalizedTextStyle(
                  context,
                  TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryForeground(context),
                  ),
                ),
              );
        }),
      ),
    );
  }
}
