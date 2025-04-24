import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Results and header
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    listController.clearFilters();
                    subcategoryController.resetState();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Clear',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Text(
                  'Filter by',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.black, size: 24),
                ),
              ],
            ),
          ),
          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Obx(
              () => Text(
                '${listController.products.length} Results Found',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Main content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Catégorie',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCategoriesFilter(context),

                  const SizedBox(height: 24),

                  // Subcategories - conditionally display
                  if (filterController.selectedCategory.value != 'All') ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Subcategories',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSubcategoriesFilter(context),
                    const SizedBox(height: 24),
                  ],

                  // Price range section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Price range',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPriceRangeSlider(context),

                  const SizedBox(height: 24),

                  // Sort by section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Sort by',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSortOptions(context),

                  const SizedBox(height: 24),

                  // Rating section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Rating',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildRatingFilter(context),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Apply button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                listController.applyFilters();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Apply Now',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Bottom indicator
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildCategoriesFilter(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(
        () => Row(
          children: [
            // "All" option always first
            _buildCategoryChip(
              context: context,
              label: 'All',
              categoryId: 'All',
              isSelected: filterController.selectedCategory.value == 'All',
              onSelected: (selected) {
                if (selected) {
                  filterController.selectedCategory.value = 'All';
                  filterController.selectedSubcategoryId.value = '';
                  subcategoryController.resetState();
                }
              },
            ),
            const SizedBox(width: 8),
            // Dynamic categories from the controller
            ...categoryController.categories.map((category) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _buildCategoryChip(
                  context: context,
                  label: category.name,
                  categoryId: category.id,
                  isSelected:
                      filterController.selectedCategory.value == category.id,
                  onSelected: (selected) {
                    if (selected) {
                      filterController.selectedCategory.value = category.id;
                      filterController.selectedSubcategoryId.value = '';
                      subcategoryController.setCategory(category.id);
                    }
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required BuildContext context,
    required String label,
    required String categoryId,
    required bool isSelected,
    required Function(bool) onSelected,
  }) {
    return GestureDetector(
      onTap: () => onSelected(true),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSubcategoriesFilter(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(
        () => Row(
          children:
              subcategoryController.subcategories.map((subcategory) {
                final isSelected =
                    filterController.selectedSubcategoryId.value ==
                    subcategory.id;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      if (isSelected) {
                        filterController.selectedSubcategoryId.value = '';
                        subcategoryController.resetState();
                      } else {
                        filterController.selectedSubcategoryId.value =
                            subcategory.id;
                        subcategoryController.selectSubcategory(subcategory);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        subcategory.name,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildPriceRangeSlider(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Obx(
            () => SliderTheme(
              data: SliderThemeData(
                trackHeight: 2,
                activeTrackColor: Colors.black,
                inactiveTrackColor: Colors.grey[300],
                thumbColor: Colors.white,
                thumbShape: _CustomThumbShape(),
                overlayColor: Colors.black.withOpacity(0.1),
                rangeThumbShape: const RoundRangeSliderThumbShape(
                  enabledThumbRadius: 12,
                  elevation: 4,
                ),
              ),
              child: RangeSlider(
                values: RangeValues(
                  filterController.minPrice.value,
                  filterController.maxPrice.value,
                ),
                min: 0,
                max: 1000,
                divisions: 20,
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  '${filterController.minPrice.value.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              const Text(
                'Tnd',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Obx(
                () => Text(
                  '${filterController.maxPrice.value.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSortOptions(BuildContext context) {
    final sortOptions = ['New Today', 'Top Sellers', 'New collection'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(
        () => Row(
          children:
              sortOptions.map((option) {
                final isSelected =
                    filterController.selectedSortOption.value == option;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      filterController.selectedSortOption.value = option;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildRatingFilter(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 5 stars
          Row(
            children: [
              GestureDetector(
                onTap: () => filterController.minRating.value = 5,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        filterController.minRating.value == 5
                            ? Colors.black
                            : Colors.transparent,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child:
                      filterController.minRating.value == 5
                          ? const Center(
                            child: Icon(
                              Icons.circle,
                              color: Colors.white,
                              size: 8,
                            ),
                          )
                          : null,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: List.generate(
                  5,
                  (_) => const Icon(Icons.star, color: Colors.amber, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 4 stars
          Row(
            children: [
              GestureDetector(
                onTap: () => filterController.minRating.value = 4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        filterController.minRating.value == 4
                            ? Colors.black
                            : Colors.transparent,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child:
                      filterController.minRating.value == 4
                          ? const Center(
                            child: Icon(
                              Icons.circle,
                              color: Colors.white,
                              size: 8,
                            ),
                          )
                          : null,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  ...List.generate(
                    4,
                    (_) =>
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                  ),
                  const Icon(Icons.star_outline, color: Colors.grey, size: 16),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3 stars
          Row(
            children: [
              GestureDetector(
                onTap: () => filterController.minRating.value = 3,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        filterController.minRating.value == 3
                            ? Colors.black
                            : Colors.transparent,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child:
                      filterController.minRating.value == 3
                          ? const Center(
                            child: Icon(
                              Icons.circle,
                              color: Colors.white,
                              size: 8,
                            ),
                          )
                          : null,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  ...List.generate(
                    3,
                    (_) =>
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                  ),
                  ...List.generate(
                    2,
                    (_) => const Icon(
                      Icons.star_outline,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2 stars
          Row(
            children: [
              GestureDetector(
                onTap: () => filterController.minRating.value = 2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        filterController.minRating.value == 2
                            ? Colors.black
                            : Colors.transparent,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child:
                      filterController.minRating.value == 2
                          ? const Center(
                            child: Icon(
                              Icons.circle,
                              color: Colors.white,
                              size: 8,
                            ),
                          )
                          : null,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  ...List.generate(
                    2,
                    (_) =>
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                  ),
                  ...List.generate(
                    3,
                    (_) => const Icon(
                      Icons.star_outline,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 1 star
          Row(
            children: [
              GestureDetector(
                onTap: () => filterController.minRating.value = 1,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        filterController.minRating.value == 1
                            ? Colors.black
                            : Colors.transparent,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child:
                      filterController.minRating.value == 1
                          ? const Center(
                            child: Icon(
                              Icons.circle,
                              color: Colors.white,
                              size: 8,
                            ),
                          )
                          : null,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  ...List.generate(
                    4,
                    (_) => const Icon(
                      Icons.star_outline,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(24, 24);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // Draw outer white circle
    final Paint outerPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 12, outerPaint);

    // Draw border
    final Paint borderPaint =
        Paint()
          ..color = Colors.grey[300]!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    canvas.drawCircle(center, 12, borderPaint);
  }
}
