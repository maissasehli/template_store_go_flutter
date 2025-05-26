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

  // Country mapping from keys to translated names
  Map<String, String> get _countryMap => {
    'tunisia': 'profile.countries.tunisia'.translate(),
    'algeria': 'profile.countries.algeria'.translate(),
    'morocco': 'profile.countries.morocco'.translate(),
    'egypt': 'profile.countries.egypt'.translate(),
    'libya': 'profile.countries.libya'.translate(),
    'usa': 'profile.countries.usa'.translate(),
    'canada': 'profile.countries.canada'.translate(),
    'uk': 'profile.countries.uk'.translate(),
    'france': 'profile.countries.france'.translate(),
  };

  // Gender mapping from keys to translated names
  Map<String, String> get _genderMap => {
    'male': 'profile.genders.male'.translate(),
    'female': 'profile.genders.female'.translate(),
    'other': 'profile.genders.other'.translate(),
  };

  // Get display value for country
  String _getCountryDisplayValue() {
    return _countryMap[selectedCountry.toLowerCase()] ?? selectedCountry;
  }

  // Get display value for gender
  String _getGenderDisplayValue() {
    return _genderMap[selectedGender.toLowerCase()] ?? selectedGender;
  }

  // Get country key from display value
  String? _getCountryKeyFromDisplay(String? displayValue) {
    if (displayValue == null) return null;
    return _countryMap.entries
        .firstWhere(
          (entry) => entry.value == displayValue,
          orElse: () => MapEntry(displayValue.toLowerCase(), displayValue),
        )
        .key;
  }

  // Get gender key from display value
  String? _getGenderKeyFromDisplay(String? displayValue) {
    if (displayValue == null) return null;
    return _genderMap.entries
        .firstWhere(
          (entry) => entry.value == displayValue,
          orElse: () => MapEntry(displayValue.toLowerCase(), displayValue),
        )
        .key;
  }

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
                value: _getCountryDisplayValue(),
                items: _countryMap.values.toList(),
                onChanged: (displayValue) {
                  final key = _getCountryKeyFromDisplay(displayValue);
                  onCountryChanged(key);
                },
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
                value: _getGenderDisplayValue(),
                items: _genderMap.values.toList(),
                onChanged: (displayValue) {
                  final key = _getGenderKeyFromDisplay(displayValue);
                  onGenderChanged(key);
                },
                hintText: 'profile.select_gender'.translate(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
