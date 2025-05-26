// File: lib/features/order/views/widgets/order_list.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/features/order/controller/order_controller.dart';
import 'package:store_go/features/order/view/widget/order_item.dart';

class OrderList extends StatelessWidget {
  final OrderController controller;

  const OrderList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool isRtl = LocalizationService.isRtl(context);

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.primary(context)),
        );
      }

      if (controller.hasError.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.mutedForeground(context),
              ),
              SizedBox(height: UIConfig.marginMedium),
              Text(
                controller.errorMessage.value,
                textAlign: TextAlign.center,
                style: LocalizationService.getLocalizedTextStyle(
                  context,
                  TextStyle(
                    color: AppColors.mutedForeground(context),
                    fontSize: UIConfig.fontSizeRegular,
                  ),
                ),
              ),
              SizedBox(height: UIConfig.marginMedium),
              ElevatedButton(
                onPressed: () => controller.fetchOrders(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary(context),
                  foregroundColor: AppColors.primaryForeground(context),
                ),
                child: Text(
                  'common.retry'.translate(),
                  style: LocalizationService.getLocalizedTextStyle(
                    context,
                    TextStyle(color: AppColors.primaryForeground(context)),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      if (!controller.hasOrders.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: AppColors.mutedForeground(context),
              ),
              SizedBox(height: UIConfig.marginMedium),
              Text(
                'orders.empty_orders'.translate(),
                style: LocalizationService.getLocalizedTextStyle(
                  context,
                  TextStyle(
                    fontSize: UIConfig.fontSizeLarge,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground(context),
                  ),
                ),
              ),
              SizedBox(height: UIConfig.marginSmall),
              Text(
                'orders.empty_orders_subtitle'.translate(),
                textAlign: TextAlign.center,
                style: LocalizationService.getLocalizedTextStyle(
                  context,
                  TextStyle(
                    fontSize: UIConfig.fontSizeRegular,
                    color: AppColors.mutedForeground(context),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.all(UIConfig.paddingMedium),
        itemCount: controller.orders.length,
        itemBuilder: (context, index) {
          final order = controller.orders[index];
          return OrderItem(order: order);
        },
      );
    });
  }
}
