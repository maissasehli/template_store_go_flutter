import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';

class CartSummary extends StatelessWidget {
  final double subtotal;
  final double shippingCost;
  final double tax;
  final double discount;
  final double total;
  final String? couponCode;

  const CartSummary({
    super.key,
    required this.subtotal,
    required this.shippingCost,
    required this.tax,
    this.discount = 0.0,
    required this.total,
    this.couponCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: UIConfig.marginMedium),
      child: Column(
        children: [
          _buildSummaryRow(context, 'Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          _buildSummaryRow(context, 'Shipping Cost', '\$${shippingCost.toStringAsFixed(2)}'),
          _buildSummaryRow(context, 'Tax', '\$${tax.toStringAsFixed(2)}'),
          if (discount > 0)
            _buildSummaryRow(
              context,
              couponCode != null ? 'Discount ($couponCode)' : 'Discount',
              '-\$${discount.toStringAsFixed(2)}',
              valueColor: AppColors.accent(context),
            ),
          Divider(color: AppColors.border(context)),
          _buildSummaryRow(context, 'Total', '\$${total.toStringAsFixed(2)}', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: UIConfig.paddingSmall * 0.75), // 6.0
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: UIConfig.fontSizeMedium,
              color: AppColors.mutedForeground(context),
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: UIConfig.fontSizeMedium,
              color: valueColor ?? AppColors.foreground(context),
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}