import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControllerFormFieldState {
  final FocusNode focusNode = FocusNode();
  final RxBool touched = false.obs;
  final RxString _errorText = RxString('');
  final TextEditingController controller;
  final String? Function(String?) validator;

  ControllerFormFieldState({
    required this.controller,
    required this.validator,
  }){
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        touch();
      }
    });
    
    // Listen for text changes to clear errors when user types
    controller.addListener(() {
      if (touched.value && _errorText.value.isNotEmpty) {
        validateNow(); // Re-validate as user types if there's an error
      }
    });
  }
  
  // Make error a computed property that updates _errorText
  String? get error => _errorText.value.isEmpty ? null : _errorText.value;
  
  // Validate the field using the provided validator
  void validateNow() {
    String? result = validator(controller.text);
    _errorText.value = result ?? '';
  }
  
  // Mark the field as touched and validate it
  void touch() {
    touched.value = true;
    validateNow(); // Validate immediately when touched
  }
  
  // Reset the field state
  void reset() {
    touched.value = false;
    _errorText.value = '';
  }
  
  // Dispose of resources
  void dispose() {
    focusNode.dispose();
    controller.dispose();
  }
}
