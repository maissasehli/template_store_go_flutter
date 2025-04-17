import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/review/model/review_model.dart';

class ReviewSection extends StatelessWidget {
  final List<Review> reviews;

  const ReviewSection({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          'No reviews yet.',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            color: Colors.grey,
          ),
        ),
      );
    }

    double averageRating = reviews.isNotEmpty
        ? reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length
        : 0;

    return Row(
      children: [
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < averageRating.round() ? Icons.star : Icons.star_border,
              size: 16,
              color: index < averageRating.round() ? Colors.amber : Colors.grey,
            );
          }),
        ),
        const SizedBox(width: 4),
        Text(
          '(${reviews.length} Reviews)',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}