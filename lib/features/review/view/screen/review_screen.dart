import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/auth/services/auth_service.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/review/controllers/review_controller.dart';
import 'package:store_go/features/review/model/review_model.dart';
import 'package:store_go/features/review/view/widgets/empty_state.dart';
import 'package:store_go/features/review/view/widgets/review_bottom_bar.dart';
import 'package:store_go/features/review/view/widgets/review_filter.dart';
import 'package:store_go/features/review/view/widgets/review_header.dart';
import 'package:store_go/features/review/view/widgets/review_list.dart';

class ReviewsPage extends StatefulWidget {
  final List<Review> reviews;
  final double averageRating;
  final VoidCallback onAddReview;
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
  final List<String> _filterOptions = [
    'All Reviews',
    '5 ★',
    '4 ★',
    '3 ★',
    '2 ★',
    '1 ★',
  ];
  late List<Review> _filteredReviews;
  String _currentSort = 'newest';
  final List<String> _sortOptions = [
    'Newest',
    'Oldest',
    'Highest Rating',
    'Lowest Rating',
  ];
  String? _editingReviewId;
  final _editRating = 0.obs;
  final _editCommentController = TextEditingController();
  final _editCommentFocusNode = FocusNode(); // Added FocusNode
  final _isSubmitting = false.obs;
  ReviewController? _reviewController;
  String? _currentUserId;
  final Logger _logger = Logger();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  String capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  Future<void> _initialize() async {
    try {
      _logger.d('Initializing ReviewsPage...');
      _filteredReviews = List.from(widget.reviews);
      _sortReviews();

      if (!Get.isRegistered<ReviewController>()) {
        _logger.w('ReviewController not registered.');
        Get.snackbar(
          'Error',
          'Review service not available.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        Get.back();
        return;
      }
      _reviewController = Get.find<ReviewController>();
      _logger.d('ReviewController fetched successfully.');

      _currentUserId = await Get.find<AuthService>().getCurrentUserId();
      if (_currentUserId == null) {
        _logger.w('No authenticated user found');
      } else {
        _logger.d('Current user ID: $_currentUserId');
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      _logger.e('Error initializing ReviewsPage: $e');
      Get.snackbar(
        'Error',
        'Failed to load reviews page.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.back();
    }
  }

  @override
  void dispose() {
    _editCommentController.dispose();
    _editCommentFocusNode.dispose(); // Dispose the FocusNode
    super.dispose();
  }

  void _applyFilter(String filter) {
    setState(() {
      _activeFilter = filter;
      if (filter == 'All Reviews') {
        _filteredReviews = List.from(widget.reviews);
      } else {
        final starRating = int.parse(filter.split(' ')[0]);
        _filteredReviews =
            widget.reviews
                .where((review) => review.rating == starRating)
                .toList();
      }
      _sortReviews();
    });
  }

  void _applySorting(String sortType) {
    setState(() {
      _currentSort = sortType.toLowerCase();
      _sortReviews();
    });
  }

  void _sortReviews() {
    try {
      switch (_currentSort) {
        case 'newest':
          _filteredReviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
        case 'oldest':
          _filteredReviews.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          break;
        case 'highest rating':
          _filteredReviews.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case 'lowest rating':
          _filteredReviews.sort((a, b) => a.rating.compareTo(b.rating));
          break;
      }
    } catch (e) {
      _logger.e('Error sorting reviews: $e');
      Get.snackbar(
        'Error',
        'Failed to sort reviews.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _startEditingReview(Review review) {
    setState(() {
      _editingReviewId = review.id;
      _editRating.value = review.rating;
      _editCommentController.text = review.content ?? '';
    });
  }

  void _cancelEditing() {
    setState(() {
      _editingReviewId = null;
      _editRating.value = 0;
      _editCommentController.clear();
    });
  }

  Future<void> _submitEditedReview(String reviewId) async {
    // Validation already happens in EditReviewForm, but double-check here
    if (_editRating.value == 0) {
      Get.snackbar(
        'Error',
        'Please select a rating',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_editCommentController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please write a review comment',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_isSubmitting.value) return;
    _isSubmitting.value = true;

    try {
      _logger.i(
        'Submitting edited review: $reviewId with rating ${_editRating.value}',
      );

      final updates = {
        'rating': _editRating.value,
        'content': _editCommentController.text.trim(),
      };

      // Key fix: Use await here and properly handle the result
      final success = await _reviewController!.updateReview(reviewId, updates);

      if (success) {
        // Important: Reset editing state first
        setState(() {
          _editingReviewId = null;
        });

        // Update the reviews list
        await _reviewController!.fetchReviews(widget.product.id);

        // Apply filters and sorting after update
        setState(() {
          _filteredReviews = List.from(_reviewController!.reviews);
          _applyFilter(_activeFilter);
          _sortReviews();

          // Clear editing state
          _editRating.value = 0;
          _editCommentController.clear();
        });

        _logger.i('Review updated successfully and UI refreshed');
      } else {
        _logger.w('Review update returned false, UI not refreshed');
      }
    } catch (e) {
      _logger.e('Error updating review: $e');
      Get.snackbar(
        'Error',
        'Failed to update review: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      // Important: Make sure isSubmitting is always set to false
      _isSubmitting.value = false;
    }
  }

  Future<void> _deleteReview(String reviewId) async {
    if (_isSubmitting.value) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Review'),
            content: const Text('Are you sure you want to delete this review?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      _isSubmitting.value = true;
      try {
        final deletedReview = _reviewController!.reviews.firstWhere(
          (r) => r.id == reviewId,
        );
        bool success = await _reviewController!.deleteReview(reviewId);
        if (success) {
          setState(() {
            _filteredReviews = List.from(_reviewController!.reviews);
            _sortReviews();
          });
        } else {
          Get.snackbar(
            'Error',
            'Failed to delete review.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        _logger.e('Error deleting review: $e');
        Get.snackbar(
          'Error',
          'Failed to delete review.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        _isSubmitting.value = false;
      }
    }
  }

  // In your ReviewsPage class, make these key changes:

  // 1. Modify the body build method in ReviewsPage to handle the loading state better:

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_reviewController == null) {
      return const Scaffold(
        body: Center(child: Text('Error: Review service not available')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        title: Text(
          'Customer Reviews',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: AppColors.foreground(context),
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background(context),
        elevation: 0.5,
        iconTheme: IconThemeData(color: AppColors.foreground(context)),
      ),
      body: CustomScrollView(
        slivers: [
          // Header, Filter, and Sort controls
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Review header
                ReviewHeader(
                  averageRating: widget.averageRating,
                  reviews: widget.reviews,
                ),

                // Filter options
                ReviewFilter(
                  activeFilter: _activeFilter,
                  filterOptions: _filterOptions,
                  onFilterSelected: _applyFilter,
                ),

                // Sort dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_filteredReviews.length} ${_filteredReviews.length == 1 ? 'review' : 'reviews'}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          color: AppColors.mutedForeground(context),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border(context)),
                          color: AppColors.card(context),
                        ),
                        child: PopupMenuButton<String>(
                          initialValue: _sortOptions.firstWhere(
                            (option) => option.toLowerCase() == _currentSort,
                            orElse: () => _sortOptions.first,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          offset: const Offset(0, 40),
                          onSelected: (String newSort) {
                            _applySorting(newSort);
                          },
                          itemBuilder:
                              (context) =>
                                  _sortOptions.map((String option) {
                                    bool isSelected =
                                        option.toLowerCase() == _currentSort;
                                    return PopupMenuItem<String>(
                                      value: option,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              option,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight:
                                                    isSelected
                                                        ? FontWeight.w600
                                                        : FontWeight.normal,
                                                color:
                                                    isSelected
                                                        ? Theme.of(
                                                          context,
                                                        ).primaryColor
                                                        : null,
                                              ),
                                            ),
                                          ),
                                          if (isSelected)
                                            Icon(
                                              Icons.check,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).primaryColor,
                                              size: 18,
                                            ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  capitalize(_currentSort),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.foreground(context),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColors.mutedForeground(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Add a loading indicator that appears during submission
                Obx(
                  () =>
                      _isSubmitting.value
                          ? Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          // Show Empty State or Review List - with proper loading state handling
          _reviewController!.isLoading.value && !_isSubmitting.value
              ? const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
              : _filteredReviews.isEmpty
              ? SliverFillRemaining(child: EmptyState(product: widget.product))
              : ReviewList(
                reviews: _filteredReviews,
                editingReviewId: _editingReviewId,
                currentUserId: _currentUserId,
                reviewController: _reviewController!,
                editRating: _editRating,
                editCommentController: _editCommentController,
                editCommentFocusNode: _editCommentFocusNode,
                isSubmitting: _isSubmitting,
                onEdit: _startEditingReview,
                onDelete: _deleteReview,
                onSubmitEdit: _submitEditedReview,
                onCancelEdit: _cancelEditing,
              ),
        ],
      ),
      bottomNavigationBar: ReviewBottomBar(
        currentUserId: _currentUserId,
        reviewController: _reviewController!,
        onAddReview: widget.onAddReview,
        productId: widget.product.id,
      ),
    );
  }
}
