import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/address/controller/address_controller.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AddressController controller = Get.put(AddressController());
    final isLoading = true.obs;
    final bool isRtl = LocalizationService.isRtl(context);

    controller.fetchAddresses().then((_) => isLoading.value = false);

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
          'address.title'.translate(),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.clearFields();
          Get.toNamed('/add-address');
        },
        backgroundColor: AppColors.primary(context),
        child: Icon(Icons.add, color: AppColors.primaryForeground(context)),
      ),
      body: Obx(
        () =>
            isLoading.value
                ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary(context),
                  ),
                )
                : Padding(
                  padding: EdgeInsets.all(UIConfig.paddingLarge),
                  child:
                      controller.addresses.isEmpty
                          ? _buildEmptyState(context)
                          : _buildAddressList(context, controller),
                ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 80,
            color: AppColors.muted(context),
          ),
          SizedBox(height: UIConfig.marginLarge),
          Text(
            'address.no_addresses'.translate(),
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                color: AppColors.foreground(context),
                fontSize: UIConfig.fontSizeLarge,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          SizedBox(height: UIConfig.marginSmall),
          Text(
            'address.add_first_address'.translate(),
            textAlign: TextAlign.center,
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                color: AppColors.mutedForeground(context),
                fontSize: UIConfig.fontSizeRegular,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          SizedBox(height: UIConfig.marginLarge),
          ElevatedButton(
            onPressed: () {
              Get.toNamed('/add-address');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              foregroundColor: AppColors.primaryForeground(context),
              padding: EdgeInsets.symmetric(
                horizontal: UIConfig.paddingLarge,
                vertical: UIConfig.paddingMedium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  UIConfig.borderRadiusCircular,
                ),
              ),
            ),
            child: Text(
              'address.add_address'.translate(),
              style: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(
                  fontSize: UIConfig.fontSizeMedium,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressList(BuildContext context, AddressController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'address.saved_addresses'.translate(),
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
        Expanded(
          child: ListView.separated(
            itemCount: controller.addresses.length,
            separatorBuilder:
                (context, index) => SizedBox(height: UIConfig.marginMedium),
            itemBuilder: (context, index) {
              final address = controller.addresses[index];
              return _buildAddressCard(
                context,
                address.formattedAddress,
                isDefault: address.isDefault,
                onEdit: () {
                  controller.setAddressForEditing(address);
                  Get.toNamed('/edit-address');
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard(
    BuildContext context,
    String address, {
    bool isDefault = false,
    required VoidCallback onEdit,
  }) {

    return Container(
      padding: EdgeInsets.all(UIConfig.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
        border: Border.all(
          color:
              isDefault
                  ? AppColors.primary(context)
                  : AppColors.border(context),
          width: isDefault ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDefault)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: UIConfig.paddingSmall,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary(context),
                borderRadius: BorderRadius.circular(UIConfig.borderRadiusSmall),
              ),
              child: Text(
                'address.default'.translate(),
                style: LocalizationService.getLocalizedTextStyle(
                  context,
                  TextStyle(
                    color: AppColors.primaryForeground(context),
                    fontSize: UIConfig.fontSizeSmall,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          if (isDefault) SizedBox(height: UIConfig.marginSmall),
          Row(
            children: [
              Expanded(
                child: Text(
                  address,
                  style: LocalizationService.getLocalizedTextStyle(
                    context,
                    TextStyle(
                      fontSize: UIConfig.fontSizeRegular,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      color: AppColors.foreground(context),
                    ),
                  ),
                ),
              ),
              SizedBox(width: UIConfig.marginSmall),
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: UIConfig.paddingSmall,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary(context),
                    borderRadius: BorderRadius.circular(
                      UIConfig.borderRadiusSmall,
                    ),
                  ),
                  child: Text(
                    'address.edit'.translate(),
                    style: LocalizationService.getLocalizedTextStyle(
                      context,
                      TextStyle(
                        fontSize: UIConfig.fontSizeSmall,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: AppColors.primary(context),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
