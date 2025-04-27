import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'package:store_go/features/filter/view/widgets/filter_chip.dart';

class SortOptions extends StatelessWidget {
  final ProductFilterController filterController;

  const SortOptions({super.key, required this.filterController});

  @override
  Widget build(BuildContext context) {
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
                  child: CustomFilterChip(
                    label: option,
                    isSelected: isSelected,
                    onTap: () {
                      filterController.selectedSortOption.value = option;
                    },
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
