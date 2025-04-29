import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'package:store_go/features/filter/view/widgets/rating_option.dart';

class RatingFilter extends StatelessWidget {
  final ProductFilterController filterController;

  const RatingFilter({super.key, required this.filterController});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Build each rating option
          for (int stars = 5; stars >= 1; stars--)
            Column(
              children: [
                RatingOption(
                  stars: stars,
                  isSelected: filterController.minRating.value == stars,
                  onTap: () => filterController.minRating.value = stars,
                ),
                if (stars > 1) const SizedBox(height: 12),
              ],
            ),
        ],
      ),
    );
  }
}
