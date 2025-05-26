// File: lib/features/order/views/widgets/error_view.dart

import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/features/order/controller/order_controller.dart';

class ErrorView extends StatelessWidget {
  final OrderController controller;

  const ErrorView({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error: ${controller.errorMessage.value}',
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                color: AppColors.destructive(context),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.fetchOrders(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              foregroundColor: AppColors.primaryForeground(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              'orders.retry'.translate(),
              style: LocalizationService.getLocalizedTextStyle(
                context,
                const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
