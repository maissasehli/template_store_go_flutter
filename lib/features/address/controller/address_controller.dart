import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/address/model/address_model.dart';
import 'package:store_go/features/address/repository/address_repository.dart';
import 'package:uuid/uuid.dart';

class AddressController extends GetxController {
  final AddressRepository _addressRepository;

  // Observable list of addresses
  final RxList<Address> addresses = <Address>[].obs;

  // Selected address for editing
  final Rx<Address?> selectedAddress = Rx<Address?>(null);

  // Text controllers for form fields
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();
  final countryController = TextEditingController();

  AddressController({AddressRepository? addressRepository})
      : _addressRepository = addressRepository ?? AddressRepository(apiClient: Get.find<ApiClient>());

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  @override
  void onClose() {
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    countryController.dispose();
    super.onClose();
  }

  // Fetch all addresses from the backend
  Future<void> fetchAddresses() async {
    try {
      final fetchedAddresses = await _addressRepository.getAddresses();
      addresses.assignAll(fetchedAddresses);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load addresses: $e');
    }
  }

  // Clear form fields
  void clearFields() {
    streetController.clear();
    cityController.clear();
    stateController.clear();
    zipCodeController.clear();
    countryController.clear();
    selectedAddress.value = null;
  }

  // Set form fields for editing an address
  void setAddressForEditing(Address address) {
    selectedAddress.value = address;
    streetController.text = address.street;
    cityController.text = address.city;
    stateController.text = address.state;
    zipCodeController.text = address.zipCode;
    countryController.text = address.country;
  }

  // Add a new address
  Future<void> addAddress() async {
    if (validateInputs()) {
      try {
        final newAddress = Address(
          id: const Uuid().v4(),
          street: streetController.text.trim(),
          city: cityController.text.trim(),
          state: stateController.text.trim(),
          zipCode: zipCodeController.text.trim(),
          country: countryController.text.trim().isEmpty ? 'TN':countryController.text.trim(),
          isDefault: false,
          status: 'active',
        );

        final createdAddress = await _addressRepository.createAddress(newAddress);
        addresses.add(createdAddress);
        clearFields();
        Get.back();
      } catch (e) {
        Get.snackbar('Error', 'Failed to add address: $e');
      }
    }
  }

  // Update an existing address
  Future<void> updateAddress() async {
    if (validateInputs() && selectedAddress.value != null) {
      try {
        final updatedAddress = Address(
          id: selectedAddress.value!.id,
          street: streetController.text.trim(),
          city: cityController.text.trim(),
          state: stateController.text.trim(),
          zipCode: zipCodeController.text.trim(),
          country: countryController.text.trim().isEmpty ? 'TN' : countryController.text.trim(),
          isDefault: selectedAddress.value!.isDefault,
          status: selectedAddress.value!.status,
        );

        final result = await _addressRepository.updateAddress(selectedAddress.value!.id!, updatedAddress);
        final index = addresses.indexWhere((addr) => addr.id == selectedAddress.value!.id);
        if (index != -1) {
          addresses[index] = result;
        }
        clearFields();
        Get.back();
      } catch (e) {
        Get.snackbar('Error', 'Failed to update address: $e');
      }
    }
  }

  // Delete an address
  Future<void> deleteAddress(String? id) async {
    if (id != null) {
      try {
        await _addressRepository.deleteAddress(id);
        addresses.removeWhere((addr) => addr.id == id);
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete address: $e');
      }
    }
  }

  // Validate form inputs (made public by removing underscore)
  bool validateInputs() {
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