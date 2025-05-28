import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/features/promotion/controller/promotion_controller.dart';
import 'package:store_go/features/promotion/models/promotion_model.dart';
import 'package:store_go/app/core/theme/ui_config.dart';

class PromotionProductsPage extends StatefulWidget {
  final Promotion promotion;

  const PromotionProductsPage({
    super.key,
    required this.promotion,
  });

  @override
  State<PromotionProductsPage> createState() => _PromotionProductsPageState();
}

class _PromotionProductsPageState extends State<PromotionProductsPage> {
  final PromotionController promotionController = Get.find<PromotionController>();
  List<Product> promotionProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPromotionProducts();
  }

  Future<void> _loadPromotionProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch products associated with this promotion
      final products = await _getProductsForPromotion(widget.promotion);
      
      setState(() {
        promotionProducts = products;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Display an error message
      Get.snackbar(
        'Error',
        'Unable to load promotion products',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<List<Product>> _getProductsForPromotion(Promotion promotion) async {
    // This method should be implemented in your ProductRepository
    // For this example, I'll show how it might work
    
    List<Product> products = [];
    
    // If the promotion has specific product IDs
    if (promotion.applicableProductIds.isNotEmpty) {
      // Fetch each product by its ID
      for (String productId in promotion.applicableProductIds) {
        try {
          final product = await _getProductById(productId);
          if (product != null) {
            products.add(product);
          }
        } catch (e) {
          print('Error fetching product $productId: $e');
        }
      }
    }
    
    // If the promotion applies to a category
    if (promotion.applicableCategories.isNotEmpty) {
      for (String categoryId in promotion.applicableCategories) {
        try {
          final categoryProducts = await _getProductsByCategory(categoryId);
          products.addAll(categoryProducts);
        } catch (e) {
          print('Error fetching products for category $categoryId: $e');
        }
      }
    }
    
    return products;
  }

  // These methods should be in your ProductRepository
  Future<Product?> _getProductById(String productId) async {
    // Implementation to fetch a product by its ID
    // return await productRepository.getProductById(productId);
    return null; // Placeholder
  }

  Future<List<Product>> _getProductsByCategory(String categoryId) async {
    // Implementation to fetch products by category
    // return await productRepository.getProductsByCategory(categoryId);
    return []; // Placeholder
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.promotion.name),
        elevation: 0,
        leading: IconButton(
          icon: ThemeAwareSvg(
            assetPath: Directionality.of(context) == TextDirection.rtl
                ? AssetConfig.arrowRight
                : AssetConfig.arrowLeft,
            height: 24,
            width: 24,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Promotion header
          _buildPromotionHeader(),
          
          // Product list
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : promotionProducts.isEmpty
                    ? _buildEmptyState()
                    : _buildProductsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionHeader() {
    return Container(
      margin: const EdgeInsets.all(UIConfig.paddingMedium),
      padding: const EdgeInsets.all(UIConfig.paddingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusLarge),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_offer,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.promotion.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          
          if (widget.promotion.description?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Text(
              widget.promotion.description ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          
          const SizedBox(height: 12),
          
          // Promotion details
          Row(
            children: [
              _buildPromotionInfo(
                Icons.access_time,
                'Expires on ${_formatDate(widget.promotion.endDate)}',
              ),
              const SizedBox(width: 16),
              if (widget.promotion.discountPercentage > 0)
                _buildPromotionInfo(
                  Icons.percent,
                  '${widget.promotion.discountPercentage}% off',
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildProductsList() {
    return RefreshIndicator(
      onRefresh: _loadPromotionProducts,
      child: GridView.builder(
        padding: const EdgeInsets.all(UIConfig.paddingMedium),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: UIConfig.paddingMedium,
          mainAxisSpacing: UIConfig.paddingMedium,
        ),
        itemCount: promotionProducts.length,
        itemBuilder: (context, index) {
          final product = promotionProducts[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        // Navigate to product detail page
        Get.toNamed('/product-detail', arguments: product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(UIConfig.borderRadiusLarge),
                    topRight: Radius.circular(UIConfig.borderRadiusLarge),
                  ),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(UIConfig.borderRadiusLarge),
                    topRight: Radius.circular(UIConfig.borderRadiusLarge),
                  ),
                  child: product.imageUrl != null
                      ? Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                                size: 32,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 32,
                          ),
                        ),
                ),
              ),
            ),
            
            // Product details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(UIConfig.paddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const Spacer(),
                    
                    // Price with promotion
                    Row(
                      children: [
                        if (widget.promotion.discountPercentage > 0) ...[
                          Text(
                            '\$${(product.price * (1 - widget.promotion.discountPercentage / 100)).toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                        ] else ...[
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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
            Icons.discount_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No products available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This promotion currently has no products.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadPromotionProducts,
            child: const Text('Refresh'),
          ),
        ],
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

// Product model (to be adapted based on your existing model)
class Product {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final String? description;
  final String categoryId;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.description,
    required this.categoryId,
  });
}