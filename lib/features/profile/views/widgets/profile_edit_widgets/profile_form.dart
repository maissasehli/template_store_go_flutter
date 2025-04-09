import 'package:flutter/material.dart';
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
    Key? key,
    required this.controller,
    required this.selectedCountry,
    required this.selectedGender,
    required this.onCountryChanged,
    required this.onGenderChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomFormField(
          label: 'Full name',
          controller: controller.fullNameController,
        ),
        const SizedBox(height: 16),
        CustomFormField(
          label: 'Nick name',
          controller: controller.userNameController,
        ),
        const SizedBox(height: 16),
        CustomFormField(label: 'Email', controller: controller.emailController),
        const SizedBox(height: 16),
        PhoneField(controller: controller.phoneController),
        const SizedBox(height: 16),
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
