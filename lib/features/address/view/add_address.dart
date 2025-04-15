import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/address/controller/address_controller.dart';

class AddAddressPage extends StatelessWidget {
  const AddAddressPage({super.key});

  @override
Widget build(BuildContext context) {
  // Use Get.find with a fallback to Get.put to ensure the controller exists
  final AddressController controller = Get.isRegistered<AddressController>() 
      ? Get.find<AddressController>() 
      : Get.put(AddressController());
  
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        onPressed: () => Get.back(),
      ),
      centerTitle: true,
      title: const Text(
        'Add Address',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),  // Left: 24px as specified
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          
          // Street Address (positioned at Top: 135px from your specs)
          const SizedBox(height: 10),  // Adjusted to help meet the 135px top position
          _buildTextField(controller.streetController, 'Street Address'),
          const SizedBox(height: 12),
          
          // City
          _buildTextField(controller.cityController, 'City'),
          const SizedBox(height: 12),
          
          // State and Zip Code in a row
          Row(
            children: [
              Expanded(
                child: _buildTextField(controller.stateController, 'State'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(controller.zipCodeController, 'Zip Code'),
              ),
            ],
          ),
          
          // Spacer to push button to bottom
          const Spacer(),
          
          // Save Button (black button with rounded corners)
          Container(
            width: double.infinity,
            height: 56,
            margin: const EdgeInsets.only(bottom: 24),
            child: ElevatedButton(
              onPressed: () {
                controller.addAddress();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),  // Very rounded corners
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          
          // Bottom indicator line
          Center(
            child: Container(
              width: 134,
              height: 5,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
  Widget _buildTextField(TextEditingController controller, String hint) {
  return Container(
    width: double.infinity,  // Fill the available width
    height: 56,
    margin: const EdgeInsets.only(bottom: 12),  // Add spacing between fields
    decoration: BoxDecoration(
      color: const Color(0xFFF4F4F4),  // Light gray background
      borderRadius: BorderRadius.circular(8),
    ),
    child: TextField(
      controller: controller,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        fontSize: 15,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: Colors.grey[400],  // Lighter gray for placeholder text
        ),
        filled: true,
        fillColor: const Color(0xFFF4F4F4),  // Match container background
      ),
    ),
  );
}
}