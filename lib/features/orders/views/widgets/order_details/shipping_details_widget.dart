import 'package:flutter/material.dart';
import '../../../models/order_model.dart';

class ShippingDetailsWidget extends StatelessWidget {
  final OrderModel order;
  
  const ShippingDetailsWidget({
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
            'Shipping details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            order.shippingAddress,
            style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
          ),
          const SizedBox(height: 8),
          Text(
            order.phoneNumber,
            style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
          ),
        ],
      ),
    );
  }
}