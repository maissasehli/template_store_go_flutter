import 'package:flutter/material.dart';
import 'package:store_go/core/constants/ui.dart';
import 'package:store_go/core/model/home/color_variant_model.dart';

class ColorSelector extends StatelessWidget {
  final List<ColorVariantModel> colors;
  final String? selectedColorId;
  final Function(String) onColorSelected;

  const ColorSelector({
    Key? key,
    required this.colors,
    required this.selectedColorId,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: TextStyle(
            fontSize: UIConstants.fontSizeMedium,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: colors.map((color) {
              final isSelected = color.id == selectedColorId;
              
              return GestureDetector(
                onTap: () => onColorSelected(color.id),
                child: Container(
                  margin: const EdgeInsets.only(right: UIConstants.paddingSmall),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(int.parse('0xFF${color.hexCode}')),
                      shape: BoxShape.circle,
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: _isDarkColor(color.hexCode) ? Colors.white : Colors.black,
                            size: 16,
                          )
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  bool _isDarkColor(String hexColor) {
    // Convert hex to RGB and check if it's a dark color
    final r = int.parse(hexColor.substring(0, 2), radix: 16);
    final g = int.parse(hexColor.substring(2, 4), radix: 16);
    final b = int.parse(hexColor.substring(4, 6), radix: 16);
    
    // Calculate perceived brightness
    // Formula: (R * 299 + G * 587 + B * 114) / 1000
    final brightness = (r * 299 + g * 587 + b * 114) / 1000;
    
    return brightness < 128; // If brightness < 128, it's a dark color
  }
}