import 'package:flutter/material.dart';

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

  Color _getColorFromClass(String? colorClass) {
    if (colorClass == null || colorClass.isEmpty || !colorClass.startsWith('bg-')) {
      return Colors.grey;
    }

    // Split the colorClass (e.g., 'bg-blue-600') into parts
    final parts = colorClass.split('-');
    if (parts.length < 2) {
      return Colors.grey;
    }

    // Extract color name and shade
    String colorName = parts[1].toLowerCase(); // e.g., 'blue'
    int? shade = parts.length > 2 ? int.tryParse(parts[2]) : null; // e.g., 600

    // Handle special cases for color names (e.g., 'grey' vs 'gray')
    if (colorName == 'grey') {
      colorName = 'gray';
    } else if (colorName == 'bluegray') {
      colorName = 'blueGrey';
    }

    // Map of color names to Flutter Colors, with flags for shade support
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

    // Get the color entry from the map
    final colorEntry = colorMap[colorName];
    if (colorEntry == null) {
      return Colors.grey; // Fallback for unknown color names
    }

    final baseColor = colorEntry['color'] as Color;
    final supportsShades = colorEntry['supportsShades'] as bool;

    // If no shade is specified or the color doesn't support shades, return the base color
    if (shade == null || !supportsShades) {
      return baseColor;
    }

    // Validate the shade (Flutter supports 50, 100, 200, ..., 900)
    const validShades = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
    if (!validShades.contains(shade)) {
      return baseColor; // Fallback to base color if shade is invalid
    }

    // Since we know baseColor supports shades (it's a MaterialColor), cast and access the shade
    if (baseColor is MaterialColor || baseColor is MaterialAccentColor) {
      return (baseColor as dynamic)[shade] ?? baseColor; // Access the shade
    }

    return baseColor; // Fallback to base color if not a MaterialColor
  }

  Color _getColor(Map<String, String> colorMap) {
    final customColor = colorMap['customColor'] ?? '';
    final colorClass = colorMap['colorClass'] ?? '';

    // Prioritize customColor (hex code) if available
    if (customColor.isNotEmpty) {
      return _getColorFromHex(customColor);
    }
    // Otherwise, use colorClass
    return _getColorFromClass(colorClass);
  }

  bool _isLightColor(Color color) {
    final luminance = (0.299 * color.r + 0.587 * color.g + 0.114 * color.b);
    return luminance > 128;
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
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFFDDDDDD),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: colors.map((colorMap) {
          final colorValue = colorMap['value'] ?? '';
          final isSelected = selectedColor == colorValue;
          final color = _getColor(colorMap);
          final isLight = _isLightColor(color);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
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