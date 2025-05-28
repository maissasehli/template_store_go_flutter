import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/promotion/models/promotion_model.dart';
import 'package:store_go/app/core/theme/ui_config.dart';

class PromotionBanner extends StatelessWidget {
  final List<Promotion> promotions;
  final Function(Promotion)? onPromotionTap;
  final double height;
  final EdgeInsets margin;

  const PromotionBanner({
    super.key,
    required this.promotions,
    this.onPromotionTap,
    this.height = 180,
    this.margin = const EdgeInsets.symmetric(
      horizontal: UIConfig.paddingMedium,
      vertical: UIConfig.paddingSmall,
    ),
  });

  @override
  Widget build(BuildContext context) {
    if (promotions.isEmpty) {
      return const SizedBox.shrink();
    }

    if (promotions.length == 1) {
      return _buildSinglePromotion(context, promotions.first);
    }

    return _buildPromotionCarousel(context);
  }

  Widget _buildSinglePromotion(BuildContext context, Promotion promotion) {
    return Container(
      margin: margin,
      height: height,
      child: _buildPromotionCard(context, promotion),
    );
  }

  Widget _buildPromotionCarousel(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      child: PageView.builder(
        itemCount: promotions.length,
        controller: PageController(viewportFraction: 0.9),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: _buildPromotionCard(context, promotions[index]),
          );
        },
      ),
    );
  }

  Widget _buildPromotionCard(BuildContext context, Promotion promotion) {
    return GestureDetector(
      onTap: () {
        // Call the custom callback if it exists
        if (onPromotionTap != null) {
          onPromotionTap!(promotion);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusLarge),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              _buildPromotionImage(promotion.promotionImage!),
              
              // Gradient overlay for better text readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.6),
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
              
              // Promotion details overlay
              _buildPromotionOverlay(context, promotion),
              
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionImage(String imageUrl) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              'Image not available',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionOverlay(BuildContext context, Promotion promotion) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(UIConfig.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            
            
            // Discount info
            if (promotion.discountPercentage > 0) ...[
              const SizedBox(height: 4),
              Text(
                '${promotion.discountPercentage}% off',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            
            // Expiry date
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Expires: ${_formatDate(promotion.endDate)}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference < 7) {
      return 'in $difference days';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

// Skeleton loader for promotion banner
class PromotionBannerSkeleton extends StatelessWidget {
  final double height;
  final EdgeInsets margin;

  const PromotionBannerSkeleton({
    super.key,
    this.height = 180,
    this.margin = const EdgeInsets.symmetric(
      horizontal: UIConfig.paddingMedium,
      vertical: UIConfig.paddingSmall,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusLarge),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}