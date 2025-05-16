import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'package:store_go/features/filter/view/widgets/thumb_shape.dart';
import 'dart:developer' as developer;

class PriceRangeSlider extends StatelessWidget {
  final ProductFilterController filterController;
  
  const PriceRangeSlider({
    super.key, 
    required this.filterController
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: UIConfig.paddingMedium),
          child: Obx(
            () => SliderTheme(
              data: SliderThemeData(
                trackHeight: 2,
                activeTrackColor: AppColors.primary(context),
                inactiveTrackColor: AppColors.border(context),
                thumbColor: AppColors.background(context),
                thumbShape:  CustomThumbShape(),
                overlayColor: AppColors.primary(context).withOpacity(0.1),
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
                  // Update the filter controller values with the selected range
                  filterController.minPrice.value = values.start;
                  filterController.maxPrice.value = values.end;
                  // Log the updated values for debugging
                  developer.log(
                    'Price range updated: min=${values.start.toStringAsFixed(0)}, max=${values.end.toStringAsFixed(0)}',
                    name: 'PriceRangeSlider.onChanged',
                  );
                  // Ensure values are properly updated in the controller
                  filterController.update(); // Force update using GetX
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: UIConfig.paddingMedium),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  filterController.minPrice.value.toStringAsFixed(0),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: UIConfig.fontSizeRegular,
                    color: AppColors.foreground(context),
                  ),
                ),
              ),
              Text(
                'Tnd',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: UIConfig.fontSizeRegular,
                  color: AppColors.foreground(context),
                ),
              ),
              Obx(
                () => Text(
                  filterController.maxPrice.value.toStringAsFixed(0),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: UIConfig.fontSizeRegular,
                    color: AppColors.foreground(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
