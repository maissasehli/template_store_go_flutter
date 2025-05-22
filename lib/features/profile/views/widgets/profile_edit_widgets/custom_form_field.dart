import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/app_theme.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

class CustomFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool readOnly;
  final FocusNode? focusNode;

  const CustomFormField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.focusNode,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    // Only dispose the focus node if we created it internally
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
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
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly,
          focusNode: _focusNode,
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            labelText: widget.label,
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
    );
  }
}
