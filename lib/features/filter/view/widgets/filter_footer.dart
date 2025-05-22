import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/product/controllers/product_list_controller.dart';
import 'package:store_go/features/category_product/controller/category_product_controller.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';
import 'dart:developer' as developer; 
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';

class FilterFooter extends StatelessWidget {
  final ProductListController listController;

  const FilterFooter({super.key, required this.listController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Apply button
        Padding(
          padding: const EdgeInsets.all(UIConfig.paddingMedium),
          child: ElevatedButton(
            onPressed: () async {
              developer.log(
                'Apply Now button pressed. Applying filters...',
                name: 'FilterFooter.onPressed',
              );

              try {
                // First apply filters on the list controller
                await listController.applyFilters();

                // Then make sure we update the CategoryProductController
                if (Get.isRegistered<CategoryProductController>()) {
                  final filterController = Get.find<ProductFilterController>();
                  final categoryProductController =
                      Get.find<CategoryProductController>();
                  final subcategoryController =
                      Get.find<SubcategoryController>();

                  developer.log(
                    'Applying filters to CategoryProductController - Price range: min=${filterController.minPrice.value}, max=${filterController.maxPrice.value}',
                    name: 'FilterFooter.onPressed',
                  );

                  // Apply filters to category product controller
                  await categoryProductController.applyFilters(
                    categoryId:
                        filterController.selectedCategory.value ==
                                'filter.all'.translate()
                            ? categoryProductController
                                    .currentCategory
                                    .value
                                    ?.id ??
                                ''
                            : filterController.selectedCategory.value,
                    subcategoryId: filterController.selectedSubcategoryId.value,
                    minPrice: filterController.minPrice.value,
                    maxPrice: filterController.maxPrice.value,
                    sortOption: filterController.selectedSortOption.value,
                    minRating: filterController.minRating.value.toDouble(),
                  );

                  // Force immediate UI updates for all controllers
                  listController.products.refresh();
                  categoryProductController.filteredProducts.refresh();
                  categoryProductController.categoryProducts.refresh();

                  // Wait for UI to process updates
                  await Future.delayed(const Duration(milliseconds: 50));

                  // Make sure subcategory controller is updated if needed
                  if (subcategoryController
                      .currentSubcategoryId
                      .value
                      .isNotEmpty) {
                    subcategoryController.subcategoryProducts.refresh();
                  }

                  // Force complete UI refresh as a fallback
                  Get.forceAppUpdate();
                  categoryProductController.update();

                  developer.log(
                    'After filter apply - Products count: ${categoryProductController.filteredProducts.length}',
                    name: 'FilterFooter.onPressed',
                  );
                }
              } catch (e) {
                developer.log(
                  'Error applying filters: $e',
                  name: 'FilterFooter.onPressed',
                  error: e,
                );
              }

              // Close the bottom sheet after filters are applied
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              foregroundColor: AppColors.primaryForeground(context),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  UIConfig.borderRadiusXLarge,
                ),
              ),
            ),
            child: Text(
              'filter.apply_now'.translate(),
              style: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: UIConfig.fontSizeMedium,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        // Bottom indicator
        const SizedBox(height: 4),
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border(context),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
