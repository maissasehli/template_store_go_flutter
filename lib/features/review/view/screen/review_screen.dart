import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/review/model/review_model.dart';

class ReviewsPage extends StatefulWidget {
  final List<Review> reviews;
  final double averageRating;
  final Function onAddReview;
  final Product product;

  const ReviewsPage({
    super.key,
    required this.reviews,
    required this.averageRating,
    required this.onAddReview,
    required this.product,
  });

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  String _activeFilter = 'All Reviews';
  final List<String> _filterOptions = ['All Reviews', '5 ★', '4 ★', '3 ★', '2 ★', '1 ★'];
  late List<Review> _filteredReviews;
  final Map<String, String> _sortOptions = {
    'newest': 'Newest First',
    'oldest': 'Oldest First',
    'highest': 'Highest Rating',
    'lowest': 'Lowest Rating',
  };
  String _currentSort = 'newest';

  @override
  void initState() {
    super.initState();
    _filteredReviews = List.from(widget.reviews);
    _sortReviews();
  }

  void _applyFilter(String filter) {
    setState(() {
      _activeFilter = filter;
      if (filter == 'All Reviews') {
        _filteredReviews = List.from(widget.reviews);
      } else {
        final starRating = int.parse(filter.split(' ')[0]);
        _filteredReviews = widget.reviews.where((review) => review.rating == starRating).toList();
      }
      _sortReviews();
    });
  }

  void _applySorting(String sortType) {
    setState(() {
      _currentSort = sortType;
      _sortReviews();
    });
  }

  void _sortReviews() {
    switch (_currentSort) {
      case 'newest':
        _filteredReviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
        _filteredReviews.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'highest':
        _filteredReviews.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'lowest':
        _filteredReviews.sort((a, b) => a.rating.compareTo(b.rating));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Customer Reviews',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (widget.reviews.isNotEmpty)
            PopupMenuButton<String>(
              icon: const Icon(Icons.sort),
              tooltip: 'Sort reviews',
              onSelected: _applySorting,
              itemBuilder: (context) {
                return _sortOptions.entries.map((entry) {
                  return PopupMenuItem<String>(
                    value: entry.key,
                    child: Row(
                      children: [
                        if (_currentSort == entry.key)
                          Icon(Icons.check, color: AppColors.primary(context), size: 18)
                        else
                          const SizedBox(width: 18),
                        const SizedBox(width: 8),
                        Text(
                          entry.value,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: _currentSort == entry.key ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
        ],
      ),
      body: widget.reviews.isEmpty
          ? _buildEmptyState()
          : _buildReviewsList(context),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(red: 0, green: 0, blue: 0, alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
          border: Border(
            top: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            widget.onAddReview();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary(context),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
          ),
          child: const Text(
            'Write a Review',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rate_review_outlined, 
            size: 80, 
            color: Colors.grey[300]
          ),
          const SizedBox(height: 24),
          Text(
            'No Reviews Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Be the first to share your experience',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 40),
          // Product thumbnail reminder
          Container(
            padding: const EdgeInsets.all(16),
            width: 280,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: widget.product.images.isNotEmpty
                        ? Image.network(
                            widget.product.images[0],
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          color: AppColors.primary(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Rating summary
              Container(
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
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.averageRating.toStringAsFixed(1),
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
                                index < widget.averageRating.round() 
                                    ? Icons.star_rounded 
                                    : Icons.star_outline_rounded,
                                size: 18,
                                color: const Color(0xFFFFCC00),
                              );
                            }),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${widget.reviews.length} ${widget.reviews.length == 1 ? 'review' : 'reviews'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    
                    // Rating bars
                    Expanded(
                      child: Column(
                        children: List.generate(5, (index) {
                          final ratingCount = 5 - index;
                          final reviewsWithThisRating = widget.reviews
                              .where((r) => r.rating == ratingCount)
                              .length;
                          final percentage = widget.reviews.isEmpty
                              ? 0.0
                              : reviewsWithThisRating / widget.reviews.length;
                          
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
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
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: percentage,
                                      backgroundColor: Colors.grey[200],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        const Color(0xFFFFCC00),
                                      ),
                                      minHeight: 8,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 20,
                                  child: Text(
                                    '$reviewsWithThisRating',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
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
              
              // Filter chips
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    const Text(
                      'Filter:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _filterOptions.map((filter) {
                            final isActive = _activeFilter == filter;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(
                                  filter,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                                    color: isActive ? Colors.white : Colors.grey[800],
                                  ),
                                ),
                                selected: isActive,
                                showCheckmark: false,
                                backgroundColor: Colors.grey[100],
                                selectedColor: AppColors.primary(context),
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                    color: isActive 
                                        ? AppColors.primary(context) 
                                        : Colors.grey[300]!,
                                  ),
                                ),
                                onSelected: (selected) {
                                  if (selected) {
                                    _applyFilter(filter);
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Results count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${_filteredReviews.length} ${_filteredReviews.length == 1 ? 'review' : 'reviews'}',
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
          child: _filteredReviews.isEmpty 
              ? _buildNoFilterResultsState()
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredReviews.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final review = _filteredReviews[index];
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
                                      Row(
                                        children: List.generate(5, (index) {
                                          return Icon(
                                            index < review.rating ? Icons.star : Icons.star_border,
                                            size: 16,
                                            color: const Color(0xFFFFCC00),
                                          );
                                        }),
                                      ),
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
                    },
                  ),
                ),
        ),
      ],
    );
  }
  
  Widget _buildNoFilterResultsState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No reviews match your filter',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _applyFilter('All Reviews'),
            child: Text(
              'Show all reviews',
              style: TextStyle(
                color: AppColors.primary(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}