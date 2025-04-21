// sort_menu_button.dart
import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';

class SortMenuButton extends StatelessWidget {
  final Map<String, String> sortOptions;
  final String currentSort;
  final Function(String) onSortSelected;

  const SortMenuButton({
    super.key,
    required this.sortOptions,
    required this.currentSort,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.sort),
      tooltip: 'Sort reviews',
      onSelected: onSortSelected,
      itemBuilder: (context) {
        return sortOptions.entries.map((entry) {
          return PopupMenuItem<String>(
            value: entry.key,
            child: Row(
              children: [
                if (currentSort == entry.key)
                  Icon(Icons.check, color: AppColors.primary(context), size: 18)
                else
                  const SizedBox(width: 18),
                const SizedBox(width: 8),
                Text(
                  entry.value,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: currentSort == entry.key ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}