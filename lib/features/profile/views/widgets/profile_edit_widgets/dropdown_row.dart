import 'package:flutter/material.dart';
import 'package:store_go/features/profile/views/widgets/profile_edit_widgets/custom_dropdown_field.dart';

class DropdownRow extends StatelessWidget {
  final String selectedCountry;
  final String selectedGender;
  final Function(String?) onCountryChanged;
  final Function(String?) onGenderChanged;

  const DropdownRow({
    super.key,
    required this.selectedCountry,
    required this.selectedGender,
    required this.onCountryChanged,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomDropdownField(
            value: selectedCountry,
            items: ['Tunisia', 'USA', 'Canada', 'UK', 'France'],
            onChanged: onCountryChanged,
            hintText: 'Country',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomDropdownField(
            value: selectedGender,
            items: ['Male', 'Female', 'Other'],
            onChanged: onGenderChanged,
            hintText: 'Gender',
          ),
        ),
      ],
    );
  }
}
