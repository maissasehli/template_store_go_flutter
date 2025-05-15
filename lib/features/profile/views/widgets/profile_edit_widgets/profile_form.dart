import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/profile/controllers/edit_profile_controller.dart';
import 'package:store_go/features/profile/views/widgets/profile_edit_widgets/custom_form_field.dart';
import 'package:store_go/features/profile/views/widgets/profile_edit_widgets/dropdown_row.dart';
import 'package:store_go/features/profile/views/widgets/profile_edit_widgets/phone_field.dart';

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
        CustomFormField(
          label: 'Full name',
          controller: controller.fullNameController,
        ),
        SizedBox(height: UIConfig.marginMedium),
        CustomFormField(
          label: 'Nick name',
          controller: controller.userNameController,
          readOnly: true,
        ),
        SizedBox(height: UIConfig.marginMedium),
        CustomFormField(
          label: 'Email', 
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: UIConfig.marginMedium),
        PhoneField(
          controller: controller.phoneController,
        ),
        SizedBox(height: UIConfig.marginMedium),
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