import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/features/address/controller/address_controller.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

class AddAddressPage extends StatelessWidget {
  const AddAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AddressController controller =
        Get.isRegistered<AddressController>()
            ? Get.find<AddressController>()
            : Get.put(AddressController());

    final isLoading = false.obs;
    final bool isRtl = LocalizationService.isRtl(context);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        leading: IconButton(
          icon: ThemeAwareSvg(
            assetPath: isRtl ? AssetConfig.arrowRight : AssetConfig.arrowLeft,
            height: 24,
            width: 24,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'address.add_address'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              color: AppColors.foreground(context),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(UIConfig.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'address.address_details'.translate(),
                      style: LocalizationService.getLocalizedTextStyle(
                        context,
                        TextStyle(
                          color: AppColors.foreground(context),
                          fontSize: UIConfig.fontSizeMedium,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    SizedBox(height: UIConfig.marginMedium),

                    _buildTextField(
                      context,
                      controller.streetController,
                      'address.street_address'.translate(),
                    ),
                    SizedBox(height: UIConfig.marginMedium),

                    _buildTextField(
                      context,
                      controller.cityController,
                      'address.city'.translate(),
                    ),
                    SizedBox(height: UIConfig.marginMedium),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            context,
                            controller.stateController,
                            'address.state'.translate(),
                          ),
                        ),
                        SizedBox(width: UIConfig.marginMedium),
                        Expanded(
                          child: _buildTextField(
                            context,
                            controller.postalCodeController,
                            'address.postal_code'.translate(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: UIConfig.marginMedium),

                    _buildTextField(
                      context,
                      controller.countryController,
                      'address.country'.translate(),
                      hintText: 'address.country_hint'.translate(),
                    ),
                    SizedBox(height: UIConfig.marginLarge),

                    // Default address toggle
                    Obx(
                      () => SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'address.set_as_default'.translate(),
                          style: LocalizationService.getLocalizedTextStyle(
                            context,
                            TextStyle(
                              color: AppColors.foreground(context),
                              fontSize: UIConfig.fontSizeRegular,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        value: controller.isDefault.value,
                        onChanged:
                            (value) => controller.isDefault.value = value,
                        activeColor: AppColors.primary(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: UIConfig.marginMedium),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: Obx(
                () => ElevatedButton(
                  onPressed:
                      isLoading.value
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
                    foregroundColor: AppColors.primaryForeground(context),
                    disabledBackgroundColor: AppColors.muted(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        UIConfig.borderRadiusCircular,
                      ),
                    ),
                  ),
                  child:
                      isLoading.value
                          ? CircularProgressIndicator(
                            color: AppColors.primaryForeground(context),
                            strokeWidth: 2,
                          )
                          : Text(
                            'address.save'.translate(),
                            style: LocalizationService.getLocalizedTextStyle(
                              context,
                              TextStyle(
                                fontSize: UIConfig.fontSizeMedium,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
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

  Widget _buildTextField(
    BuildContext context,
    TextEditingController controller,
    String label, {
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              color: AppColors.foreground(context),
              fontSize: UIConfig.fontSizeRegular,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: UIConfig.fontSizeRegular,
              color: AppColors.foreground(context),
            ),
          ),
          decoration: InputDecoration(
            hintText: hintText ?? label,
            hintStyle: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: UIConfig.fontSizeRegular,
                color: AppColors.mutedForeground(context),
              ),
            ),
            filled: true,
            fillColor: AppColors.input(context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
              borderSide: BorderSide(color: AppColors.border(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
              borderSide: BorderSide(
                color: AppColors.primary(context),
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.all(UIConfig.paddingMedium),
          ),
        ),
      ],
    );
  }
}
