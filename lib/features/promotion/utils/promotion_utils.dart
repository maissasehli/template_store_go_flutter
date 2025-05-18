import 'package:flutter/material.dart';
import 'package:store_go/features/promotion/models/promotion_model.dart';

Color getPromotionColor(Promotion promotion) {
  switch (promotion.discountType) {
    case DiscountType.percentage:
      return Colors.purple;
    case DiscountType.fixedAmount:
      return Colors.green;
    case DiscountType.freeShipping:
      return Colors.blue;
    case DiscountType.buyXGetY:
      return Colors.orange;
  }
}

IconData getPromotionIcon(Promotion promotion) {
  switch (promotion.discountType) {
    case DiscountType.percentage:
      return Icons.percent_rounded;
    case DiscountType.fixedAmount:
      return Icons.attach_money_rounded;
    case DiscountType.freeShipping:
      return Icons.local_shipping_rounded;
    case DiscountType.buyXGetY:
      return Icons.card_giftcard_rounded;
  }
}

String getPromotionTag(Promotion promotion) {
  switch (promotion.discountType) {
    case DiscountType.percentage:
      return '${promotion.discountValue.toStringAsFixed(0)}% OFF';
    case DiscountType.fixedAmount:
      return '\$${promotion.discountValue.toStringAsFixed(0)} OFF';
    case DiscountType.freeShipping:
      return 'FREE SHIPPING';
    case DiscountType.buyXGetY:
      return 'BUY ${promotion.buyQuantity} GET ${promotion.getQuantity}';
  }
}

String formatDate(DateTime date) {
  final months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${date.day} ${months[date.month - 1]}, ${date.year}';
}

String getTermsText(Promotion promotion) {
  String terms = '';

  switch (promotion.discountType) {
    case DiscountType.percentage:
      terms = 'Get ${promotion.discountValue.toStringAsFixed(0)}% off on applicable products.';
      break;
    case DiscountType.fixedAmount:
      terms = 'Get \$${promotion.discountValue.toStringAsFixed(2)} off on your purchase.';
      break;
    case DiscountType.freeShipping:
      terms = 'Enjoy free shipping on your order.';
      break;
    case DiscountType.buyXGetY:
      terms = 'Buy ${promotion.buyQuantity} eligible items and get ${promotion.getQuantity} free.';
      break;
  }

  terms += ' Minimum purchase amount: \$${promotion.minimumPurchase.toStringAsFixed(2)}.';
  if (promotion.couponCode != null && promotion.couponCode!.isNotEmpty) {
    terms += ' Use code ${promotion.couponCode} at checkout.';
  }
  terms += ' Cannot be combined with other promotions. Valid from ${formatDate(promotion.startDate)} to ${formatDate(promotion.endDate)}.';
  return terms;
}