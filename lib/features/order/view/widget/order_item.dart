import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/features/order/model/order_model.dart';

class OrderItem extends StatelessWidget {
  final OrderModel order;

  const OrderItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: UIConfig.marginMedium),
      padding: EdgeInsets.all(UIConfig.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: InkWell(
        onTap: () => Get.toNamed('/order-details', arguments: order.id),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.secondary(context),
                borderRadius: BorderRadius.circular(UIConfig.borderRadiusSmall),
              ),
              child: Icon(
                Icons.receipt_outlined,
                size: 20,
                color: AppColors.foreground(context),
              ),
            ),
            SizedBox(width: UIConfig.marginMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'orders.order_number'.translate().replaceFirst(
                      '{number}',
                      order.orderNumber,
                    ),
                    style: LocalizationService.getLocalizedTextStyle(
                      context,
                      TextStyle(
                        fontSize: UIConfig.fontSizeMedium,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: AppColors.foreground(context),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'orders.items_count'.translate().replaceFirst(
                      '{count}',
                      order.itemCount.toString(),
                    ),
                    style: LocalizationService.getLocalizedTextStyle(
                      context,
                      TextStyle(
                        fontSize: UIConfig.fontSizeRegular,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        color: AppColors.mutedForeground(context),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    order.formattedDate,
                    style: LocalizationService.getLocalizedTextStyle(
                      context,
                      TextStyle(
                        fontSize: UIConfig.fontSizeSmall,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        color: AppColors.mutedForeground(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: UIConfig.paddingSmall,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: _getStatusColor(order.status, context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(UIConfig.borderRadiusSmall),
              ),
              child: Text(
                'orders.status.${order.status.toLowerCase()}'.translate(),
                style: LocalizationService.getLocalizedTextStyle(
                  context,
                  TextStyle(
                    fontSize: UIConfig.fontSizeSmall,
                    fontWeight: FontWeight.w500,
                    color: _getStatusColor(order.status, context),
                  ),
                ),
              ),
            ),
            SizedBox(width: UIConfig.marginSmall),
            Icon(
              Icons.chevron_right,
              color: AppColors.mutedForeground(context),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status, BuildContext context) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFFA500); // Orange for pending
      case 'processing':
        return AppColors.primary(context); // Primary color for processing
      case 'shipped':
        return const Color(0xFF007BFF); // Blue for shipped
      case 'delivered':
        return const Color(0xFF28A745); // Green for delivered
      case 'cancelled':
        return AppColors.destructive(context);
      default:
        return AppColors.mutedForeground(context);
    }
  }
}
