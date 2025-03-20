import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/controller/other/controller_form_field_state.dart';

extension FormFieldExtensions on String {
  Widget validatedField(
    BuildContext context, {
    required ControllerFormFieldState fieldState,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return Obx(
      () => TextFormField(
        controller: fieldState.controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        focusNode: fieldState.focusNode,
        decoration: InputDecoration(
          hintText: this,
          errorText: fieldState.error,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
        onChanged: (value) {
          if (fieldState.touched.value) {
            fieldState
                .validateNow(); // Assuming you implement validateNow as shown earlier
          }
        },
        onEditingComplete: () {
          fieldState.touch();
        },
        // Also validate when field loses focus
        onFieldSubmitted: (_) {
          fieldState.touch();
        },
      ),
    );
  }

  Widget emailField(
    BuildContext context, {
    required ControllerFormFieldState fieldState,
  }) {
    return validatedField(
      context,
      fieldState: fieldState,
      keyboardType: TextInputType.emailAddress,
    );
  }
  Widget textField(
    BuildContext context, {
    required ControllerFormFieldState fieldState,
  }) {
    return validatedField(context, fieldState: fieldState);
  }

  Widget passwordField(
    BuildContext context, {
    required ControllerFormFieldState fieldState,
  }) {
    return validatedField(context, fieldState: fieldState, obscureText: true);
  }
}
