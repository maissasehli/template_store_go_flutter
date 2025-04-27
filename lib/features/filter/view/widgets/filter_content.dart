import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'package:store_go/features/filter/view/widgets/category_filter.dart';
import 'package:store_go/features/filter/view/widgets/price_range_slider.dart';
import 'package:store_go/features/filter/view/widgets/rating_filter.dart';
import 'package:store_go/features/filter/view/widgets/section_title.dart';
import 'package:store_go/features/filter/view/widgets/sort_option.dart';
import 'package:store_go/features/filter/view/widgets/subcategory_filter.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';

class FilterContent extends StatelessWidget {
  final ProductFilterController filterController;
  final CategoryController categoryController;
  final SubcategoryController subcategoryController;

  const FilterContent({
    super.key,
    required this.filterController,
    required this.categoryController,
    required this.subcategoryController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category section
          const SectionTitle(title: 'Catégorie'),
          const SizedBox(height: 12),
          CategoryFilter(
            filterController: filterController,
            categoryController: categoryController,
            subcategoryController: subcategoryController,
          ),

          const SizedBox(height: 24),

          // Subcategories - conditionally display
          Obx(() {
            if (filterController.selectedCategory.value != 'All') {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(title: 'Subcategories'),
                  const SizedBox(height: 12),
                  SubcategoryFilter(
                    filterController: filterController,
                    subcategoryController: subcategoryController,
                  ),
                  const SizedBox(height: 24),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          }),

          // Price range section
          const SectionTitle(title: 'Price range'),
          const SizedBox(height: 12),
          PriceRangeSlider(filterController: filterController),

          const SizedBox(height: 24),

          // Sort by section
          const SectionTitle(title: 'Sort by'),
          const SizedBox(height: 12),
          SortOptions(filterController: filterController),

          const SizedBox(height: 24),

          // Rating section
          const SectionTitle(title: 'Rating'),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: RatingFilter(filterController: filterController),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
