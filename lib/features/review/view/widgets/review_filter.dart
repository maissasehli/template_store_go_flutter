import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

class ReviewFilter extends StatelessWidget {
  final String activeFilter;
  final List<String> filterOptions;
  final Function(String) onFilterSelected;

  const ReviewFilter({
    super.key,
    required this.activeFilter,
    required this.filterOptions,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRtl = LocalizationService.isRtl(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Text(
            'reviews.filter'.translate(),
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: AppColors.foreground(context),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: isRtl,
              child: Row(
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                children:
                    filterOptions.map((filter) {
                      final isActive = activeFilter == filter;
                      return Padding(
                        padding: EdgeInsets.only(
                          right: isRtl ? 0 : 8,
                          left: isRtl ? 8 : 0,
                        ),
                        child: FilterChip(
                          label: Text(
                            filter == 'All Reviews'
                                ? 'reviews.all_reviews'.translate()
                                : filter,
                            style: LocalizationService.getLocalizedTextStyle(
                              context,
                              TextStyle(
                                fontSize: 12,
                                color:
                                    isActive
                                        ? AppColors.background(context)
                                        : AppColors.foreground(context),
                                fontWeight:
                                    isActive
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                          selected: isActive,
                          onSelected: (selected) {
                            if (selected) {
                              onFilterSelected(filter);
                            }
                          },
                          backgroundColor: AppColors.card(context),
                          selectedColor: AppColors.primary(context),
                          checkmarkColor: AppColors.background(context),
                          showCheckmark: false,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color:
                                  isActive
                                      ? Colors.transparent
                                      : AppColors.border(context),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
