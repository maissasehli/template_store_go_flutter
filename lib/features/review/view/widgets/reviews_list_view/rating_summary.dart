// rating_summary.dart
import 'package:flutter/material.dart';
import 'package:store_go/features/review/model/review_model.dart';

class RatingSummary extends StatelessWidget {
  final List<Review> reviews;
  final double averageRating;

  const RatingSummary({
    super.key,
    required this.reviews,
    required this.averageRating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Average rating display
          AverageRatingDisplay(
            averageRating: averageRating,
            reviewCount: reviews.length,
          ),
          const SizedBox(width: 20),
          
          // Rating bars
          Expanded(
            child: Column(
              children: List.generate(5, (index) {
                final ratingCount = 5 - index;
                final reviewsWithThisRating = reviews
                    .where((r) => r.rating == ratingCount)
                    .length;
                final percentage = reviews.isEmpty
                    ? 0.0
                    : reviewsWithThisRating / reviews.length;
                
                return RatingBar(
                  starCount: ratingCount,
                  reviewCount: reviewsWithThisRating,
                  percentage: percentage,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class AverageRatingDisplay extends StatelessWidget {
  final double averageRating;
  final int reviewCount;

  const AverageRatingDisplay({
    super.key,
    required this.averageRating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Text(
            averageRating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.grey[850],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < averageRating.round() 
                    ? Icons.star_rounded 
                    : Icons.star_outline_rounded,
                size: 18,
                color: const Color(0xFFFFCC00),
              );
            }),
          ),
          const SizedBox(height: 6),
          Text(
            '$reviewCount ${reviewCount == 1 ? 'review' : 'reviews'}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}

class RatingBar extends StatelessWidget {
  final int starCount;
  final int reviewCount;
  final double percentage;

  const RatingBar({
    super.key,
    required this.starCount,
    required this.reviewCount,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          SizedBox(
            width: 12,
            child: Text(
              '$starCount',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFFFCC00),
                ),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 20,
            child: Text(
              '$reviewCount',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}