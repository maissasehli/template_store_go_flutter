import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
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
  final List<String> _filterOptions = ['All Reviews', '5 ★', '4 ★', '3 ★', '2 ★', '1 ★'];
  late List<Review> _filteredReviews;
  String _currentSort = 'newest';
  final List<String> _sortOptions = ['Newest', 'Oldest', 'Highest Rating', 'Lowest Rating'];
  String? _editingReviewId;
  final _editRating = 0.obs;
  final _editCommentController = TextEditingController();
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
      _logger.i('Initializing ReviewsPage...');
      _filteredReviews = List.from(widget.reviews);
      _sortReviews();

      if (!Get.isRegistered<ReviewController>()) {
        _logger.w('ReviewController not registered.');
        Get.snackbar('Error', 'Review service not available.',
            backgroundColor: Colors.red, colorText: Colors.white);
        Get.back();
        return;
      }
      _reviewController = Get.find<ReviewController>();
      _logger.i('ReviewController fetched successfully.');

      _currentUserId = await Get.find<AuthService>().getCurrentUserId();
      if (_currentUserId == null) {
        _logger.w('No authenticated user found');
      } else {
        _logger.i('Current user ID: $_currentUserId');
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      _logger.e('Error initializing ReviewsPage: $e');
      Get.snackbar('Error', 'Failed to load reviews page.',
          backgroundColor: Colors.red, colorText: Colors.white);
      Get.back();
    }
  }

  @override
  void dispose() {
    _editCommentController.dispose();
    super.dispose();
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
      Get.snackbar('Error', 'Failed to sort reviews.', backgroundColor: Colors.red, colorText: Colors.white);
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
    if (_editRating.value == 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a rating'), backgroundColor: Colors.red),
        );
      }
      return;
    }
    if (_isSubmitting.value) return;
    _isSubmitting.value = true;

    try {
      final updates = {
        'rating': _editRating.value,
        'content': _editCommentController.text.isNotEmpty ? _editCommentController.text : null,
      };

      await _reviewController!.updateReview(reviewId, updates);
      setState(() {
        _editingReviewId = null;
        _editRating.value = 0;
        _editCommentController.clear();
        _filteredReviews = List.from(_reviewController!.reviews);
        _sortReviews();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review updated successfully'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      _logger.e('Error updating review: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update review'), backgroundColor: Colors.red),
        );
      }
    } finally {
      _isSubmitting.value = false;
    }
  }

  Future<void> _deleteReview(String reviewId) async {
    if (_isSubmitting.value) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Review'),
        content: const Text('Are you sure you want to delete this review?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _isSubmitting.value = true;
      try {
        final deletedReview = _reviewController!.reviews.firstWhere((r) => r.id == reviewId);
        await _reviewController!.deleteReview(reviewId);
        setState(() {
          _filteredReviews = List.from(_reviewController!.reviews);
          _sortReviews();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Review deleted'),
              backgroundColor: Colors.green,
              action: SnackBarAction(
                label: 'Undo',
                textColor: Colors.white,
                onPressed: () async {
                  _isSubmitting.value = true;
                  try {
                    await _reviewController!.addReview(widget.product.id, deletedReview);
                    await _reviewController!.fetchReviews(widget.product.id);
                    setState(() {
                      _filteredReviews = List.from(_reviewController!.reviews);
                      _sortReviews();
                    });
                  } catch (e) {
                    _logger.e('Error undoing delete: $e');
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to undo delete'), backgroundColor: Colors.red),
                      );
                    }
                  } finally {
                    _isSubmitting.value = false;
                  }
                },
              ),
            ),
          );
        }
      } catch (e) {
        _logger.e('Error deleting review: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete review'), backgroundColor: Colors.red),
          );
        }
      } finally {
        _isSubmitting.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_reviewController == null) {
      return const Scaffold(
        body: Center(child: Text('Error: Review service not available')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Customer Reviews',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        if (_reviewController!.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_reviewController!.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Failed to load reviews'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _reviewController!.fetchReviews(widget.product.id),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        // Use CustomScrollView since ReviewList is likely a Sliver widget
        return CustomScrollView(
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_filteredReviews.length} ${_filteredReviews.length == 1 ? 'review' : 'reviews'}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: Colors.grey[700],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                            color: Colors.white,
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
                            itemBuilder: (context) => _sortOptions.map((String option) {
                              bool isSelected = option.toLowerCase() == _currentSort;
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
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                          color: isSelected ? Theme.of(context).primaryColor : null,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check,
                                        color: Theme.of(context).primaryColor,
                                        size: 18,
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    capitalize(_currentSort),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey[700],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Show Empty State or Review List
            _filteredReviews.isEmpty 
                ? SliverFillRemaining(
                    child: EmptyState(product: widget.product),
                  )
                : ReviewList(  // This should be a Sliver widget
                    reviews: _filteredReviews,
                    editingReviewId: _editingReviewId,
                    currentUserId: _currentUserId,
                    reviewController: _reviewController!,
                    editRating: _editRating,
                    editCommentController: _editCommentController,
                    isSubmitting: _isSubmitting,
                    onEdit: _startEditingReview,
                    onDelete: _deleteReview,
                    onSubmitEdit: _submitEditedReview,
                    onCancelEdit: _cancelEditing,
                  ),
          ],
        );
      }),
      bottomNavigationBar: ReviewBottomBar(
        currentUserId: _currentUserId,
        reviewController: _reviewController!,
        onAddReview: widget.onAddReview,
        productId: widget.product.id,
      ),
    );
  }
}