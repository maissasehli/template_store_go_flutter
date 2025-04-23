import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/product/controllers/product_list_controller.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';

class FilterBottomSheet extends StatelessWidget {
  final ProductListController listController;
  final ProductFilterController filterController;
  final CategoryController categoryController;
  final SubcategoryController subcategoryController;

  const FilterBottomSheet({
    super.key,
    required this.listController,
    required this.filterController,
    required this.categoryController,
    required this.subcategoryController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: AppColors.background(context),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    listController.clearFilters();
                    subcategoryController.resetState();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Clear',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary(context),
                    ),
                  ),
                ),
                Text(
                  'Filter By',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground(context),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: AppColors.foreground(context),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Obx(
              () => Text(
                '${listController.products.length} Results Found',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.mutedForeground(context),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Catégorie'),
                  const SizedBox(height: 8),
                  _buildCategoriesFilter(context),
                  const SizedBox(height: 16),
                  if (filterController.selectedCategory.value != 'All')
                    ...[
                      _buildSectionTitle(context, 'Subcategories'),
                      const SizedBox(height: 8),
                      _buildSubcategoriesFilter(context),
                      const SizedBox(height: 16),
                    ],
                  _buildSectionTitle(context, 'Price range'),
                  const SizedBox(height: 8),
                  _buildPriceRangeSlider(context),
                  const SizedBox(height: 16),
                  _buildSectionTitle(context, 'Sort by'),
                  const SizedBox(height: 8),
                  _buildSortOptions(context),
                  const SizedBox(height: 16),
                  _buildSectionTitle(context, 'Rating'),
                  const SizedBox(height: 8),
                  _buildRatingFilter(context),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      listController.clearFilters();
                      subcategoryController.resetState();
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: AppColors.primary(context)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        color: AppColors.primary(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      listController.applyFilters();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary(context),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Apply Now',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.foreground(context),
      ),
    );
  }

  Widget _buildCategoriesFilter(BuildContext context) {
    return Obx(
      () => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ChoiceChip(
            label: const Text('All'),
            selected: filterController.selectedCategory.value == 'All',
            onSelected: (selected) {
              if (selected) {
                filterController.selectedCategory.value = 'All';
                filterController.selectedSubcategoryId.value = '';
                subcategoryController.resetState();
              }
            },
            labelStyle: TextStyle(
              color: filterController.selectedCategory.value == 'All'
                  ? AppColors.primary(context)
                  : AppColors.foreground(context),
              fontWeight: filterController.selectedCategory.value == 'All'
                  ? FontWeight.w500
                  : FontWeight.normal,
            ),
          ),
          ...categoryController.categories.map((category) {
            final isSelected = filterController.selectedCategory.value == category.id;
            return ChoiceChip(
              label: Text(category.name),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  filterController.selectedCategory.value = category.id;
                  filterController.selectedSubcategoryId.value = '';
                  subcategoryController.setCategory(category.id);
                }
              },
              labelStyle: TextStyle(
                color: isSelected
                    ? AppColors.primary(context)
                    : AppColors.foreground(context),
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSubcategoriesFilter(BuildContext context) {
    return Obx(
      () => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: subcategoryController.subcategories.map((subcategory) {
          final isSelected = filterController.selectedSubcategoryId.value == subcategory.id;
          return ChoiceChip(
            label: Text(subcategory.name),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                filterController.selectedSubcategoryId.value = subcategory.id;
                subcategoryController.selectSubcategory(subcategory);
              } else {
                filterController.selectedSubcategoryId.value = '';
                subcategoryController.resetState();
              }
            },
            labelStyle: TextStyle(
              color: isSelected
                  ? AppColors.primary(context)
                  : AppColors.foreground(context),
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPriceRangeSlider(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => RangeSlider(
            values: RangeValues(
              filterController.minPrice.value,
              filterController.maxPrice.value,
            ),
            min: 0,
            max: 1000,
            divisions: 20,
            activeColor: AppColors.primary(context),
            inactiveColor: Colors.grey.shade300,
            labels: RangeLabels(
              '${filterController.minPrice.value.toStringAsFixed(0)} TND',
              '${filterController.maxPrice.value.toStringAsFixed(0)} TND',
            ),
            onChanged: (RangeValues values) {
              filterController.minPrice.value = values.start;
              filterController.maxPrice.value = values.end;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text('${filterController.minPrice.value.toStringAsFixed(0)} TND'),
              ),
              Obx(
                () => Text('${filterController.maxPrice.value.toStringAsFixed(0)} TND'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSortOptions(BuildContext context) {
    return Obx(
      () => Column(
        children: filterController.sortOptions.map((option) {
          final isSelected = filterController.selectedSortOption.value == option;
          return RadioListTile<String>(
            title: Text(
              option,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                color: AppColors.foreground(context),
              ),
            ),
            value: option,
            groupValue: filterController.selectedSortOption.value,
            onChanged: (value) {
              if (value != null) {
                filterController.selectedSortOption.value = value;
              }
            },
            activeColor: AppColors.primary(context),
            contentPadding: EdgeInsets.zero,
            dense: true,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRatingFilter(BuildContext context) {
    return Obx(
      () => Row(
        children: List.generate(5, (index) {
          final rating = index + 1;
          return GestureDetector(
            onTap: () => filterController.minRating.value = rating,
            child: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Icon(
                rating <= filterController.minRating.value
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                color: rating <= filterController.minRating.value
                    ? Colors.amber
                    : Colors.grey.shade400,
                size: 28,
              ),
            ),
          );
        }),
      ),
    );
  }
}