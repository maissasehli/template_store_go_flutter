import 'package:flutter/material.dart';
import 'package:store_go/features/review/model/review_model.dart';

class RatingSummary extends StatelessWidget {
  final List<Review> reviews;
  final double averageRating;
  final VoidCallback onTap;

  const RatingSummary({
    super.key,
    required this.reviews,
    required this.averageRating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < averageRating.round() ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 14,
                      color: const Color(0xFFFFCC00),
                    );
                  }),
                ),
                const SizedBox(height: 2),
                Text(
                  '${reviews.length} ${reviews.length == 1 ? 'review' : 'reviews'}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600], fontFamily: 'Poppins'),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: List.generate(5, (index) {
                  final ratingCount = 5 - index;
                  final reviewsWithThisRating = reviews.where((r) => r.rating == ratingCount).length;
                  final percentage = reviews.isEmpty ? 0.0 : reviewsWithThisRating / reviews.length;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 12,
                          child: Text(
                            '$ratingCount',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: percentage,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFCC00)),
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        SizedBox(
                          width: 20,
                          child: Text(
                            '$reviewsWithThisRating',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}