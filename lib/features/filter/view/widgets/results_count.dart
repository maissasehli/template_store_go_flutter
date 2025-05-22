// Results count widget
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/product/controllers/product_list_controller.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
class ResultsCount extends StatelessWidget {
  final ProductListController listController;

  const ResultsCount({super.key, required this.listController});

  @override
  Widget build(BuildContext context) {
    final bool isRtl = LocalizationService.isRtl(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIConfig.paddingMedium),
      child: Obx(
        () => Align(
          alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            'filter.results_found'.translateWithParam({
              'count': listController.products.length.toString(),
            }),
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                fontFamily: 'Poppins',
                fontSize: UIConfig.fontSizeSmall,
                fontWeight: FontWeight.w400,
                color: AppColors.mutedForeground(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
