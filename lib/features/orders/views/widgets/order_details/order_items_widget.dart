import 'package:flutter/material.dart';
import '../../../models/order_model.dart';

class OrderItemsWidget extends StatelessWidget {
  final OrderModel order;
  
  const OrderItemsWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.receipt_outlined, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${order.itemCount} items',
                    style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Navigate to detailed items list
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}