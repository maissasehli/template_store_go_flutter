import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/shared/widgets/universal_cached_image.dart';
import 'package:store_go/features/wishlist/models/wishlist_item_model.dart';

class WishlistItemTile extends StatefulWidget {
  final WishlistItemModel item;
  final Function(WishlistItemModel) onRemove;
  final Function(WishlistItemModel, int) onUpdateQuantity;

  const WishlistItemTile({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onUpdateQuantity,
  });

  @override
  State<WishlistItemTile> createState() => _WishlistItemTileState();
}

class _WishlistItemTileState extends State<WishlistItemTile> {
  // Local UI state for quantity and selection
  bool isSelected = false;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        width: 325,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          // Shadow appears only when the item is selected
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 11),
                      blurRadius: 24,
                      spreadRadius: 0,
                    ),
                  ]
                  : [],
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Row(
          children: [
            // Product image with UniversalCachedImage
            _buildProductImage(),
            // Product details
            _buildProductDetails(),
            // Right side: Close button and quantity controls
            _buildActionsColumn(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 70,
      height: 70,
      margin: const EdgeInsets.all(15),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child:
          widget.item.product.imageUrls.isNotEmpty
              ? UniversalCachedImage(
                imagePath: widget.item.product.imageUrls[0],
                source: ImageSource.network,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(8),
                errorWidget: _buildFallbackImage(),
              )
              : _buildFallbackImage(),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.muted(context),
      ),
      child: const Center(
        child: Icon(Icons.image_outlined, color: Colors.grey, size: 28),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name
                Text(
                  widget.item.product.name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                // Product description
                Text(
                  widget.item.product.description ?? 'No description',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            // Price
            Text(
              '\$${widget.item.product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsColumn() {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Close button
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: GestureDetector(
              onTap: () => widget.onRemove(widget.item),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.close, size: 16, color: Colors.grey),
                ),
              ),
            ),
          ),

          // Quantity controls
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(
              width: 90,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Minus button
                  InkWell(
                    onTap: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                        });
                        widget.onUpdateQuantity(widget.item, -1);
                      }
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color:
                            quantity > 1
                                ? Colors.grey.shade300
                                : Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.remove,
                        size: 16,
                        color: quantity > 1 ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),

                  // Quantity
                  Text(
                    quantity.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // Plus button
                  InkWell(
                    onTap: () {
                      setState(() {
                        quantity++;
                      });
                      widget.onUpdateQuantity(widget.item, 1);
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
