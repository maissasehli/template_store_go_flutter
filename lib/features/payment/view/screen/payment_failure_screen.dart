import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/app_theme.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/shared/extensions/text_extensions.dart';

class PaymentFailureScreen extends StatelessWidget {
  const PaymentFailureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>? ?? {};
    final orderId = arguments['orderId'] as String? ?? '';
    final amount = arguments['amount'] as double? ?? 0.0;
    final error =
        arguments['error'] as String? ??
        'order_failure.error_message'.translate();

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('order_failure.title'.translate()).heading5(context),
      ),
      body: Padding(
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
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: UIConfig.marginXLarge),

                  // Error Title
                  Text(
                    'order_failure.error_title'.translate(),
                  ).heading3(context),

                  SizedBox(height: UIConfig.marginMedium),

                  // Error Message
                  Text(error).body(context),

                  SizedBox(height: UIConfig.marginXLarge),

                  // Order Information Card
                  if (orderId.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(UIConfig.paddingLarge),
                      decoration: BoxDecoration(
                        color: AppColors.card(context),
                        borderRadius: BorderRadius.circular(
                          AppTheme.globalRadius,
                        ),
                        border: Border.all(color: AppColors.border(context)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'order_failure.order_information'.translate(),
                          ).heading5(context),

                          SizedBox(height: UIConfig.marginMedium),

                          // Order ID
                          _buildDetailRow(
                            context,
                            'order_failure.order_id'.translate(),
                            orderId,
                          ),

                          SizedBox(height: UIConfig.marginSmall),

                          // Amount
                          _buildDetailRow(
                            context,
                            'payment.amount'.translate(),
                            '\$${amount.toStringAsFixed(2)}',
                          ),

                          SizedBox(height: UIConfig.marginSmall),

                          // Status
                          _buildDetailRow(
                            context,
                            'order_failure.status'.translate(),
                            'order_failure.payment_failed'.translate(),
                            valueColor: Colors.red,
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: UIConfig.marginXLarge),

                  // Helpful Tips
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(UIConfig.paddingLarge),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        AppTheme.globalRadius,
                      ),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'order_failure.what_can_you_do'.translate(),
                        ).heading5(context),

                        SizedBox(height: UIConfig.marginSmall),

                        Text(
                          'order_failure.helpful_tips'.translate(),
                        ).body(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            Column(
              children: [
                // Retry Payment Button
                if (orderId.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.offNamed(
                          '/payment-processing',
                          arguments: {
                            'orderId': orderId,
                            'amount': amount,
                            'retry': true,
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary(context),
                        foregroundColor: AppColors.primaryForeground(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppTheme.globalButtonsRadius,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: UIConfig.paddingMedium,
                        ),
                      ),
                      child: Text(
                        'order_failure.retry_payment'.translate(),
                      ).button(context),
                    ),
                  ),

                SizedBox(height: UIConfig.marginMedium),

                // Try Different Method Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.offNamed('/payment-methods');
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.border(context)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.globalButtonsRadius,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: UIConfig.paddingMedium,
                      ),
                    ),
                    child: Text(
                      'order_failure.try_different_method'.translate(),
                    ).button(context),
                  ),
                ),

                SizedBox(
                  height: UIConfig.marginMedium,
                ), // Continue Shopping Button
                TextButton(
                  onPressed: () {
                    Get.offAllNamed('/main-container');
                  },
                  child: Text(
                    'order_failure.continue_shopping'.translate(),
                  ).caption(context),
                ),
              ],
            ),
          ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: AppColors.mutedForeground(context)),
          ).body(context),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppColors.foreground(context),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.end,
          ).body(context),
        ),
      ],
    );
  }
}
