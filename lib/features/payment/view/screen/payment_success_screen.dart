import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/app_theme.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/shared/extensions/text_extensions.dart';
import '../../models/payment_result_model.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>? ?? {};
    final orderId = arguments['orderId'] as String? ?? '';
    final amount = arguments['amount'] as double? ?? 0.0;
    final paymentResult = arguments['paymentResult'] as PaymentResult?;

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('payment.payment_successful'.translate()).heading5(context),
      ),
      body: Padding(
        padding: EdgeInsets.all(UIConfig.paddingLarge),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 60,
                      color: Colors.green,
                    ),
                  ),

                  SizedBox(height: UIConfig.marginXLarge), // Success Title
                  Text('payment.payment_success'.translate()).heading3(context),

                  SizedBox(height: UIConfig.marginMedium),

                  // Success Message
                  Text(
                    'order_confirmation.success_message'.translate(),
                  ).body(context),

                  SizedBox(height: UIConfig.marginXLarge),

                  // Payment Details Card
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
                          'order_confirmation.order_details'.translate(),
                        ).heading5(context),

                        SizedBox(height: UIConfig.marginMedium), // Order ID
                        if (orderId.isNotEmpty) ...[
                          _buildDetailRow(
                            context,
                            'order_confirmation.order_id'.translate(),
                            orderId,
                          ),
                          SizedBox(height: UIConfig.marginSmall),
                        ],

                        // Amount
                        _buildDetailRow(
                          context,
                          'payment.amount'.translate(),
                          '\$${amount.toStringAsFixed(2)}',
                        ),

                        SizedBox(height: UIConfig.marginSmall),

                        // Payment Status
                        _buildDetailRow(
                          context,
                          'payment.status'.translate(),
                          'payment.status.success'.translate(),
                          valueColor: Colors.green,
                        ),

                        // Payment ID if available
                        if (paymentResult?.paymentIntentId != null) ...[
                          SizedBox(height: UIConfig.marginSmall),
                          _buildDetailRow(
                            context,
                            'payment.payment_id'.translate(),
                            paymentResult!.paymentIntentId!,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            Column(
              children: [
                // View Order Details Button
                if (orderId.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.offAllNamed('/order-details', arguments: orderId);
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
                        'order_confirmation.view_order_details'.translate(),
                        style: LocalizationService.getLocalizedTextStyle(
                          context,
                          TextStyle(
                            color: AppColors.primaryForeground(context),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: UIConfig.marginMedium),

                // Continue Shopping Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.offAllNamed('/main-container');
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
                      'order_confirmation.continue_shopping'.translate(),
                    ).button(context),
                  ),
                ),

                SizedBox(
                  height: UIConfig.marginMedium,
                ), // View Payment History Link
                TextButton(
                  onPressed: () {
                    Get.toNamed('/payment-history');
                  },
                  child: Text(
                    'payment.payment_history'.translate(),
                    style: LocalizationService.getLocalizedTextStyle(context, TextStyle(
                      color: AppColors.primaryForeground(context),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )),
                  ),
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
