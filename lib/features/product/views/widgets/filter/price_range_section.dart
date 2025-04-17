// widgets/price_range_section.dart
import 'package:flutter/material.dart';
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
       
        // Price slider
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${priceRange.start.toInt()}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
              ),
            ),
            Text(
              '${priceRange.end.toInt()}',
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
            values: priceRange,
            min: 0,
            max: 500,
            onChanged: onRangeChanged,
          ),
        ),
      ],
    );
  }
}