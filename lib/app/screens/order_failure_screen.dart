import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/shared/extensions/buttons/primary_button.dart';
import 'package:store_go/app/shared/extensions/text_extensions.dart';

class OrderFailureScreen extends StatelessWidget {
  const OrderFailureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get arguments passed from the PaymentProcessingScreen
    final Map<String, dynamic> arguments = Get.arguments ?? {};
    final String orderId = arguments['orderId'] ?? '';
    final double amount = arguments['amount'] ?? 0.0;
    final String error = arguments['error'] ?? 'An unknown error occurred';

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('order_failure.title'.translate()).heading4(context),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(UIConfig.paddingLarge),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Error Icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.destructive(context).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppColors.destructive(context),
                        size: 60,
                      ),
                    ),
                    SizedBox(height: UIConfig.paddingXLarge),

                    // Error Message
                    Text(
                      'order_failure.payment_failed'.translate(),
                    ).heading2(context),
                    SizedBox(height: UIConfig.paddingMedium),

                    Text(
                      'order_failure.problem_processing_payment'.translate(),
                      textAlign: TextAlign.center,
                    ).body(context),
                    SizedBox(height: UIConfig.paddingLarge),

                    // Order Details Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(UIConfig.paddingLarge),
                      decoration: BoxDecoration(
                        color: AppColors.card(context),
                        borderRadius: BorderRadius.circular(
                          UIConfig.borderRadiusLarge,
                        ),
                        border: Border.all(color: AppColors.border(context)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'order_failure.order_information'.translate(),
                          ).heading4(context),
                          SizedBox(height: UIConfig.paddingMedium),

                          if (orderId.isNotEmpty) ...[
                            _buildDetailRow(
                              context,
                              'order_failure.order_id'.translate(),
                              orderId,
                            ),
                            SizedBox(height: UIConfig.paddingSmall),
                          ],

                          _buildDetailRow(
                            context,
                            'order_failure.amount'.translate(),
                            '\$${amount.toStringAsFixed(2)}',
                          ),
                          SizedBox(height: UIConfig.paddingSmall),

                          _buildDetailRow(
                            context,
                            'order_failure.error'.translate(),
                            error,
                            valueColor: AppColors.destructive(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Action Buttons
              Column(
                children: [
                  // Try Again Button
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'order_failure.try_payment_again'.translate(),
                    ).primaryButton(
                      context,
                      onPressed: () {
                        // Go back to payment processing screen with the same order
                        Get.offNamed(
                          '/payment-processing',
                          arguments: {'orderId': orderId, 'amount': amount},
                        );
                      },
                    ),
                  ),
                  SizedBox(height: UIConfig.paddingMedium),

                  // Go to Orders Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Get.offAllNamed(AppRoute.orders);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.border(context)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            UIConfig.borderRadiusLarge,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: UIConfig.paddingMedium,
                        ),
                      ),
                      child: Text(
                        'order_failure.view_my_orders'.translate(),
                      ).subtitle1(context),
                    ),
                  ),
                  SizedBox(height: UIConfig.paddingMedium),

                  // Continue Shopping Button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Get.offAllNamed(AppRoute.mainContainer);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: UIConfig.paddingMedium,
                        ),
                      ),
                      child: Text(
                        'order_failure.continue_shopping'.translate(),
                        style: TextStyle(
                          color: AppColors.muted(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(label).caption(context)),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: valueColor ?? AppColors.foreground(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
