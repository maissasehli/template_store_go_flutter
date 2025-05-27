import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/app_theme.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/app/shared/extensions/text_extensions.dart';
import 'package:store_go/features/payment/controller/payment_controller.dart';
import '../widget/payment_method_card.dart';

class PaymentMethodPage extends StatelessWidget {
  const PaymentMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.find<PaymentController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        leading: IconButton(
          icon: ThemeAwareSvg(
            assetPath:
                LocalizationService.isRtl(context)
                    ? AssetConfig.arrowRight
                    : AssetConfig.arrowLeft,
            height: 24,
            width: 24,
          ),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        title: Text('payment.title'.translate()).heading5(context),
        centerTitle: true,
      ),
      body: Obx(
        () =>
            controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: UIConfig.paddingMedium,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: UIConfig.marginLarge,
                      ), // Add Payment Method Button
                      GestureDetector(
                        onTap: () => _navigateToAddCardPage(context),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: UIConfig.paddingMedium,
                            vertical: UIConfig.paddingMedium,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary(context),
                            borderRadius: BorderRadius.circular(
                              AppTheme.globalButtonsRadius,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: AppColors.primaryForeground(context), size: 20),
                              SizedBox(width: UIConfig.marginSmall),
                              Text(
                                'payment.add_payment_method'.translate(),
                                style: LocalizationService.getLocalizedTextStyle(context, TextStyle(
                                  color: AppColors.primaryForeground(context),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: UIConfig.marginLarge),

                      // Saved Payment Methods Section
                      Text(
                        'payment.saved_payment_methods'.translate(),
                      ).heading5(context),
                      SizedBox(height: UIConfig.marginMedium),

                      // Payment Methods List or Empty State
                      Expanded(
                        child:
                            controller.paymentMethods.isEmpty
                                ? _buildEmptyState(context)
                                : _buildPaymentMethodsList(controller),
                      ),
                    ],
                  ),
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
            Icons.credit_card_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: UIConfig.marginMedium),
          Text(
            'payment.no_payment_methods'.translate(),
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
            textAlign: TextAlign.center,
          ).body(context),
          SizedBox(height: UIConfig.marginSmall),
          Text(
            'payment.add_new_method'.translate(),
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
            textAlign: TextAlign.center,
          ).caption(context),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsList(PaymentController controller) {
    return ListView.separated(
      itemCount: controller.paymentMethods.length,
      separatorBuilder:
          (context, index) => SizedBox(height: UIConfig.marginSmall),
      itemBuilder: (context, index) {
        final method = controller.paymentMethods[index];
        return PaymentMethodCard(
          paymentMethod: method,
          isSelected: controller.selectedPaymentMethod.value?.id == method.id,
          onTap: () {
            controller.selectPaymentMethod(method);
            Get.back();
          },
          onSetDefault: () => controller.setDefaultPaymentMethod(method.id),
          onDelete: () => _showDeleteConfirmation(context, controller, method),
        );
      },
    );
  }

  void _navigateToAddCardPage(BuildContext context) {
    // Navigate to add card page instead of showing bottom sheet
    Get.toNamed(AppRoute.addPayment);
  }

  void _showDeleteConfirmation(
    BuildContext context,
    PaymentController controller,
    paymentMethod,
  ) {
    Get.dialog(
      AlertDialog(
        title: Text('common.delete'.translate()).heading5(context),
        content: Text('payment.confirm_delete'.translate()).body(context),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('common.cancel'.translate()).button(context),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deletePaymentMethod(paymentMethod.id);
            },
            child: Text(
              'payment.delete_confirm'.translate(),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ).button(context),
          ),
        ],
      ),
    );
  }
}
