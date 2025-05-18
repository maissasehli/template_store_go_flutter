import 'package:flutter/material.dart';
import 'package:store_go/features/promotion/models/promotion_model.dart';
import 'package:store_go/features/promotion/utils/promotion_utils.dart';

class DiscountBadge extends StatelessWidget {
  final Promotion promotion;

  const DiscountBadge({Key? key, required this.promotion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String discountText;
    IconData iconData;

    switch (promotion.discountType) {
      case DiscountType.percentage:
        discountText = '${promotion.discountValue.toStringAsFixed(0)}%\nOFF';
        iconData = Icons.percent_rounded;
        break;
      case DiscountType.fixedAmount:
        discountText = '\$${promotion.discountValue.toStringAsFixed(0)}\nOFF';
        iconData = Icons.attach_money_rounded;
        break;
      case DiscountType.freeShipping:
        discountText = 'FREE\nSHIP';
        iconData = Icons.local_shipping_rounded;
        break;
      case DiscountType.buyXGetY:
        discountText = '${promotion.buyQuantity}+${promotion.getQuantity}';
        iconData = Icons.card_giftcard_rounded;
        break;
    }

    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: getPromotionColor(promotion),
        boxShadow: [
          BoxShadow(
            color: getPromotionColor(promotion).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, color: Colors.white, size: 20),
          const SizedBox(height: 2),
          Text(
            discountText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}