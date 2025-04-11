// price_counter.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/product/controllers/product_detail_controller.dart';

class PriceAndCountItems extends StatelessWidget {
  final String price;
  final String count;
  final Function()? onAdd;
  final Function()? onRemove;
  
  const PriceAndCountItems({
    Key? key,
    required this.price,
    required this.count,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Price display
        Text(
          '\$$price',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        
        const Spacer(),
        
        // Counter with plus/minus buttons
        Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Minus button
              InkWell(
                onTap: onRemove,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '-',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              
              // Quantity display
              Text(
                count,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              
              // Plus button
              InkWell(
                onTap: onAdd,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '+',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}