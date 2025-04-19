// widgets/rating_row.dart
import 'package:flutter/material.dart';

class RatingRow extends StatelessWidget {
  final int rating;
  final bool isSelected;
  final VoidCallback onTap;

  const RatingRow({
    super.key,
    required this.rating,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
              color: isSelected ? Colors.black : Colors.white,
            ),
            child: isSelected 
                ? const Center(
                    child: Icon(
                      Icons.circle,
                      size: 8,
                      color: Colors.white,
                    ),
                  ) 
                : null,
          ),
          const SizedBox(width: 12),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                size: 20,
                color: index < rating ? Colors.amber : Colors.grey[300],
              ),
            ),
          ),
        ],
      ),
    );
  }
}