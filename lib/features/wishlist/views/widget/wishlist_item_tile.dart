import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
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
        margin: const EdgeInsets.only(bottom: UIConfig.paddingMedium),
        width: 325,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.background(context),
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
          // Shadow appears only when the item is selected
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.foreground(context).withOpacity(0.1),
                    offset: const Offset(0, 11),
                    blurRadius: 24,
                    spreadRadius: 0,
                  ),
                ]
              : [],
          border: Border.all(
            color: AppColors.border(context),
            width: 1,
          ),
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
      margin: const EdgeInsets.all(UIConfig.paddingMedium),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusSmall),
      ),
      child: widget.item.product.imageUrls.isNotEmpty
          ? UniversalCachedImage(
              imagePath: widget.item.product.imageUrls[0],
              source: ImageSource.network,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(UIConfig.borderRadiusSmall),
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
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusSmall),
        color: AppColors.muted(context),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: AppColors.mutedForeground(context),
          size: 28,
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: UIConfig.paddingMedium),
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
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                // Product description
                Text(
                  widget.item.product.description ?? 'No description',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground(context),
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            // Price
            Text(
              '\$${widget.item.product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsColumn() {
    return Padding(
      padding: const EdgeInsets.only(right: UIConfig.paddingMedium),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Close button
          Padding(
            padding: const EdgeInsets.only(top: UIConfig.paddingMedium),
            child: GestureDetector(
              onTap: () => widget.onRemove(widget.item),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.input(context),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: AppColors.mutedForeground(context),
                  ),
                ),
              ),
            ),
          ),

          // Quantity controls
          Padding(
            padding: const EdgeInsets.only(bottom: UIConfig.paddingMedium),
            child: Container(
              width: 90,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.input(context),
                borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular),
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
                        color: quantity > 1
                            ? AppColors.secondary(context)
                            : AppColors.input(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.remove,
                        size: 16,
                        color: quantity > 1
                            ? AppColors.foreground(context)
                            : AppColors.mutedForeground(context),
                      ),
                    ),
                  ),

                  // Quantity
                  Text(
                    quantity.toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                        color: AppColors.secondary(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        size: 16,
                        color: AppColors.foreground(context),
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