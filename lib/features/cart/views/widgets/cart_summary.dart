import 'package:flutter/material.dart';

class CartSummary extends StatelessWidget {
  final double subtotal;
  final double shippingCost;
  final double tax;
  final double discount;
  final double total;
  final String? couponCode;

  const CartSummary({
    Key? key,
    required this.subtotal,
    required this.shippingCost,
    required this.tax,
    this.discount = 0.0,
    required this.total,
    this.couponCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          _buildSummaryRow('Shipping Cost', '\$${shippingCost.toStringAsFixed(2)}'),
          _buildSummaryRow('Tax', '\$${tax.toStringAsFixed(2)}'),
          if (discount > 0)
            _buildSummaryRow(
              couponCode != null ? 'Discount ($couponCode)' : 'Discount',
              '-\$${discount.toStringAsFixed(2)}',
              valueColor: Colors.green,
            ),
          const Divider(),
          _buildSummaryRow('Total', '\$${total.toStringAsFixed(2)}', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: valueColor,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}