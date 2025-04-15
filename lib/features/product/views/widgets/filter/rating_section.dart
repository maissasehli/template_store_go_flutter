// widgets/rating_section.dart
import 'package:flutter/material.dart';
import 'rating_row.dart';

class RatingSection extends StatelessWidget {
  final int selectedRating;
  final Function(int) onRatingSelected;

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
          'Rating',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF121826),
          ),
        ),
        const SizedBox(height: 12),
        
        // Stars rating rows
        RatingRow(
          rating: 5,
          isSelected: selectedRating == 5,
          onTap: () => onRatingSelected(5),
        ),
        const SizedBox(height: 8),
        RatingRow(
          rating: 4,
          isSelected: selectedRating == 4,
          onTap: () => onRatingSelected(4),
        ),
        const SizedBox(height: 8),
        RatingRow(
          rating: 3,
          isSelected: selectedRating == 3,
          onTap: () => onRatingSelected(3),
        ),
        const SizedBox(height: 8),
        RatingRow(
          rating: 2,
          isSelected: selectedRating == 2,
          onTap: () => onRatingSelected(2),
        ),
        const SizedBox(height: 8),
        RatingRow(
          rating: 1,
          isSelected: selectedRating == 1,
          onTap: () => onRatingSelected(1),
        ),
      ],
    );
  }
}