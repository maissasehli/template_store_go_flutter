import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final double size;
  final Color? color;
  final bool showReviewCount;

  const RatingStars({
    Key? key,
    required this.rating,
    this.reviewCount = 0,
    this.size = 16,
    this.color,
    this.showReviewCount = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final starColor = color ?? Colors.amber;
    final fullStars = rating.floor();
    final halfStar = (rating - fullStars) >= 0.5;
    final emptyStars = 5 - fullStars - (halfStar ? 1 : 0);

    return Row(
      children: [
        // Full stars
        ...List.generate(
          fullStars,
          (index) => Icon(
            Icons.star,
            color: starColor,
            size: size,
          ),
        ),
        
        // Half star
        if (halfStar)
          Icon(
            Icons.star_half,
            color: starColor,
            size: size,
          ),
        
        // Empty stars
        ...List.generate(
          emptyStars,
          (index) => Icon(
            Icons.star_border,
            color: starColor,
            size: size,
          ),
        ),
        
        // Review count
        if (showReviewCount && reviewCount > 0)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              '($reviewCount)',
              style: TextStyle(
                fontSize: size * 0.8,
                color: Colors.grey.shade600,
              ),
            ),
          ),
      ],
    );
  }
}