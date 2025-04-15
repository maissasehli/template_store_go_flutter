import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      print('Controller not found initially: $e');
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
      _showError('ID de commande non fourni');
      return;
    }
    
    // Try to convert arguments to String
    try {
      orderId = args as String;
      
      // Check if ID is empty
      if (orderId.isEmpty) {
        _showError('ID de commande invalide');
        return;
      }
      
      // Try to find or initialize the controller if not done already
      if (!isInitialized) {
        try {
          controller = Get.find<OrderController>();
          isInitialized = true;
        } catch (e) {
          _showError('Erreur système: contrôleur non disponible');
          return;
        }
      }
      
      // Fetch order details
      controller.fetchOrderDetails(orderId);
    } catch (e) {
      _showError('Format d\'ID de commande invalide');
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Erreur',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.7),
      colorText: Colors.white,
    );
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    // Check if controller is initialized first
    if (!isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order Details'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Get.back(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    // Normal UI with initialized controller
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Obx(() {
          final order = controller.selectedOrder.value;
          return Text(
            order != null ? 'Order #${order.orderNumber}' : 'Order Details',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          );
        }),
      ),
      body: Obx(() {
        if (!isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.isLoadingDetails.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return _buildErrorView();
        }

        final order = controller.selectedOrder.value;
        if (order == null) {
          return const Center(child: Text('Order not found'));
        }

        // Your existing order details UI code
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Timeline
                _buildOrderTimeline(order),
                const SizedBox(height: 24),

                // Order Items
                _buildOrderItems(order),
                const SizedBox(height: 24),

                // Order Summary
                _buildOrderSummary(order),
                const SizedBox(height: 24),

                // Shipping Details
                _buildShippingDetails(order),
                const SizedBox(height: 24),

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
          Text('Error: ${controller.errorMessage.value}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.fetchOrderDetails(orderId),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTimeline(OrderModel order) {
    // Create timeline steps based on order status
    final steps = <Map<String, dynamic>>[
      {'status': 'Order Placed', 'isActive': true, 'isLast': false},
      {
        'status': 'Order Confirmed',
        'isActive': order.status != 'Cancelled',
        'isLast': false
      },
      {
        'status': 'Shipped',
        'isActive': ['Shipped', 'Delivered'].contains(order.status),
        'isLast': false
      },
      {
        'status': 'Delivered',
        'isActive': order.status == 'Delivered',
        'isLast': true
      },
    ];

    if (order.status == 'Cancelled') {
      steps.add({
        'status': 'Cancelled',
        'isActive': true,
        'isLast': true,
      });
    }

    if (order.status == 'Returns') {
      steps.add({
        'status': 'Returned',
        'isActive': true,
        'isLast': true,
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Status',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 12),
        ...steps.map((step) => _buildTimelineItem(
              step['status'],
              order.formattedDate,
              isActive: step['isActive'],
              isLast: step['isLast'],
            )),
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
                color: isActive ? Colors.black : Colors.grey[300],
                border: Border.all(
                  color: isActive ? Colors.black : Colors.grey[300]!,
                  width: 2,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isActive ? Colors.black : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: isActive ? Colors.black : Colors.grey[400],
                ),
              ),
              SizedBox(height: isLast ? 0 : 24),
            ],
          ),
        ),
        Text(
          date,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Poppins',
            color: isActive ? Colors.grey[600] : Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItems(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Items',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),
          
          // Display the first 2 items directly
          ...order.items.take(2).map((item) => _buildOrderItemRow(item)),
          
          // If there are more items, show a "View All" button
          if (order.items.length > 2) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                // Show a bottom sheet with all items
                _showAllItemsBottomSheet(context, order);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View all ${order.items.length} items',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 16),
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
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Product image 
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              image: item.product.imageUrls.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(item.product.imageUrls.first),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: item.product.imageUrls.isEmpty
                ? const Icon(Icons.image_not_supported, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Qty: ${item.quantity}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${item.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
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
                  const Text(
                    'All Items',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Subtotal', '\$${_calculateSubtotal(order).toStringAsFixed(2)}'),
          _buildSummaryRow('Shipping Fee', '\$5.00'),
          _buildSummaryRow('Tax', '\$${_calculateTax(order).toStringAsFixed(2)}'),
          const Divider(height: 24),
          _buildSummaryRow(
            'Total',
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingDetails(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Shipping Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),
          _buildAddressRow(Icons.location_on_outlined, order.shippingAddress),
          const SizedBox(height: 8),
          _buildAddressRow(Icons.phone_outlined, order.phoneNumber),
        ],
      ),
    );
  }

  Widget _buildAddressRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              color: Colors.grey[800],
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
          backgroundColor: Colors.white,
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Cancel Order',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  void _showCancelConfirmationDialog(String orderId) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Cancel Order',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        content: const Text(
          'Are you sure you want to cancel this order? This action cannot be undone.',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'No, Keep Order',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.cancelOrder(orderId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Yes, Cancel Order',
              style: TextStyle(
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}