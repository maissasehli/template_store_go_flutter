import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';

class ColorSelector extends StatelessWidget {
  final String? selectedColor;
  final Function(String) onColorSelected;
  final Map<String, Color> colorOptions;

  const ColorSelector({
    Key? key,
    required this.selectedColor,
    required this.onColorSelected,
    this.colorOptions = const {
      'White': Colors.white,
      'Black': Colors.black,
      'Green': Colors.green,
      'Orange': Colors.orange,
    },
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.border(context).withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children:
            colorOptions.entries.map((entry) {
              return GestureDetector(
                onTap: () => onColorSelected(entry.key),
                child: Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: entry.value,
                    border:
                        entry.key == 'White'
                            ? Border.all(color: AppColors.border(context))
                            : null,
                  ),
                  child:
                      selectedColor == entry.key && entry.key == 'White'
                          ? Center(
                            child: Icon(
                              Icons.check,
                              size: 16,
                              color: AppColors.foreground(context),
                            ),
                          )
                          : null,
                ),
              );
            }).toList(),
      ),
    );
  }
}
