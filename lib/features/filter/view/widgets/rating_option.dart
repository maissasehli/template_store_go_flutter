import 'package:flutter/material.dart';


class RatingOption extends StatelessWidget {
  final int stars;
  final bool isSelected;
  final VoidCallback onTap;

  const RatingOption({
    super.key,
    required this.stars,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.black : Colors.transparent,
              border: Border.all(color: Colors.grey[300]!),
            ),
            child:
                isSelected
                    ? const Center(
                      child: Icon(Icons.circle, color: Colors.white, size: 8),
                    )
                    : null,
          ),
        ),
        const SizedBox(width: 8),
        Row(
          children: [
            ...List.generate(
              stars,
              (_) => const Icon(Icons.star, color: Colors.amber, size: 16),
            ),
            ...List.generate(
              5 - stars,
              (_) =>
                  const Icon(Icons.star_outline, color: Colors.grey, size: 16),
            ),
          ],
        ),
      ],
    );
  }
}
