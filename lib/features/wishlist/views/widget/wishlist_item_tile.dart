import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/shared/widgets/universal_cached_image.dart';
import 'package:store_go/features/wishlist/models/wishlist_item_model.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

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
    final bool isRtl = LocalizationService.isRtl(context);

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
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: AppColors.foreground(context).withOpacity(0.1),
                      offset: const Offset(0, 11),
                      blurRadius: 24,
                      spreadRadius: 0,
                    ),
                  ]
                  : [],
          border: Border.all(color: AppColors.border(context), width: 1),
        ),
        child: Row(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          children: [
            // Product image with UniversalCachedImage
            _buildProductImage(),
            // Product details
            _buildProductDetails(isRtl),
            // Right side: Close button and quantity controls
            _buildActionsColumn(isRtl),
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
      child:
          widget.item.product.imageUrls.isNotEmpty
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

  Widget _buildProductDetails(bool isRtl) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: UIConfig.paddingMedium),
        child: Column(
          crossAxisAlignment:
              isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment:
                  isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Product name
                Text(
                  widget.item.product.name,
                  style: LocalizationService.getLocalizedTextStyle(
                    context,
                    Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ) ?? const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                ),

                // Product description
                Text(
                  widget.item.product.description ??
                      'wishlist.no_description'.translate(),
                  style: LocalizationService.getLocalizedTextStyle(
                    context,
                    Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.mutedForeground(context),
                    ) ?? TextStyle(color: AppColors.mutedForeground(context)),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                ),
              ],
            ),

            // Price
            Text(
              '\$${widget.item.product.price.toStringAsFixed(2)}',
              style: LocalizationService.getLocalizedTextStyle(
                context,
                Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600) ?? 
                const TextStyle(fontWeight: FontWeight.w600),
              ),
              textAlign: isRtl ? TextAlign.right : TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsColumn(bool isRtl) {
    return Padding(
      padding: EdgeInsets.only(
        right: isRtl ? 0 : UIConfig.paddingMedium,
        left: isRtl ? UIConfig.paddingMedium : 0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment:
            isRtl ? CrossAxisAlignment.start : CrossAxisAlignment.end,
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
                borderRadius: BorderRadius.circular(
                  UIConfig.borderRadiusCircular,
                ),
              ),
              child: Row(
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
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
                                ? AppColors.secondary(context)
                                : AppColors.input(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.remove,
                        size: 16,
                        color:
                            quantity > 1
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
