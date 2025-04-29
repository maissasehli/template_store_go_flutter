import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'package:store_go/features/filter/view/widgets/thumb_shape.dart';
class PriceRangeSlider extends StatelessWidget {
  final ProductFilterController filterController;

  const PriceRangeSlider({super.key, required this.filterController});

  @override
  Widget build(BuildContext context) {
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
                thumbShape: CustomThumbShape(),
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
                  filterController.minPrice.value.toStringAsFixed(0),
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
                  filterController.maxPrice.value.toStringAsFixed(0),
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
}
