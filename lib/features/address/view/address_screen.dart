import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/address/controller/address_controller.dart';
import 'package:store_go/app/core/theme/ui_config.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AddressController controller = Get.put(AddressController());
    final isLoading = true.obs;

    controller.fetchAddresses().then((_) => isLoading.value = false);

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
            color: AppColors.mutedForeground(context),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, 
              color: AppColors.foreground(context), 
              size: 20),
            onPressed: () => Get.back(),
          ),
        ),
        title: Text(
          'Address',
          style: TextStyle(
            color: AppColors.foreground(context),
            fontSize: UIConfig.fontSizeMedium,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Obx(
        () => isLoading.value
            ? Center(child: CircularProgressIndicator(
                color: AppColors.primary(context),
              ))
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: UIConfig.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: UIConfig.marginLarge),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.clearFields();
                            Get.toNamed('/add-address');
                          },
                          child: Text(
                            'Add Address',
                            style: TextStyle(
                              fontSize: UIConfig.fontSizeMedium,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Gabarito',
                              color: AppColors.foreground(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: UIConfig.marginMedium),
                    Expanded(
                      child: controller.addresses.isEmpty
                          ? Center(
                              child: Text(
                                'No addresses added yet',
                                style: TextStyle(
                                  color: AppColors.mutedForeground(context),
                                  fontSize: UIConfig.fontSizeRegular,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            )
                          : ListView.separated(
                              itemCount: controller.addresses.length,
                              separatorBuilder: (context, index) => 
                                SizedBox(height: UIConfig.marginSmall),
                              itemBuilder: (context, index) {
                                final address = controller.addresses[index];
                                return _buildAddressCard(
                                  context,
                                  address.formattedAddress,
                                  onEdit: () {
                                    controller.setAddressForEditing(address);
                                    Get.toNamed('/edit-address');
                                  },
                                );
                              },
                            ),
                    ),
                 
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, String address, {required VoidCallback onEdit}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: UIConfig.paddingMedium,
        vertical: UIConfig.paddingMedium
      ),
      decoration: BoxDecoration(
        color: AppColors.mutedForeground(context),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              address,
              style: TextStyle(
                fontSize: UIConfig.fontSizeRegular,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
                color: AppColors.foreground(context),
              ),
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: Text(
              'Edit',
              style: TextStyle(
                fontSize: UIConfig.fontSizeSmall,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: AppColors.foreground(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}