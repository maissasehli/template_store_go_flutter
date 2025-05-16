import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';

class ColorSelector extends StatelessWidget {
  final String selectedColor;
  final List<Map<String, String>> colors;
  final ValueChanged<String> onColorSelected;

  const ColorSelector({
    super.key,
    required this.selectedColor,
    required this.colors,
    required this.onColorSelected,
  });

  Color _getColorFromHex(String? hex) {
    if (hex == null || hex.isEmpty) {
      return Colors.grey;
    }
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }

  Color _getColorFromClass(String? colorClass, BuildContext context) {
    if (colorClass == null || colorClass.isEmpty) {
      return Colors.grey;
    }

    // Handle theme color references
    if (colorClass.startsWith('theme-')) {
      final parts = colorClass.split('-');
      if (parts.length < 2) {
        return Colors.grey;
      }

      String colorName = parts[1].toLowerCase();
      
      // Map theme color names to app color methods
      switch (colorName) {
        case 'primary':
          return AppColors.primary(context);
        case 'secondary':
          return AppColors.secondary(context);
        case 'accent':
          return AppColors.accent(context);
        case 'muted':
          return AppColors.muted(context);
        case 'background':
          return AppColors.background(context);
        case 'foreground':
          return AppColors.foreground(context);
        case 'destructive':
          return AppColors.destructive(context);
        case 'border':
          return AppColors.border(context);
        default:
          return Colors.grey;
      }
    }

    // Handle tailwind-style color classes
    if (colorClass.startsWith('bg-')) {
      final parts = colorClass.split('-');
      if (parts.length < 2) {
        return Colors.grey;
      }

      String colorName = parts[1].toLowerCase();
      int? shade = parts.length > 2 ? int.tryParse(parts[2]) : null;

      if (colorName == 'grey') {
        colorName = 'gray';
      } else if (colorName == 'bluegray') {
        colorName = 'blueGrey';
      }

      final colorMap = <String, Map<String, dynamic>>{
        'red': {'color': Colors.red, 'supportsShades': true},
        'pink': {'color': Colors.pink, 'supportsShades': true},
        'purple': {'color': Colors.purple, 'supportsShades': true},
        'deepPurple': {'color': Colors.deepPurple, 'supportsShades': true},
        'indigo': {'color': Colors.indigo, 'supportsShades': true},
        'blue': {'color': Colors.blue, 'supportsShades': true},
        'lightBlue': {'color': Colors.lightBlue, 'supportsShades': true},
        'cyan': {'color': Colors.cyan, 'supportsShades': true},
        'teal': {'color': Colors.teal, 'supportsShades': true},
        'green': {'color': Colors.green, 'supportsShades': true},
        'lightGreen': {'color': Colors.lightGreen, 'supportsShades': true},
        'lime': {'color': Colors.lime, 'supportsShades': true},
        'yellow': {'color': Colors.yellow, 'supportsShades': true},
        'amber': {'color': Colors.amber, 'supportsShades': true},
        'orange': {'color': Colors.orange, 'supportsShades': true},
        'deepOrange': {'color': Colors.deepOrange, 'supportsShades': true},
        'brown': {'color': Colors.brown, 'supportsShades': true},
        'gray': {'color': Colors.grey, 'supportsShades': true},
        'blueGrey': {'color': Colors.blueGrey, 'supportsShades': true},
        'black': {'color': Colors.black, 'supportsShades': false},
        'white': {'color': Colors.white, 'supportsShades': false},
      };

      final colorEntry = colorMap[colorName];
      if (colorEntry == null) {
        return Colors.grey;
      }

      final baseColor = colorEntry['color'] as Color;
      final supportsShades = colorEntry['supportsShades'] as bool;

      if (shade == null || !supportsShades) {
        return baseColor;
      }

      const validShades = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
      if (!validShades.contains(shade)) {
        return baseColor;
      }

      if (baseColor is MaterialColor || baseColor is MaterialAccentColor) {
        return (baseColor as dynamic)[shade] ?? baseColor;
      }

      return baseColor;
    }

    return Colors.grey;
  }

  Color _getColor(Map<String, String> colorMap, BuildContext context) {
    final customColor = colorMap['customColor'] ?? '';
    final colorClass = colorMap['colorClass'] ?? '';

    if (customColor.isNotEmpty) {
      return _getColorFromHex(customColor);
    }
    return _getColorFromClass(colorClass, context);
  }

  bool _isLightColor(Color color) {
    final luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.5;
  }

  @override
  Widget build(BuildContext context) {
    if (colors.isEmpty) {
      return const Text(
        'No colors available',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      );
    }

    return Container(
      width: 35,
      padding: const EdgeInsets.symmetric(vertical: UIConfig.paddingSmall),
      decoration: BoxDecoration(
        color: AppColors.background(context),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular),
        border: Border.all(
          color: AppColors.border(context),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: colors.map((colorMap) {
          final colorValue = colorMap['value'] ?? '';
          final isSelected = selectedColor == colorValue;
          final color = _getColor(colorMap, context);
          final isLight = _isLightColor(color);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: UIConfig.paddingSmall),
            child: GestureDetector(
              onTap: () => onColorSelected(colorValue),
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: Border.all(
                    color: isSelected
                        ? (isLight ? Colors.black : Colors.white)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: 16,
                        color: isLight ? Colors.black : Colors.white,
                      )
                    : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}