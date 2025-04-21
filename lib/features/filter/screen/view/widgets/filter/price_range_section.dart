import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'custom_thumb_shape.dart';

class PriceRangeSection extends StatelessWidget {
  final RangeValues priceRange;
  final Function(RangeValues) onRangeChanged;

  const PriceRangeSection({
    super.key,
    required this.priceRange,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final logger = Logger();
    
    // Clamp priceRange to ensure values are within [0, 500]
    final clampedPriceRange = RangeValues(
      priceRange.start.clamp(0.0, 500.0),
      priceRange.end.clamp(0.0, 500.0),
    );

    // Log if clamping was necessary
    if (priceRange != clampedPriceRange) {
      logger.w('Clamped invalid priceRange: start=${priceRange.start}, end=${priceRange.end} '
          'to start=${clampedPriceRange.start}, end=${clampedPriceRange.end}');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price range',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF121826),
          ),
        ),
        const SizedBox(height: 10),
        
        // Price slider labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${clampedPriceRange.start.toInt()}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
              ),
            ),
            Text(
              '${clampedPriceRange.end.toInt()}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
              ),
            ),
            const Text(
              'Tnd',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
              ),
            ),
          ],
        ),
        
        SliderTheme(
          data: SliderThemeData(
            thumbColor: Colors.white,
            activeTrackColor: Colors.black,
            inactiveTrackColor: Colors.grey[300],
            trackHeight: 2,
            thumbShape: CustomThumbShape(),
            overlayColor: Colors.transparent,
          ),
          child: RangeSlider(
            values: clampedPriceRange,
            min: 0,
            max: 500,
            onChanged: (RangeValues newValues) {
              // Ensure new values are within bounds
              final clampedValues = RangeValues(
                newValues.start.clamp(0.0, 500.0),
                newValues.end.clamp(0.0, 500.0),
              );
              onRangeChanged(clampedValues);
            },
          ),
        ),
      ],
    );
  }
}