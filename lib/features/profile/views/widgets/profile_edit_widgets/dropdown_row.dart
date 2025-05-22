import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/profile/views/widgets/profile_edit_widgets/custom_dropdown_field.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: UIConfig.paddingSmall,
                  bottom: 4.0,
                ),
                child: Text(
                  'profile.country'.translate(),
                  style: LocalizationService.getLocalizedTextStyle(
                    context,
                    TextStyle(
                      color: AppColors.mutedForeground(context),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              CustomDropdownField(
                value: selectedCountry,
                items: [
                  'Tunisia',
                  'Algeria',
                  'Morocco',
                  'Egypt',
                  'Libya',
                  'USA',
                  'Canada',
                  'UK',
                  'France',
                ],
                onChanged: onCountryChanged,
                hintText: 'profile.select_country'.translate(),
              ),
            ],
          ),
        ),
        SizedBox(width: UIConfig.marginMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: UIConfig.paddingSmall,
                  bottom: 4.0,
                ),
                child: Text(
                  'profile.gender'.translate(),
                  style: LocalizationService.getLocalizedTextStyle(
                    context,
                    TextStyle(
                      color: AppColors.mutedForeground(context),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              CustomDropdownField(
                value: selectedGender,
                items: ['Male', 'Female', 'Other'],
                onChanged: onGenderChanged,
                hintText: 'profile.select_gender'.translate(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
