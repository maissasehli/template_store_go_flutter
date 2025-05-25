import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/features/cart/controllers/cart_controller.dart';
import 'package:store_go/features/checkout/controllers/checkout_controller.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final checkoutController = Get.put(CheckoutController());
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
          'checkout.title'.translate(),
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
          children: [
            // Shipping Address Section
            _buildAddressSection(context, checkoutController),

            SizedBox(height: UIConfig.marginMedium),

            // Payment Method Section
            _buildPaymentMethodSection(context, checkoutController),

            Spacer(),

            // Order Summary Section
            Obx(() => _buildOrderSummary(context, cartController)),

            SizedBox(height: UIConfig.marginLarge),

            // Place Order Button
            _buildPlaceOrderButton(context, cartController, checkoutController),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection(
    BuildContext context,
    CheckoutController controller,
  ) {
    return InkWell(
      onTap: () => Get.toNamed('/address'),
      borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
      child: Container(
        padding: EdgeInsets.all(UIConfig.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
          border: Border.all(color: AppColors.border(context)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'checkout.shipping_address'.translate(),
                    style: LocalizationService.getLocalizedTextStyle(
                      context,
                      TextStyle(
                        color: AppColors.mutedForeground(context),
                        fontSize: UIConfig.fontSizeMedium,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'checkout.add_shipping_address'.translate(),
                    style: LocalizationService.getLocalizedTextStyle(
                      context,
                      TextStyle(
                        color: AppColors.foreground(context),
                        fontSize: UIConfig.fontSizeMedium,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.muted(context),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection(
    BuildContext context,
    CheckoutController controller,
  ) {
    return InkWell(
      onTap: () => Get.toNamed('/payments'),
      borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
      child: Container(
        padding: EdgeInsets.all(UIConfig.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
          border: Border.all(color: AppColors.border(context)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'checkout.payment_method'.translate(),
                    style: LocalizationService.getLocalizedTextStyle(
                      context,
                      TextStyle(
                        color: AppColors.mutedForeground(context),
                        fontSize: UIConfig.fontSizeMedium,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'checkout.add_payment_method'.translate(),
                    style: LocalizationService.getLocalizedTextStyle(
                      context,
                      TextStyle(
                        color: AppColors.foreground(context),
                        fontSize: UIConfig.fontSizeMedium,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.muted(context),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(
    BuildContext context,
    CartController cartController,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: UIConfig.paddingMedium),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border(context))),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            context,
            'checkout.subtotal'.translate(),
            '\$${cartController.subtotal.value.toStringAsFixed(2)}',
          ),
          SizedBox(height: 8),
          _buildSummaryRow(
            context,
            'checkout.shipping_cost'.translate(),
            '\$${cartController.shipping.value.toStringAsFixed(2)}',
          ),
          SizedBox(height: 8),
          _buildSummaryRow(
            context,
            'checkout.tax'.translate(),
            '\$${cartController.tax.value.toStringAsFixed(2)}',
          ),
          SizedBox(height: 8),
          _buildSummaryRow(
            context,
            'checkout.discount'.translate(),
            '-\$${cartController.discount.value.toStringAsFixed(2)}',
          ),
          SizedBox(height: 8),
          _buildSummaryRow(
            context,
            'checkout.total'.translate(),
            '\$${cartController.total.value.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              color: AppColors.foreground(context),
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              fontSize: UIConfig.fontSizeRegular,
            ),
          ),
        ),
        Text(
          value,
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              color: AppColors.foreground(context),
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              fontSize: UIConfig.fontSizeRegular,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton(
    BuildContext context,
    CartController cartController,
    CheckoutController checkoutController,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          Get.snackbar(
            'checkout.success_title'.translate(),
            'checkout.success_message'.translate(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.primary(context),
            colorText: AppColors.primaryForeground(context),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary(context),
          foregroundColor: AppColors.primaryForeground(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${cartController.total.value.toStringAsFixed(2)}',
              style: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(
                  color: AppColors.primaryForeground(context),
                  fontSize: UIConfig.fontSizeMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              'checkout.place_order'.translate(),
              style: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(
                  color: AppColors.primaryForeground(context),
                  fontSize: UIConfig.fontSizeMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
