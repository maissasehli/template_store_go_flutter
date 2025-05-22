import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'package:store_go/features/filter/view/widgets/filter_chip.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

class SortOptions extends StatelessWidget {
  final ProductFilterController filterController;

  const SortOptions({super.key, required this.filterController});

  @override
  Widget build(BuildContext context) {
    final bool isRtl = LocalizationService.isRtl(context);
    final sortOptions = [
      'filter.new_today'.translate(),
      'filter.top_sellers'.translate(),
      'filter.new_collection'.translate(),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(
        () => Row(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          children:
              sortOptions.map((option) {
                final isSelected =
                    filterController.selectedSortOption.value == option;
                return Padding(
                  padding: EdgeInsets.only(
                    right: isRtl ? 0 : 8.0,
                    left: isRtl ? 8.0 : 0,
                  ),
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
