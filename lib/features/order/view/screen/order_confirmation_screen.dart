import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/shared/extensions/buttons/primary_button.dart';
import 'package:store_go/app/shared/extensions/text_extensions.dart';
import 'package:store_go/features/order/model/order_model.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final OrderModel? order;
  final String? orderId;

  const OrderConfirmationScreen({super.key, this.order, this.orderId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('order_confirmation.title'.translate()).heading4(context),
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
                    // Success Icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.accent(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: AppColors.accentForeground(context),
                        size: 60,
                      ),
                    ),
                    SizedBox(height: UIConfig.paddingXLarge),

                    // Success Message
                    Text(
                      'order_confirmation.thank_you'.translate(),
                    ).heading2(context),
                    SizedBox(height: UIConfig.paddingMedium),

                    Text(
                      'order_confirmation.order_placed'.translate(),
                    ).body(context),
                    SizedBox(height: UIConfig.paddingXLarge),

                    // Order Details Card
                    if (order != null) ...[
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
                              'order_confirmation.order_summary'.translate(),
                            ).heading4(context),
                            SizedBox(height: UIConfig.paddingMedium),

                            _buildDetailRow(
                              context,
                              'order_confirmation.order_number'.translate(),
                              order!.id.toString(),
                            ),
                            SizedBox(height: UIConfig.paddingSmall),
                            _buildDetailRow(
                              context,
                              'order_confirmation.order_total'.translate(),
                              '\$${order!.totalAmount.toStringAsFixed(2)}',
                            ),
                            SizedBox(height: UIConfig.paddingSmall),
                            _buildDetailRow(
                              context,
                              'Payment Status',
                              order!.paymentStatus,
                            ),
                            SizedBox(height: UIConfig.paddingSmall),
                            _buildDetailRow(
                              context,
                              'Order Status',
                              order!.status,
                            ),
                          ],
                        ),
                      ),
                    ] else if (orderId != null) ...[
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
                              'order_confirmation.order_summary'.translate(),
                            ).heading4(context),
                            SizedBox(height: UIConfig.paddingMedium),
                            _buildDetailRow(
                              context,
                              'order_confirmation.order_number'.translate(),
                              orderId!,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Action Buttons
              Column(
                children: [
                  // View Order Details Button
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'order_confirmation.view_order_details'.translate(),
                    ).primaryButton(
                      context,
                      onPressed: () {
                        if (order != null) {
                          Get.toNamed(AppRoute.orderDetails, arguments: order);
                        } else {
                          Get.toNamed(AppRoute.orders);
                        }
                      },
                    ),
                  ),
                  SizedBox(height: UIConfig.paddingMedium),

                  // Continue Shopping Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Get.offAllNamed(AppRoute.mainContainer);
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
                        'order_confirmation.continue_shopping'.translate(),
                      ).subtitle1(context),
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

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label).caption(context), Text(value).subtitle2(context)],
    );
  }
}
