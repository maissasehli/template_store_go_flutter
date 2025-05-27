import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/theme/app_theme.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
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
        title: Text(
          'payment.title'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              color: AppColors.foreground(context),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () =>
            controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24), // Add Payment Method Button
                      GestureDetector(
                        onTap: () => _navigateToAddCardPage(context),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(AppTheme.globalButtonsRadius),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'payment.add_payment_method'.translate(),
                                style:
                                    LocalizationService.getLocalizedTextStyle(
                                      context,
                                      Theme.of(
                                            context,
                                          ).textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                            fontFamily: 'Gabarito',
                                          ) ??
                                          const TextStyle(),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Saved Payment Methods Section
                      Text(
                        'payment.saved_payment_methods'.translate(),
                        style: LocalizationService.getLocalizedTextStyle(
                          context,
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Gabarito',
                              ) ??
                              const TextStyle(),
                        ),
                      ),

                      const SizedBox(height: 16),

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
          const SizedBox(height: 16),
          Text(
            'payment.no_payment_methods'.translate(),
            style: LocalizationService.getLocalizedTextStyle(
              context,
              Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                    fontFamily: 'Poppins',
                  ) ??
                  const TextStyle(),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'payment.add_new_method'.translate(),
            style: LocalizationService.getLocalizedTextStyle(
              context,
              Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                    fontFamily: 'Poppins',
                  ) ??
                  const TextStyle(),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsList(PaymentController controller) {
    return ListView.separated(
      itemCount: controller.paymentMethods.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
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
        title: Text(
          'common.delete'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            Theme.of(context).textTheme.titleMedium ?? const TextStyle(),
          ),
        ),
        content: Text(
          'payment.confirm_delete'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            Theme.of(context).textTheme.bodyMedium ?? const TextStyle(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'common.cancel'.translate(),
              style: LocalizationService.getLocalizedTextStyle(
                context,
                Theme.of(context).textTheme.labelLarge ?? const TextStyle(),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deletePaymentMethod(paymentMethod.id);
            },
            child: Text(
              'payment.delete_confirm'.translate(),
              style: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
