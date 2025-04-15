import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/address/model/address_model.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

class AddressController extends GetxController {
  // Observable list of addresses
  final RxList<Address> addresses = <Address>[].obs;
  
  // Selected address for editing
  final Rx<Address?> selectedAddress = Rx<Address?>(null);
  
  // Text controllers for form fields
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();
  
  @override
  void onInit() {
    super.onInit();
    // Add some sample addresses for testing
    addresses.add(Address(
      id: const Uuid().v4(),
      street: '2716 Ash Dr',
      city: 'San Jose',
      state: 'South Dakota',
      zipCode: '83475',
    ));
  }
  
  @override
  void onClose() {
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    super.onClose();
  }
  
  // Clear form fields
  void clearFields() {
    streetController.clear();
    cityController.clear();
    stateController.clear();
    zipCodeController.clear();
    selectedAddress.value = null;
  }
  
  // Set form fields for editing an address
  void setAddressForEditing(Address address) {
    selectedAddress.value = address;
    streetController.text = address.street;
    cityController.text = address.city;
    stateController.text = address.state;
    zipCodeController.text = address.zipCode;
  }
  
  // Add a new address
  void addAddress() {
    if (_validateInputs()) {
      final newAddress = Address(
        id: const Uuid().v4(),
        street: streetController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        zipCode: zipCodeController.text.trim(),
      );
      
      addresses.add(newAddress);
      clearFields();
      Get.back();
    }
  }
  
  // Update an existing address
  void updateAddress() {
    if (_validateInputs() && selectedAddress.value != null) {
      final index = addresses.indexWhere((addr) => addr.id == selectedAddress.value!.id);
      
      if (index != -1) {
        final updatedAddress = Address(
          id: selectedAddress.value!.id,
          street: streetController.text.trim(),
          city: cityController.text.trim(),
          state: stateController.text.trim(),
          zipCode: zipCodeController.text.trim(),
        );
        
        addresses[index] = updatedAddress;
        clearFields();
        Get.back();
      }
    }
  }
  
  // Delete an address
// Delete an address
void deleteAddress(String? id) {
  if (id != null) {
    addresses.removeWhere((addr) => addr.id == id);
  }
}
  
  // Validate form inputs
  bool _validateInputs() {
    if (streetController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter street address');
      return false;
    }
    if (cityController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter city');
      return false;
    }
    if (stateController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter state');
      return false;
    }
    if (zipCodeController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter zip code');
      return false;
    }
    return true;
  }
}