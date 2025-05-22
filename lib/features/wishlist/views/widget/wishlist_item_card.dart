import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/shared/widgets/universal_cached_image.dart';
import 'package:store_go/features/wishlist/models/wishlist_item_model.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

class WishlistItemCard extends StatelessWidget {
  final WishlistItemModel item;
  final Function(WishlistItemModel) onRemove;
  final Function(WishlistItemModel) onTap;

  const WishlistItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRtl = LocalizationService.isRtl(context);

    return Dismissible(
      key: Key(item.id),
      direction:
          isRtl ? DismissDirection.startToEnd : DismissDirection.endToStart,
      onDismissed: (direction) {
        onRemove(item);
      },
      background:
          isRtl
              ? Container(
                margin: const EdgeInsets.only(bottom: UIConfig.paddingMedium),
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.destructive(context),
                  borderRadius: BorderRadius.circular(
                    UIConfig.borderRadiusLarge,
                  ),
                ),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: UIConfig.paddingMedium),
                child: SvgPicture.asset(
                  AssetConfig.delete,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    AppColors.destructiveForeground(context),
                    BlendMode.srcIn,
                  ),
                ),
              )
              : Container(
                margin: const EdgeInsets.only(bottom: UIConfig.paddingMedium),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    UIConfig.borderRadiusLarge,
                  ),
                ),
              ),
      secondaryBackground:
          isRtl
              ? Container(
                margin: const EdgeInsets.only(bottom: UIConfig.paddingMedium),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    UIConfig.borderRadiusLarge,
                  ),
                ),
              )
              : Container(
                margin: const EdgeInsets.only(bottom: UIConfig.paddingMedium),
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.destructive(context),
                  borderRadius: BorderRadius.circular(
                    UIConfig.borderRadiusLarge,
                  ),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: UIConfig.paddingMedium),
                child: SvgPicture.asset(
                  AssetConfig.delete,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    AppColors.destructiveForeground(context),
                    BlendMode.srcIn,
                  ),
                ),
              ),
      child: GestureDetector(
        onTap: () => onTap(item),
        child: Container(
          margin: const EdgeInsets.only(bottom: UIConfig.paddingMedium),
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.background(context),
            borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
            border: Border.all(color: AppColors.border(context), width: 1),
          ),
          child: Row(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            children: [
              // Product image
              _buildProductImage(context),

              // Product details (name and price)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(UIConfig.paddingMedium),
                  child: Column(
                    crossAxisAlignment:
                        isRtl
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Product name
                      Text(
                        item.product.name,
                        style: LocalizationService.getLocalizedTextStyle(
                          context,
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ) ??
                              const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: isRtl ? TextAlign.right : TextAlign.left,
                      ),

                      const Spacer(),

                      // Price
                      Text(
                        '\$${item.product.price.toStringAsFixed(2)}',
                        style: LocalizationService.getLocalizedTextStyle(
                          context,
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ) ??
                              const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        textAlign: isRtl ? TextAlign.right : TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusSmall),
      ),
      child:
          item.product.imageUrls.isNotEmpty
              ? UniversalCachedImage(
                imagePath: item.product.imageUrls[0],
                source: ImageSource.network,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(UIConfig.borderRadiusSmall),
                errorWidget: _buildFallbackImage(context),
              )
              : _buildFallbackImage(context),
    );
  }

  Widget _buildFallbackImage(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
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
}
