// filter_chips_row.dart
import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';

class FilterChipsRow extends StatelessWidget {
  final List<String> filterOptions;
  final String activeFilter;
  final Function(String) onFilterApplied;

  const FilterChipsRow({
    super.key,
    required this.filterOptions,
    required this.activeFilter,
    required this.onFilterApplied,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          const Text(
            'Filter:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filterOptions.map((filter) {
                  final isActive = activeFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                          color: isActive ? Colors.white : Colors.grey[800],
                        ),
                      ),
                      selected: isActive,
                      showCheckmark: false,
                      backgroundColor: Colors.grey[100],
                      selectedColor: AppColors.primary(context),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isActive 
                              ? AppColors.primary(context) 
                              : Colors.grey[300]!,
                        ),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          onFilterApplied(filter);
                        }
                      },
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