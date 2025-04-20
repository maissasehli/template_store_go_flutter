import 'package:flutter/material.dart';
import 'package:store_go/features/payment/controller/payment_controller.dart';

class PaymentItemWidget extends StatelessWidget {
  final PaymentMethodModel paymentMethod;
  final VoidCallback onTap;

  const PaymentItemWidget({
    Key? key,
    required this.paymentMethod,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // For cards, show card icon
            if (paymentMethod.type == 'card')
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: paymentMethod.cardType == 'mastercard' 
                      ? Colors.red 
                      : Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            
            if (paymentMethod.type == 'card') const SizedBox(width: 12),
            
            // Display masked number for cards or email for PayPal
            Text(
              paymentMethod.type == 'card' 
                  ? paymentMethod.maskedNumber 
                  : paymentMethod.email,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
            ),
            
            // Arrow right
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
      ),
    );
  }
}