import 'package:flutter/material.dart';
import 'package:store_go/features/promotion/models/promotion_model.dart';
import 'package:store_go/app/core/theme/ui_config.dart';

class ProductPromotionCard extends StatelessWidget {
  final List<Promotion> promotions;
  final Function(Promotion)? onPromotionTap;
  final EdgeInsets margin;
  final bool showExpiry;

  const ProductPromotionCard({
    super.key,
    required this.promotions,
    this.onPromotionTap,
    this.margin = const EdgeInsets.symmetric(
      horizontal: UIConfig.paddingMedium,
      vertical: UIConfig.paddingSmall,
    ),
    this.showExpiry = true,
  });

  @override
  Widget build(BuildContext context) {
    if (promotions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced section header
          _buildSectionHeader(context),
          const SizedBox(height: 16),
          
          // Promotions list with enhanced cards
          ...promotions.asMap().entries.map((entry) {
            final index = entry.key;
            final promotion = entry.value;
            return AnimatedContainer(
              duration: Duration(milliseconds: 300 + (index * 100)),
              curve: Curves.easeOutCubic,
              child: _buildEnhancedPromotionItem(context, promotion, index),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Animated icon with glow effect
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.local_offer_rounded,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          
          // Title with gradient text effect
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                  ).createShader(bounds),
                  child: Text(
                    'Special Offers',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  'Exclusive deals just for you',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Enhanced counter badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              '${promotions.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedPromotionItem(BuildContext context, Promotion promotion, int index) {
    final promotionColor = _getPromotionColor(promotion);
    
    return Container(
      margin: EdgeInsets.only(
        bottom: UIConfig.paddingMedium,
        top: index == 0 ? 0 : 4,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            promotionColor.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: promotionColor.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: promotionColor.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => onPromotionTap?.call(promotion),
          borderRadius: BorderRadius.circular(20),
          splashColor: promotionColor.withOpacity(0.1),
          highlightColor: promotionColor.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced promotion header
                _buildPromotionHeader(context, promotion, promotionColor),
                
                // Description with better typography
                if (promotion.description != null && promotion.description!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildPromotionDescription(context, promotion),
                ],
                
                // Enhanced coupon code section
                if (promotion.couponCode != null && promotion.couponCode!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildCouponCode(context, promotion, promotionColor),
                ],
                
                // Enhanced footer with icons and better layout
                const SizedBox(height: 16),
                _buildPromotionFooter(context, promotion, promotionColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionHeader(BuildContext context, Promotion promotion, Color promotionColor) {
    return Row(
      children: [
        // Enhanced discount badge with animation potential
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                promotionColor,
                promotionColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: promotionColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getPromotionIcon(promotion),
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                promotion.getDiscountDisplay(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        
        // Enhanced promotion name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                promotion.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (_getPromotionTypeLabel(promotion).isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  _getPromotionTypeLabel(promotion),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: promotionColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // Enhanced arrow with subtle animation
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: promotionColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: promotionColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPromotionDescription(BuildContext context, Promotion promotion) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Text(
        promotion.description!,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey[700],
          height: 1.4,
          fontSize: 13,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildCouponCode(BuildContext context, Promotion promotion, Color promotionColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            promotionColor.withOpacity(0.05),
            promotionColor.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: promotionColor.withOpacity(0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: promotionColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.confirmation_number_rounded,
              size: 20,
              color: promotionColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coupon Code',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  promotion.couponCode!,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: promotionColor,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: promotionColor.withOpacity(0.3)),
            ),
            child: Icon(
              Icons.content_copy_rounded,
              size: 16,
              color: promotionColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionFooter(BuildContext context, Promotion promotion, Color promotionColor) {
    return Row(
      children: [
        // Minimum purchase with enhanced design
        if (promotion.minimumPurchase > 0) ...[
          _buildInfoChip(
            context,
            Icons.shopping_cart_rounded,
            'Min: \$${promotion.minimumPurchase.toStringAsFixed(2)}',
            promotionColor,
          ),
          const SizedBox(width: 12),
        ],
        
        // Expiry date with enhanced design
        if (showExpiry) ...[
          _buildInfoChip(
            context,
            Icons.schedule_rounded,
            'Expires: ${_formatDate(promotion.endDate)}',
            _getExpiryColor(promotion.endDate),
          ),
        ],
        
        const Spacer(),
        
        // Status indicator
        _buildStatusIndicator(promotion),
      ],
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(Promotion promotion) {
    final isExpiringSoon = promotion.endDate.difference(DateTime.now()).inDays <= 3;
    final color = isExpiringSoon ? Colors.orange : Colors.green;
    final text = isExpiringSoon ? 'Ending Soon' : 'Active';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getPromotionColor(Promotion promotion) {
    switch (promotion.discountType) {
      case DiscountType.percentage:
        return const Color(0xFFFF6B35); // Orange moderne
      case DiscountType.fixedAmount:
        return const Color(0xFF00C896); // Vert moderne
      case DiscountType.freeShipping:
        return const Color(0xFF4A90E2); // Bleu moderne
      case DiscountType.buyXGetY:
        return const Color(0xFF8B5CF6); // Violet moderne
      default:
        return const Color(0xFFFF6B35);
    }
  }

  Color _getExpiryColor(DateTime endDate) {
    final difference = endDate.difference(DateTime.now()).inDays;
    if (difference <= 1) return Colors.red;
    if (difference <= 3) return Colors.orange;
    return Colors.grey[600]!;
  }

  IconData _getPromotionIcon(Promotion promotion) {
    switch (promotion.discountType) {
      case DiscountType.percentage:
        return Icons.percent_rounded;
      case DiscountType.fixedAmount:
        return Icons.attach_money_rounded;
      case DiscountType.freeShipping:
        return Icons.local_shipping_rounded;
      case DiscountType.buyXGetY:
        return Icons.card_giftcard_rounded;
      default:
        return Icons.local_offer_rounded;
    }
  }

  String _getPromotionTypeLabel(Promotion promotion) {
    switch (promotion.discountType) {
      case DiscountType.percentage:
        return 'PERCENTAGE OFF';
      case DiscountType.fixedAmount:
        return 'FIXED DISCOUNT';
      case DiscountType.freeShipping:
        return 'FREE SHIPPING';
      case DiscountType.buyXGetY:
        return 'BUY & GET';
      default:
        return '';
    }
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

// Enhanced skeleton loader
class ProductPromotionCardSkeleton extends StatefulWidget {
  final EdgeInsets margin;

  const ProductPromotionCardSkeleton({
    super.key,
    this.margin = const EdgeInsets.symmetric(
      horizontal: UIConfig.paddingMedium,
      vertical: UIConfig.paddingSmall,
    ),
  });

  @override
  State<ProductPromotionCardSkeleton> createState() => _ProductPromotionCardSkeletonState();
}

class _ProductPromotionCardSkeletonState extends State<ProductPromotionCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced header skeleton
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 120,
                              height: 18,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 180,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Enhanced promotion item skeleton
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 100,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 120,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}