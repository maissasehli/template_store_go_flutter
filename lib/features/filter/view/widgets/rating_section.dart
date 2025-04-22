import 'package:flutter/material.dart';

class RatingSection extends StatelessWidget {
  final int selectedRating;
  final ValueChanged<int> onRatingSelected;

  const RatingSection({
    super.key,
    required this.selectedRating,
    required this.onRatingSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Minimum Rating',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(6, (index) {
            return GestureDetector(
              onTap: () {
                onRatingSelected(index); // 0 to 5 stars
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(
                  index == 0
                      ? Icons.star_border_rounded // For "No rating" (0)
                      : index <= selectedRating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                  size: 32,
                  color: index == 0
                      ? Colors.grey[700]
                      : index <= selectedRating
                          ? const Color(0xFFFFCC00)
                          : Colors.grey[300],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}