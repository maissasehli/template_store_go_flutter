import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/app_theme.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

class PhoneField extends StatefulWidget {
  final TextEditingController controller;

  const PhoneField({super.key, required this.controller});

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });

    // Add listener to controller to debug value changes
    widget.controller.addListener(() {
      print('Phone controller value changed: ${widget.controller.text}');
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.input(context),
        borderRadius: BorderRadius.circular(AppTheme.globalInputsRadius),
        border: Border.all(
          color: _isFocused ? AppColors.primary(context) : Colors.transparent,
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Phone icon in a circular container
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.primary(context),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.phone,
                size: 14,
                color: AppColors.primaryForeground(context),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Text field for phone number
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  focusedBorder: InputBorder.none,
                  focusColor: Colors.transparent,
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: TextField(
                controller: widget.controller,
                keyboardType: TextInputType.phone,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  labelText: 'profile.phone_number'.translate(),
                  labelStyle: LocalizationService.getLocalizedTextStyle(
                    context,
                    TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      height: 16 / 10,
                      letterSpacing: 0.25,
                      color: AppColors.mutedForeground(context),
                    ),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: const EdgeInsets.only(top: 8, bottom: 0),
                ),
                style: LocalizationService.getLocalizedTextStyle(
                  context,
                  TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 18 / 14,
                    letterSpacing: 0.25,
                    color: AppColors.inputForeground(context),
                  ),
                ),
                cursorColor: AppColors.primary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
