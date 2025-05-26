import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/features/order/controller/order_controller.dart';
import 'package:store_go/features/order/view/widget/empty_order_state.dart';
import 'package:store_go/features/order/view/widget/error_view.dart';
import 'package:store_go/features/order/view/widget/order_list.dart';
import 'package:store_go/features/order/view/widget/order_status_tabs.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();
    final bool isRtl = LocalizationService.isRtl(context);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.only(left: isRtl ? 0 : 16, right: isRtl ? 16 : 0),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.secondary(context),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: ThemeAwareSvg(
              assetPath: isRtl ? AssetConfig.arrowRight : AssetConfig.arrowLeft,
              height: 24,
              width: 24,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        centerTitle: true,
        title: Text(
          'orders.title'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              color: AppColors.foreground(context),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchOrders(),
        color: AppColors.primary(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Status Tabs
            Obx(
              () =>
                  controller.isLoading.value && controller.orders.isEmpty
                      ? const SizedBox.shrink()
                      : OrderStatusTabs(controller: controller),
            ),
            // Orders List, Loading Indicator, or Empty State
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.orders.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary(context),
                    ),
                  );
                }

                if (controller.hasError.value) {
                  return ErrorView(controller: controller);
                }

                if (!controller.hasOrders.value) {
                  return const EmptyOrderState();
                }

                return OrderList(controller: controller);
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.background(context),
          border: Border(
            top: BorderSide(color: AppColors.border(context), width: 1),
          ),
        ),
      ),
    );
  }
}
