// review_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store_go/features/review/model/review_model.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  
  const ReviewCard({
    super.key,
    required this.review,
  });
  
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final formattedDate = dateFormat.format(review.createdAt);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User avatar
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: 20,
                child: Text(
                  review.userName[0].toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // User info and rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        // Date
                        Text(
                          formattedDate,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Star rating
                    StarRating(rating: review.rating),
                  ],
                ),
              ),
            ],
          ),
          
          // Review content
          if (review.content != null && review.content!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 52.0),
              child: Text(
                review.content!,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final int rating;
  
  const StarRating({
    super.key,
    required this.rating,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          size: 16,
          color: const Color(0xFFFFCC00),
        );
      }),
    );
  }
}