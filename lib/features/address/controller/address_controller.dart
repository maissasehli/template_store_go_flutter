import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/address/model/address_model.dart';
import 'package:store_go/features/address/repository/address_repository.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';

class AddressController extends GetxController {
  final AddressRepository _addressRepository;

  // Observable list of addresses
  final RxList<Address> addresses = <Address>[].obs;

  // Selected address for editing
  final Rx<Address?> selectedAddress = Rx<Address?>(null);

  // Text controllers for form fields - only the required ones
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalCodeController =
      TextEditingController(); // Changed from zipCodeController
  final countryController = TextEditingController();

  // For isDefault toggle
  final isDefault = false.obs;

  AddressController({AddressRepository? addressRepository})
    : _addressRepository =
          addressRepository ??
          AddressRepository(apiClient: Get.find<ApiClient>());

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
    postalCodeController.dispose();
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
    postalCodeController.clear();
    countryController.clear();
    isDefault.value = false;
    selectedAddress.value = null;
  }

  // Set form fields for editing an address
  void setAddressForEditing(Address address) {
    selectedAddress.value = address;
    streetController.text = address.street;
    cityController.text = address.city;
    stateController.text = address.state;
    postalCodeController.text = address.postalCode;
    countryController.text = address.country;
    isDefault.value = address.isDefault;
  }

  // Add a new address
  Future<void> addAddress() async {
    if (validateInputs()) {
      try {
        final newAddress = Address(
          street: streetController.text.trim(),
          city: cityController.text.trim(),
          state: stateController.text.trim(),
          postalCode: postalCodeController.text.trim(),
          country:
              countryController.text.trim().isEmpty
                  ? 'TN'
                  : countryController.text.trim(),
          isDefault: isDefault.value,
          status: 'active',
        );

        final createdAddress = await _addressRepository.createAddress(
          newAddress,
        );
        addresses.add(createdAddress);
        clearFields();
        Get.back();

        // Show success message
        Get.snackbar(
          'address.success_title'.translate(),
          'address.address_added'.translate(),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
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
          postalCode: postalCodeController.text.trim(),
          country:
              countryController.text.trim().isEmpty
                  ? 'TN'
                  : countryController.text.trim(),
          isDefault: isDefault.value,
          status: selectedAddress.value!.status,
        );

        final result = await _addressRepository.updateAddress(
          selectedAddress.value!.id!,
          updatedAddress,
        );
        final index = addresses.indexWhere(
          (addr) => addr.id == selectedAddress.value!.id,
        );
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

  // Set an address as default
  Future<void> setDefaultAddress(String? id) async {
    if (id != null) {
      try {
        await _addressRepository.setAddressAsDefault(id);

        // Update local list: set the selected address as default and others as non-default
        for (var i = 0; i < addresses.length; i++) {
          if (addresses[i].id == id) {
            addresses[i] = addresses[i].copyWith(isDefault: true);
          } else if (addresses[i].isDefault) {
            addresses[i] = addresses[i].copyWith(isDefault: false);
          }
        }

        // Show success message
        Get.snackbar(
          'address.success_title'.translate(),
          'address.default_set_success'.translate(),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          'address.error_title'.translate(),
          'address.default_set_error'.translate(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  // Validate form inputs
  bool validateInputs() {
    if (streetController.text.trim().isEmpty) {
      Get.snackbar(
        'address.error_title'.translate(),
        'address.street_required'.translate(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (cityController.text.trim().isEmpty) {
      Get.snackbar(
        'address.error_title'.translate(),
        'address.city_required'.translate(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (stateController.text.trim().isEmpty) {
      Get.snackbar(
        'address.error_title'.translate(),
        'address.state_required'.translate(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (postalCodeController.text.trim().isEmpty) {
      Get.snackbar(
        'address.error_title'.translate(),
        'address.postal_required'.translate(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (countryController.text.trim().isEmpty) {
      Get.snackbar(
        'address.error_title'.translate(),
        'address.country_required'.translate(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }
}
