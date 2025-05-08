import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/address/controller/address_controller.dart';

class EditAddressPage extends StatelessWidget {
  const EditAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
   final AddressController controller = Get.find<AddressController>();
    final isLoading = false.obs;

    if (controller.selectedAddress.value == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.back();
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.only(left: UIConfig.marginMedium),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.muted(context),
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
          'Edit Address',
          style: TextStyle(
            color: AppColors.foreground(context),
            fontSize: UIConfig.fontSizeMedium,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, 
              color: AppColors.destructive(context)),
            onPressed: () {
              if (controller.selectedAddress.value != null) {
                Get.dialog(
                  AlertDialog(
                    backgroundColor: AppColors.background(context),
                    title: Text('Delete Address',
                      style: TextStyle(
                        color: AppColors.foreground(context),
                        fontSize: UIConfig.fontSizeMedium,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    content: Text(
                      'Are you sure you want to delete this address?',
                      style: TextStyle(
                        color: AppColors.foreground(context),
                        fontSize: UIConfig.fontSizeRegular,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text('Cancel',
                          style: TextStyle(
                            color: AppColors.mutedForeground(context),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          isLoading.value = true;
                          await controller.deleteAddress(controller.selectedAddress.value!.id);
                          isLoading.value = false;
                          Get.back();
                          Get.back();
                        },
                        child: Text('Delete',
                          style: TextStyle(
                            color: AppColors.destructive(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: UIConfig.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: UIConfig.marginLarge),
            _buildTextField(context, controller.streetController, 'Street Address'),
            SizedBox(height: UIConfig.marginSmall),
            _buildTextField(context, controller.cityController, 'City'),
            SizedBox(height: UIConfig.marginSmall),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(context, controller.stateController, 'State'),
                ),
                SizedBox(width: UIConfig.marginSmall),
                Expanded(
                  child: _buildTextField(context, controller.zipCodeController, 'Zip Code'),
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
                            await controller.updateAddress();
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
                          'Save Changes',
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

  Widget _buildTextField(BuildContext context, TextEditingController controller, String hint) {
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
            vertical: UIConfig.paddingMedium,
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