import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/features/order/controller/order_controller.dart';
import 'package:store_go/features/order/model/order_model.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  String orderId = '';
  late OrderController controller;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();

    try {
      // Try to find the controller first
      controller = Get.find<OrderController>();
      isInitialized = true;
    } catch (e) {
      // If controller not found, we'll handle this in the post-frame callback
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeOrderDetails();
    });
  }

  void _initializeOrderDetails() {
    // Get arguments safely
    final args = Get.arguments;

    // Check if arguments are null
    if (args == null) {
      _showError('Order ID not provided');
      return;
    }

    // Try to convert arguments to String
    try {
      orderId = args as String;

      // Check if ID is empty
      if (orderId.isEmpty) {
        _showError('Invalid order ID');
        return;
      }

      // Try to find or initialize the controller if not done already
      if (!isInitialized) {
        try {
          controller = Get.find<OrderController>();
          isInitialized = true;
        } catch (e) {
          _showError('System error: controller not available');
          return;
        }
      }

      // Fetch order details
      controller.fetchOrderDetails(orderId);
    } catch (e) {
      _showError('Invalid order ID format');
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'common.error'.translate(),
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.destructive(Get.context!).withOpacity(0.7),
      colorText: AppColors.destructiveForeground(Get.context!),
    );
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    // Check if controller is initialized first
    if (!isInitialized) {
      return Scaffold(
        backgroundColor: AppColors.background(context),
        appBar: AppBar(
          backgroundColor: AppColors.background(context),
          elevation: 0,
          title: Text(
            'orders.order_details'.translate(),
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                color: AppColors.foreground(context),
                fontSize: UIConfig.fontSizeMedium,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          leading: IconButton(
            icon: ThemeAwareSvg(
              assetPath: LocalizationService.isRtl(context)
                  ? AssetConfig.arrowRight
                  : AssetConfig.arrowLeft,
              height: 24,
              width: 24,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary(context)),
        ),
      );
    }

    // Normal UI with initialized controller
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        leading: IconButton(
          icon: ThemeAwareSvg(
            assetPath: LocalizationService.isRtl(context)
                ? AssetConfig.arrowRight
                : AssetConfig.arrowLeft,
            height: 24,
            width: 24,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Obx(() {
          final order = controller.selectedOrder.value;
          return Text(
            order != null 
                ? 'orders.order_number'.translate().replaceFirst('{number}', order.orderNumber)
                : 'orders.order_details'.translate(),
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                color: AppColors.foreground(context),
                fontSize: UIConfig.fontSizeMedium,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          );
        }),
      ),
      body: Obx(() {
        if (!isInitialized) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary(context)),
          );
        }

        if (controller.isLoadingDetails.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary(context)),
          );
        }

        if (controller.hasError.value) {
          return _buildErrorView();
        }

        final order = controller.selectedOrder.value;
        if (order == null) {
          return Center(
            child: Text(
              'orders.order_not_found'.translate(),
              style: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(
                  color: AppColors.foreground(context),
                  fontSize: UIConfig.fontSizeMedium,
                ),
              ),
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(UIConfig.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Timeline
                _buildOrderTimeline(order),
                SizedBox(height: UIConfig.marginLarge),

                // Order Items
                _buildOrderItems(order),
                SizedBox(height: UIConfig.marginLarge),

                // Order Summary
                _buildOrderSummary(order),
                SizedBox(height: UIConfig.marginLarge),

                // Shipping Details
                _buildShippingDetails(order),
                SizedBox(height: UIConfig.marginLarge),

                // If order is still processing, show cancel button
                if (order.status.toLowerCase() == 'processing')
                  _buildCancelButton(order.id),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'common.error'.translate() + ': ${controller.errorMessage.value}',
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                color: AppColors.foreground(context),
                fontSize: UIConfig.fontSizeMedium,
              ),
            ),
          ),
          SizedBox(height: UIConfig.marginMedium),
          ElevatedButton(
            onPressed: () => controller.fetchOrderDetails(orderId),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              foregroundColor: AppColors.primaryForeground(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UIConfig.borderRadiusLarge),
              ),
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

  Widget _buildOrderTimeline(OrderModel order) {
    // Create timeline steps based on order status
    final steps = <Map<String, dynamic>>[
      {'status': 'orders.status.placed'.translate(), 'isActive': true, 'isLast': false},
      {
        'status': 'orders.status.confirmed'.translate(),
        'isActive': order.status != 'Cancelled',
        'isLast': false,
      },
      {
        'status': 'orders.status.shipped'.translate(),
        'isActive': ['Shipped', 'Delivered'].contains(order.status),
        'isLast': false,
      },
      {
        'status': 'orders.status.delivered'.translate(),
        'isActive': order.status == 'Delivered',
        'isLast': true,
      },
    ];

    if (order.status == 'Cancelled') {
      steps.add({'status': 'orders.status.cancelled'.translate(), 'isActive': true, 'isLast': true});
    }

    if (order.status == 'Returns') {
      steps.add({'status': 'orders.status.returned'.translate(), 'isActive': true, 'isLast': true});
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'orders.order_status'.translate(),
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
        SizedBox(height: UIConfig.marginSmall),
        ...steps.map(
          (step) => _buildTimelineItem(
            step['status'],
            order.formattedDate,
            isActive: step['isActive'],
            isLast: step['isLast'],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(
    String status,
    String date, {
    bool isActive = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? AppColors.primary(context) : AppColors.muted(context),
                border: Border.all(
                  color: isActive ? AppColors.primary(context) : AppColors.muted(context),
                  width: 2,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isActive ? AppColors.primary(context) : AppColors.muted(context),
              ),
          ],
        ),
        SizedBox(width: UIConfig.marginMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status,
                style: LocalizationService.getLocalizedTextStyle(
                  context,
                  TextStyle(
                    fontSize: UIConfig.fontSizeRegular,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: isActive ? AppColors.foreground(context) : AppColors.mutedForeground(context),
                  ),
                ),
              ),
              SizedBox(height: isLast ? 0 : UIConfig.marginLarge),
            ],
          ),
        ),
        Text(
          date,
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              fontSize: UIConfig.fontSizeSmall,
              fontFamily: 'Poppins',
              color: isActive ? AppColors.mutedForeground(context) : AppColors.mutedForeground(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItems(OrderModel order) {
    return Container(
      padding: EdgeInsets.all(UIConfig.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'orders.order_items'.translate(),
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
          SizedBox(height: UIConfig.marginMedium),

          // Display the first 2 items directly
          ...order.items.take(2).map((item) => _buildOrderItemRow(item)),

          // If there are more items, show a "View All" button
          if (order.items.length > 2) ...[
            SizedBox(height: UIConfig.marginSmall),
            GestureDetector(
              onTap: () {
                _showAllItemsBottomSheet(context, order);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'orders.view_all_items'.translate().replaceFirst('{count}', order.items.length.toString()),
                    style: LocalizationService.getLocalizedTextStyle(
                      context,
                      TextStyle(
                        fontSize: UIConfig.fontSizeRegular,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary(context),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.primary(context)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderItemRow(OrderItemModel item) {
    return Container(
      margin: EdgeInsets.only(bottom: UIConfig.marginSmall),
      child: Row(
        children: [
          // Product image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.secondary(context),
              borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
              image:
                  item.product?.imageUrls.isNotEmpty == true
                      ? DecorationImage(
                        image: NetworkImage(item.product!.imageUrls.first),
                        fit: BoxFit.cover,
                      )
                      : null,
            ),
            child:
                item.product?.imageUrls.isEmpty != false
                    ? Icon(Icons.image_not_supported, color: AppColors.mutedForeground(context))
                    : null,
          ),
          SizedBox(width: UIConfig.marginSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: LocalizationService.getLocalizedTextStyle(
                    context,
                    TextStyle(
                      fontSize: UIConfig.fontSizeRegular,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      color: AppColors.foreground(context),
                    ),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'orders.quantity'.translate().replaceFirst('{qty}', item.quantity.toString()),
                  style: LocalizationService.getLocalizedTextStyle(
                    context,
                    TextStyle(
                      fontSize: UIConfig.fontSizeSmall,
                      color: AppColors.mutedForeground(context),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${item.totalPrice.toStringAsFixed(2)}',
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                fontSize: UIConfig.fontSizeRegular,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: AppColors.foreground(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAllItemsBottomSheet(BuildContext context, OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(UIConfig.borderRadiusMedium)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(UIConfig.paddingMedium),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'orders.all_items'.translate(),
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
                  IconButton(
                    icon: Icon(Icons.close, color: AppColors.foreground(context)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: UIConfig.marginMedium),
              Expanded(
                child: ListView.builder(
                  itemCount: order.items.length,
                  itemBuilder: (context, index) {
                    return _buildOrderItemRow(order.items[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderSummary(OrderModel order) {
    return Container(
      padding: EdgeInsets.all(UIConfig.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'orders.order_summary'.translate(),
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
          SizedBox(height: UIConfig.marginMedium),
          _buildSummaryRow(
            'orders.subtotal'.translate(),
            '\$${_calculateSubtotal(order).toStringAsFixed(2)}',
          ),
          _buildSummaryRow('orders.shipping_fee'.translate(), '\$5.00'),
          _buildSummaryRow(
            'orders.tax'.translate(),
            '\$${_calculateTax(order).toStringAsFixed(2)}',
          ),
          Divider(height: UIConfig.marginLarge, color: AppColors.border(context)),
          _buildSummaryRow(
            'orders.total'.translate(),
            '\$${order.totalAmount.toStringAsFixed(2)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  double _calculateSubtotal(OrderModel order) {
    // Assuming total = subtotal + shipping + tax
    return order.totalAmount - 5.0 - _calculateTax(order);
  }

  double _calculateTax(OrderModel order) {
    // Assuming tax is 8% of the order subtotal
    return (order.totalAmount - 5.0) * 0.08 / 1.08;
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: UIConfig.paddingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                fontSize: UIConfig.fontSizeRegular,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
                fontFamily: 'Poppins',
                color: AppColors.foreground(context),
              ),
            ),
          ),
          Text(
            value,
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                fontSize: UIConfig.fontSizeRegular,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
                fontFamily: 'Poppins',
                color: AppColors.foreground(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingDetails(OrderModel order) {
    return Container(
      padding: EdgeInsets.all(UIConfig.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'orders.shipping_details'.translate(),
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
          SizedBox(height: UIConfig.marginMedium),
          _buildAddressRow(
            Icons.location_on_outlined,
            order.formattedShippingAddress,
          ),
          SizedBox(height: UIConfig.paddingSmall),
          _buildAddressRow(Icons.phone_outlined, order.shippingAddress.phone),
        ],
      ),
    );
  }

  Widget _buildAddressRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.mutedForeground(context)),
        SizedBox(width: UIConfig.paddingSmall),
        Expanded(
          child: Text(
            text,
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                fontSize: UIConfig.fontSizeRegular,
                fontFamily: 'Poppins',
                color: AppColors.foreground(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCancelButton(String orderId) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showCancelConfirmationDialog(orderId),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.background(context),
          foregroundColor: AppColors.destructive(context),
          side: BorderSide(color: AppColors.destructive(context)),
          padding: EdgeInsets.symmetric(vertical: UIConfig.paddingSmall),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
          ),
        ),
        child: Text(
          'orders.cancel_order'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              fontSize: UIConfig.fontSizeRegular,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: AppColors.destructive(context),
            ),
          ),
        ),
      ),
    );
  }

  void _showCancelConfirmationDialog(String orderId) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.card(context),
        title: Text(
          'orders.cancel_order'.translate(),
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
        content: Text(
          'orders.cancel_order_confirmation'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              fontSize: UIConfig.fontSizeRegular,
              fontFamily: 'Poppins',
              color: AppColors.foreground(context),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'common.cancel'.translate(),
              style: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(
                  color: AppColors.foreground(context),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.cancelOrder(orderId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.destructive(context),
              foregroundColor: AppColors.destructiveForeground(context),
            ),
            child: Text(
              'orders.confirm_cancel'.translate(),
              style: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.destructiveForeground(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
