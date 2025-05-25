import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/address/model/address_model.dart';
import 'package:store_go/features/address/repository/address_repository.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
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

  // New text controllers for missing fields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final apartmentController = TextEditingController();

  // For address type selection
  final addressType = 'shipping'.obs; // Default to shipping

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
    zipCodeController.dispose();
    countryController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    apartmentController.dispose();
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
    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
    apartmentController.clear();
    addressType.value = 'shipping';
    isDefault.value = false;
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
    firstNameController.text = address.firstName ?? '';
    lastNameController.text = address.lastName ?? '';
    phoneController.text = address.phone ?? '';
    apartmentController.text = address.apartment ?? '';
    addressType.value = address.type ?? 'shipping';
    isDefault.value = address.isDefault;
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
          country:
              countryController.text.trim().isEmpty
                  ? 'TN'
                  : countryController.text.trim(),
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          phone: phoneController.text.trim(),
          apartment: apartmentController.text.trim(),
          type: addressType.value,
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
          zipCode: zipCodeController.text.trim(),
          country:
              countryController.text.trim().isEmpty
                  ? 'TN'
                  : countryController.text.trim(),
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          phone: phoneController.text.trim(),
          apartment: apartmentController.text.trim(),
          type: addressType.value,
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
        final result = await _addressRepository.setAddressAsDefault(id);

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

  // Validate form inputs (made public by removing underscore)
  bool validateInputs() {
    if (firstNameController.text.trim().isEmpty) {
      Get.snackbar(
        'address.error_title'.translate(),
        'address.first_name_required'.translate(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (lastNameController.text.trim().isEmpty) {
      Get.snackbar(
        'address.error_title'.translate(),
        'address.last_name_required'.translate(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

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

    if (zipCodeController.text.trim().isEmpty) {
      Get.snackbar(
        'address.error_title'.translate(),
        'address.zip_required'.translate(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar(
        'address.error_title'.translate(),
        'address.phone_required'.translate(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }
}
