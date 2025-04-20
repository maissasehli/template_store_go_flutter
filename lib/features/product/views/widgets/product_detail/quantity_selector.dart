import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              if (quantity > 1) onQuantityChanged(quantity - 1);
            },
            child: const Icon(Icons.remove, size: 20, color: Colors.black),
          ),
          const SizedBox(width: 8),
          Text(
            '$quantity',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => onQuantityChanged(quantity + 1),
            child: const Icon(Icons.add, size: 20, color: Colors.black),
          ),
        ],
      ),
    );
  }
}