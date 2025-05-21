import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

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
    final bool isRtl = LocalizationService.isRtl(context);

    return Container(
      margin: EdgeInsets.only(top: UIConfig.marginMedium),
      child: Column(
        crossAxisAlignment:
            isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          _buildSummaryRow(
            context,
            'cart.subtotal'.translate(),
            '\$${subtotal.toStringAsFixed(2)}',
          ),
          _buildSummaryRow(
            context,
            'cart.shipping_cost'.translate(),
            '\$${shippingCost.toStringAsFixed(2)}',
          ),
          _buildSummaryRow(
            context,
            'cart.tax'.translate(),
            '\$${tax.toStringAsFixed(2)}',
          ),
          if (discount > 0)
            _buildSummaryRow(
              context,
              couponCode != null
                  ? '${'cart.discount'.translate()} ($couponCode)'
                  : 'cart.discount'.translate(),
              '-\$${discount.toStringAsFixed(2)}',
              valueColor: AppColors.accent(context),
            ),
          Divider(color: AppColors.border(context)),
          _buildSummaryRow(
            context,
            'cart.total'.translate(),
            '\$${total.toStringAsFixed(2)}',
            isTotal: true,
          ),
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
    final bool isRtl = LocalizationService.isRtl(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: UIConfig.paddingSmall * 0.75,
      ), // 6.0
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                fontSize: UIConfig.fontSizeMedium,
                color: AppColors.mutedForeground(context),
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Text(
            value,
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                fontSize: UIConfig.fontSizeMedium,
                color: valueColor ?? AppColors.foreground(context),
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
