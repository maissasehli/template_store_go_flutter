import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/filter/controllers/filter_controller.dart';
import 'package:store_go/features/subcategory/repositories/subcategory_repository.dart';

class FilterPage extends StatelessWidget {
  FilterPage({super.key});

  final FilterController filterController = Get.put(
    FilterController(
      subcategoryRepository: SubcategoryRepository(apiClient: Get.find()),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
                const Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    filterController.minPrice.value = 0.0;
                    filterController.maxPrice.value = 1000.0;
                    filterController.selectedCategoryId.value = filterController.categories.isNotEmpty ? filterController.categories.first.id : '';
                    filterController.selectedSubcategoryId.value = '';
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      if (filterController.categories.isEmpty) {
                        return const Text('No categories available');
                      }
                      return Wrap(
                        spacing: 8,
                        children: filterController.categories.map((category) {
                          return ChoiceChip(
                            label: Text(category.name),
                            selected: filterController.selectedCategoryId.value == category.id,
                            onSelected: (selected) {
                              if (selected) {
                                filterController.selectedCategoryId.value = category.id;
                                filterController.fetchSubcategories(category.id);
                              }
                            },
                          );
                        }).toList(),
                      );
                    }),
                    const SizedBox(height: 16),
                    const Text(
                      'Subcategory',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      if (filterController.subcategories.isEmpty) {
                        return const Text('No subcategories available');
                      }
                      return Wrap(
                        spacing: 8,
                        children: filterController.subcategories.map((subcategory) {
                          return ChoiceChip(
                            label: Text(subcategory.name),
                            selected: filterController.selectedSubcategoryId.value == subcategory.id,
                            onSelected: (selected) {
                              if (selected) {
                                filterController.selectedSubcategoryId.value = subcategory.id;
                              } else {
                                filterController.selectedSubcategoryId.value = '';
                              }
                            },
                          );
                        }).toList(),
                      );
                    }),
                    const SizedBox(height: 16),
                    const Text(
                      'Price Range',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => RangeSlider(
                          min: 0,
                          max: 1000,
                          divisions: 100,
                          labels: RangeLabels(
                            filterController.minPrice.value.toStringAsFixed(0),
                            filterController.maxPrice.value.toStringAsFixed(0),
                          ),
                          values: RangeValues(
                            filterController.minPrice.value,
                            filterController.maxPrice.value,
                          ),
                          onChanged: (RangeValues values) {
                            filterController.minPrice.value = values.start;
                            filterController.maxPrice.value = values.end;
                          },
                        )),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: filterController.applyFilters,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text(
                          'Apply Filters',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}