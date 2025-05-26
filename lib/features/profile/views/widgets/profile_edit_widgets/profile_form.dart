import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/profile/controllers/edit_profile_controller.dart';
import 'package:store_go/features/profile/views/widgets/profile_edit_widgets/custom_form_field.dart';
import 'package:store_go/features/profile/views/widgets/profile_edit_widgets/dropdown_row.dart';
import 'package:store_go/features/profile/views/widgets/profile_edit_widgets/phone_field.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';

class ProfileForm extends StatelessWidget {
  final EditProfileController controller;
  final String selectedCountry;
  final String selectedGender;
  final Function(String?) onCountryChanged;
  final Function(String?) onGenderChanged;

  const ProfileForm({
    super.key,
    required this.controller,
    required this.selectedCountry,
    required this.selectedGender,
    required this.onCountryChanged,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full name field
        CustomFormField(
          label: 'profile.full_name'.translate(),
          controller: controller.fullNameController,
        ),
        SizedBox(height: UIConfig.marginLarge),

        // Nick name field
        CustomFormField(
          label: 'profile.nick_name'.translate(),
          controller: controller.userNameController,
        ),
        SizedBox(height: UIConfig.marginLarge),

        // Email field
        CustomFormField(
          label: 'auth.email'.translate(),
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: UIConfig.marginLarge), // Phone field with custom icon
        PhoneField(controller: controller.phoneController),
        SizedBox(height: UIConfig.marginLarge),

        // Date of birth field with date picker
        GestureDetector(
          onTap: () => controller.selectDateOfBirth(context),
          child: AbsorbPointer(
            child: CustomFormField(
              label: 'profile.date_of_birth'.translate(),
              controller: controller.dateOfBirthController,
              readOnly: true,
            ),
          ),
        ),
        SizedBox(height: UIConfig.marginLarge),

        // Country and Gender dropdowns
        DropdownRow(
          selectedCountry: selectedCountry,
          selectedGender: selectedGender,
          onCountryChanged: onCountryChanged,
          onGenderChanged: onGenderChanged,
        ),
      ],
    );
  }
}
