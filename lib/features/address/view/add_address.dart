import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/address/controller/address_controller.dart';
import 'package:store_go/app/core/theme/ui_config.dart';

class AddAddressPage extends StatelessWidget {
  const AddAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AddressController controller = Get.isRegistered<AddressController>()
        ? Get.find<AddressController>()
        : Get.put(AddressController());

    final isLoading = false.obs;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.only(left: UIConfig.marginMedium),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.border(context),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, 
              color: AppColors.foreground(context), 
              size: 20),
            onPressed: () => Get.back(),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Add Address',
          style: TextStyle(
            color: AppColors.foreground(context),
            fontSize: UIConfig.fontSizeMedium,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: UIConfig.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: UIConfig.marginLarge),
            _buildTextField(controller.streetController, 'Street Address', context),
            SizedBox(height: UIConfig.marginSmall),
            _buildTextField(controller.cityController, 'City', context),
            SizedBox(height: UIConfig.marginSmall),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(controller.stateController, 'State', context),
                ),
                SizedBox(width: UIConfig.marginSmall),
                Expanded(
                  child: _buildTextField(controller.zipCodeController, 'Zip Code', context),
                ),
              ],
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              height: 56,
              margin: EdgeInsets.only(bottom: UIConfig.marginLarge),
              child: Obx(
                () => ElevatedButton(
                  onPressed: isLoading.value
                      ? null
                      : () async {
                          isLoading.value = true;
                          if (controller.validateInputs()) {
                            await controller.addAddress();
                          }
                          isLoading.value = false;
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular),
                    ),
                  ),
                  child: isLoading.value
                      ? CircularProgressIndicator(color: AppColors.primaryForeground(context))
                      : Text(
                          'Save',
                          style: TextStyle(
                            color: AppColors.primaryForeground(context),
                            fontSize: UIConfig.fontSizeMedium,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      margin: EdgeInsets.only(bottom: UIConfig.marginSmall),
      decoration: BoxDecoration(
        color: AppColors.background(context),
        border: Border.all(color: AppColors.border(context), width: 1),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          fontSize: UIConfig.fontSizeRegular,
          color: AppColors.foreground(context),
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: UIConfig.paddingMedium, 
            vertical: UIConfig.paddingMedium
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: UIConfig.fontSizeRegular,
            color: AppColors.mutedForeground(context),
          ),
        ),
      ),
    );
  }
}