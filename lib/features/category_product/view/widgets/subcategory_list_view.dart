import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'package:store_go/features/product/controllers/product_list_controller.dart';
import 'package:store_go/features/filter/view/screen/filter_product_sheet.dart';
import 'package:store_go/features/category_product/controller/category_product_controller.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

class SubcategoryListView extends GetView<SubcategoryController> {
  final VoidCallback onApplyFilters;
  final ProductFilterController filterController =
      Get.find<ProductFilterController>();
  final ProductListController listController =
      Get.find<ProductListController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final CategoryProductController categoryProductController =
      Get.find<CategoryProductController>();

  SubcategoryListView({super.key, required this.onApplyFilters});
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => FilterBottomSheet(
            listController: listController,
            filterController: filterController,
            categoryController: categoryController,
            subcategoryController: controller,
          ),
    ).then((_) {
      // This will run after the bottom sheet is closed
      // Force a refresh of the lists to update the counter
      categoryProductController.filteredProducts.refresh();
      listController.products.refresh();
      controller.subcategoryProducts.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isRtl = LocalizationService.isRtl(context);

    return Row(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      children: [
        // Filter button - always shown immediately
        GestureDetector(
          onTap: () => _showFilterBottomSheet(context),
          child: Container(
            margin: EdgeInsetsDirectional.only(
              start: UIConfig.paddingMedium,
              top: UIConfig.paddingSmall,
            ),
            height: 36,
            padding: const EdgeInsets.symmetric(
              horizontal: UIConfig.paddingSmall,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary(context),
              borderRadius: BorderRadius.circular(
                UIConfig.borderRadiusCircular,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AssetConfig.filter,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    AppColors.primaryForeground(context),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: UIConfig.paddingSmall),
                GetBuilder<CategoryProductController>(
                  init: categoryProductController,
                  builder: (_) {
                    return Obx(() {
                      // Get the count from the appropriate controller for display
                      final count =
                          controller.currentSubcategoryId.value.isNotEmpty
                              ? controller.subcategoryProducts.length
                              : categoryProductController
                                  .filteredProducts
                                  .length;

                      // Also reactively listen to listController.products.length for updates
                      listController
                          .products
                          .length; // This is just to trigger rebuild when listController changes

                      return Text(
                        '$count',
                        key: ValueKey(
                          'filter_count_$count',
                        ), // Key helps force rebuild
                        style: LocalizationService.getLocalizedTextStyle(
                          context,
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.primaryForeground(context),
                                fontWeight: FontWeight.bold,
                              ) ??
                              TextStyle(),
                        ),
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        // Categories list - always show all subcategories
        Expanded(
          child: Container(
            height: 36,
            margin: const EdgeInsets.only(top: UIConfig.paddingSmall),
            child: Obx(() {
              // We'll create a local list of subcategories that persists during loading
              final displayedSubcategories = controller.subcategories;
              // Get the current subcategory ID for selection logic
              final selectedSubcategoryId =
                  controller.currentSubcategoryId.value;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                // Always show "All" plus however many subcategories we have
                itemCount: displayedSubcategories.length + 1,
                padding: EdgeInsetsDirectional.only(
                  start: UIConfig.paddingMedium,
                  end: UIConfig.paddingMedium,
                ),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // "All" option - always shown
                    // Use the reactive selectedSubcategoryId to determine if "All" is selected
                    return _buildSubcategoryPill(
                      context: context,
                      name: 'category.all'.translate(),
                      isSelected: selectedSubcategoryId.isEmpty,
                      onTap: () {
                        // Reset subcategory selection without clearing subcategories list
                        controller.currentSubcategoryId.value = '';
                        controller.subcategoryProducts.clear();
                        controller.searchQuery.value = '';
                        controller.isSearchActive.value = false;

                        // Restore original category products via the CategoryProductController
                        categoryProductController.restoreAllCategoryProducts();

                        // Apply filters after restoring original products
                        onApplyFilters();
                      },
                    );
                  }

                  // For items other than "All", show from our persisted list
                  final subcategory = displayedSubcategories[index - 1];
                  return _buildSubcategoryPill(
                    context: context,
                    name: subcategory.name,
                    isSelected: subcategory.id == selectedSubcategoryId,
                    onTap: () {
                      controller.selectSubcategory(subcategory);
                      onApplyFilters();
                    },
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildSubcategoryPill({
    required BuildContext context,
    required String name,
    required bool isSelected,
    required VoidCallback onTap,
  }) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsetsDirectional.only(end: UIConfig.paddingSmall),
        padding: const EdgeInsets.symmetric(
          horizontal: UIConfig.paddingMedium,
          vertical: UIConfig.paddingSmall,
        ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary(context)
                  : AppColors.input(context),
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular),
        ),
        child: Text(
          name,
          style: LocalizationService.getLocalizedTextStyle(
            context,
            Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      isSelected
                          ? AppColors.primaryForeground(context)
                          : AppColors.foreground(context),
                  fontWeight: FontWeight.w500,
                ) ??
                TextStyle(),
          ),
        ),
      ),
    );
  }
}
