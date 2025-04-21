import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/filter/controllers/filter_controller.dart';
import 'package:store_go/features/filter/screen/view/widgets/filter/apply_button.dart';
import 'package:store_go/features/filter/screen/view/widgets/filter/category_section.dart';
import 'package:store_go/features/filter/screen/view/widgets/filter/filter_header.dart';
import 'package:store_go/features/filter/screen/view/widgets/filter/price_range_section.dart';
import 'package:store_go/features/filter/screen/view/widgets/filter/rating_section.dart';
import 'package:store_go/features/filter/screen/view/widgets/filter/sort_section.dart';
import 'package:store_go/features/subcategory/repositories/subcategory_repository.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final FilterController filterController = Get.put(
    FilterController(
      subcategoryRepository: SubcategoryRepository(apiClient: Get.find()),
    ),
    permanent: true,
  );

  // UI state
  late RxString selectedCategoryId;
  late RxString selectedSortOption;
  late RxInt selectedRating;
  late Rx<RangeValues> priceRangeValues;

  // Dynamic price limits
  double get minPriceLimit => 0.0;
  double get maxPriceLimit => 1000.0;

  @override
  void initState() {
    super.initState();
    // Initialize UI state from controller
    selectedCategoryId = RxString(filterController.selectedCategoryId.value.isEmpty
        ? 'All'
        : filterController.selectedCategoryId.value);
    selectedSortOption = RxString(filterController.selectedSortOption.value);
    selectedRating = RxInt(filterController.selectedRating.value);
    double initialMin = filterController.minPrice.value.clamp(minPriceLimit, maxPriceLimit);
    double initialMax = filterController.maxPrice.value.clamp(minPriceLimit, maxPriceLimit);
    if (initialMax < initialMin) {
      initialMax = initialMin;
    }
    priceRangeValues = Rx<RangeValues>(RangeValues(initialMin, initialMax));

    // Fetch categories if not already loaded
    if (filterController.categories.isEmpty) {
      filterController.fetchCategories();
    }
  }

  void resetFilters() {
    selectedCategoryId.value = 'All';
    selectedSortOption.value = 'New Today';
    selectedRating.value = 0;
    priceRangeValues.value = RangeValues(minPriceLimit, maxPriceLimit);
    filterController.resetFilters();
  }

  void applyFilters() {
    filterController.minPrice.value = priceRangeValues.value.start;
    filterController.maxPrice.value = priceRangeValues.value.end;
    filterController.selectedCategoryId.value = selectedCategoryId.value == 'All' ? '' : selectedCategoryId.value;
    filterController.selectedSortOption.value = selectedSortOption.value;
    filterController.selectedRating.value = selectedRating.value;
    filterController.applyFilters();
  }

  void updatePriceRange(RangeValues values) {
    double start = values.start.clamp(minPriceLimit, maxPriceLimit);
    double end = values.end.clamp(minPriceLimit, maxPriceLimit);
    if (end < start) {
      end = start;
    }
    priceRangeValues.value = RangeValues(start, end);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          FilterHeader(
            onClear: resetFilters,
            onClose: () => Get.back(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Obx(() => filterController.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : CategorySection(
                            selectedCategoryId: selectedCategoryId.value,
                            categories: filterController.categories,
                            subcategories: filterController.subcategories,
                            onCategorySelected: (categoryId) {
                              selectedCategoryId.value = categoryId;
                              if (categoryId != 'All') {
                                filterController.selectedCategoryId.value = categoryId;
                                filterController.fetchSubcategories(categoryId);
                              } else {
                                filterController.selectedCategoryId.value = '';
                                filterController.selectedSubcategoryId.value = '';
                                filterController.subcategories.clear();
                              }
                            },
                            onSubcategorySelected: (subcategoryId) {
                              filterController.selectedSubcategoryId.value = subcategoryId;
                            },
                          )),
                    const SizedBox(height: 24),
                    Obx(() => PriceRangeSection(
                          priceRange: priceRangeValues.value,
                          onRangeChanged: updatePriceRange,
                        )),
                    const SizedBox(height: 24),
                    Obx(() => SortSection(
                          selectedTab: selectedSortOption.value,
                          onTabSelected: (option) {
                            selectedSortOption.value = option;
                          },
                        )),
                    const SizedBox(height: 24),
                    Obx(() => RatingSection(
                          selectedRating: selectedRating.value,
                          onRatingSelected: (rating) {
                            selectedRating.value = rating;
                          },
                        )),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          ApplyButton(onApply: applyFilters),
        ],
      ),
    );
  }
}