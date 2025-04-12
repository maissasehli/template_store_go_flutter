// File: lib/features/order/views/widgets/status_color_helper.dart

import 'package:flutter/material.dart';

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'processing':
      return Colors.orange;
    case 'shipped':
      return Colors.blue;
    case 'delivered':
      return Colors.green;
    case 'cancelled':
      return Colors.red;
    case 'returns':
      return Colors.purple;
    default:
      return Colors.grey;
  }
}