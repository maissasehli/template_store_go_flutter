import 'package:flutter/material.dart';

class SizeSelector extends StatelessWidget {
  final String selectedSize;
  final List<String> sizes;
  final ValueChanged<String> onSizeSelected;

  const SizeSelector({
    super.key,
    required this.selectedSize,
    required this.sizes,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (sizes.isEmpty) {
      return const Text(
        'No sizes available',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      );
    }

    return Row(
      children: sizes.map((size) {
        final isSelected = selectedSize == size;
        return Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: GestureDetector(
            onTap: () => onSizeSelected(size),
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.black : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  size,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}