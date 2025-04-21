// reviews_list_view.dart
import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/review/model/review_model.dart';
import 'package:store_go/features/review/view/widgets/reviews_list_view/filter_chips_row.dart';
import 'package:store_go/features/review/view/widgets/reviews_list_view/no_filter_results.dart';
import 'package:store_go/features/review/view/widgets/reviews_list_view/rating_summary.dart';
import 'package:store_go/features/review/view/widgets/reviews_list_view/review_card.dart';


class ReviewsListView extends StatelessWidget {
  final List<Review> filteredReviews;
  final List<Review> reviews;
  final double averageRating;
  final String activeFilter;
  final List<String> filterOptions;
  final Function(String) onFilterApplied;

  const ReviewsListView({
    super.key,
    required this.filteredReviews,
    required this.reviews,
    required this.averageRating,
    required this.activeFilter,
    required this.filterOptions,
    required this.onFilterApplied,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Rating summary
              RatingSummary(
                reviews: reviews,
                averageRating: averageRating,
              ),
              
              // Filter chips
              FilterChipsRow(
                filterOptions: filterOptions,
                activeFilter: activeFilter,
                onFilterApplied: onFilterApplied,
              ),
              
              // Results count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${filteredReviews.length} ${filteredReviews.length == 1 ? 'review' : 'reviews'}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Reviews list
        SliverToBoxAdapter(
          child: filteredReviews.isEmpty 
              ? NoFilterResults(onReset: () => onFilterApplied('All Reviews'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredReviews.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final review = filteredReviews[index];
                      return ReviewCard(review: review);
                    },
                  ),
                ),
        ),
      ],
    );
  }
}