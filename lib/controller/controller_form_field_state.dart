import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

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
        Logger().d("Field lost focus, touched: $touched");
      }
    });
  }
  
  // Make error a computed property that updates _errorText
  String? get error => _errorText.value.isEmpty ? null : _errorText.value;
  
  void validateNow() {
    String? result = validator(controller.text);
    _errorText.value = result ?? '';
  }
  
  void touch() {
    touched.value = true;
    validateNow(); // Validate immediately when touched
  }
  
  void reset() {
    touched.value = false;
    _errorText.value = '';
  }
  // Make sure to dispose of the focus node
  void dispose() {
    focusNode.dispose();
    controller.dispose();
  }
}
