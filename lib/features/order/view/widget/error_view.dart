// File: lib/features/order/views/widgets/error_view.dart

import 'package:flutter/material.dart';
import 'package:store_go/features/order/controller/order_controller.dart';

class ErrorView extends StatelessWidget {
  final OrderController controller;

  const ErrorView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: ${controller.errorMessage.value}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.fetchOrders(),
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
}