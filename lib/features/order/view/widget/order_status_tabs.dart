// File: lib/features/order/views/widgets/order_status_tabs.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/features/order/controller/order_controller.dart';

class OrderStatusTabs extends StatelessWidget {
  final OrderController controller;

  const OrderStatusTabs({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        horizontal: UIConfig.paddingMedium,
        vertical: UIConfig.paddingSmall,
      ),
      child: Obx(
        () => Row(
          children: [
            _buildStatusTab(
              context,
              'orders.status.processing'.translate(),
              'processing',
              controller.selectedStatus.value == 'processing',
            ),
            SizedBox(width: UIConfig.marginSmall),
            _buildStatusTab(
              context,
              'orders.status.shipped'.translate(),
              'shipped',
              controller.selectedStatus.value == 'shipped',
            ),
            SizedBox(width: UIConfig.marginSmall),
            _buildStatusTab(
              context,
              'orders.status.delivered'.translate(),
              'delivered',
              controller.selectedStatus.value == 'delivered',
            ),
            SizedBox(width: UIConfig.marginSmall),
            _buildStatusTab(
              context,
              'orders.status.cancelled'.translate(),
              'cancelled',
              controller.selectedStatus.value == 'cancelled',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTab(
    BuildContext context,
    String label,
    String status,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => controller.changeOrderStatus(status),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: UIConfig.paddingMedium,
          vertical: UIConfig.paddingSmall,
        ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary(context)
                  : AppColors.secondary(context),
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusLarge),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.primary(context)
                    : AppColors.border(context),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: UIConfig.fontSizeRegular,
            fontWeight: FontWeight.w500,
            color:
                isSelected
                    ? AppColors.primaryForeground(context)
                    : AppColors.foreground(context),
          ),
        ),
      ),
    );
  }
}
