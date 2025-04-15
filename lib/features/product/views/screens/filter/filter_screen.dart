
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String selectedCategory = 'All';
  String selectedTab = 'New Today';
  int selectedRating = 5;
  RangeValues priceRange = const RangeValues(45, 320);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar indicator
          Container(
            width: 60,
            height: 5,
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          
          // Filter page header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Clear',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Text(
                  'Filter by',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, size: 24),
                ),
              ],
            ),
          ),
          
          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categorie section
                  const Text(
                    'Catégorie',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF121826),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Categories first row
                  Row(
                    children: [
                      _buildCategoryButton('All', isSelected: selectedCategory == 'All'),
                      const SizedBox(width: 8),
                      _buildCategoryButton('Vêtements', isSelected: selectedCategory == 'Vêtements'),
                      const SizedBox(width: 8),
                      _buildCategoryButton('Soins', isSelected: selectedCategory == 'Soins'),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Categories second row
                  Row(
                    children: [
                      _buildCategoryButton('Tops', isSelected: selectedCategory == 'Tops'),
                      const SizedBox(width: 8),
                      _buildCategoryButton('Shorts', isSelected: selectedCategory == 'Shorts'),
                      const SizedBox(width: 8),
                      _buildCategoryButton('Cats', isSelected: selectedCategory == 'Cats'),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Price range section
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
                      thumbShape: _CustomThumbShape(),
                      overlayColor: Colors.transparent,
                    ),
                    child: RangeSlider(
                      values: priceRange,
                      min: 0,
                      max: 500,
                      onChanged: (RangeValues values) {
                        setState(() {
                          priceRange = values;
                        });
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sort by section
                  const Text(
                    'Sort by',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF121826),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Sort tabs
                  Row(
                    children: [
                      _buildSortTab('New Today', isSelected: selectedTab == 'New Today'),
                      const SizedBox(width: 8),
                      _buildSortTab('Top Sellers', isSelected: selectedTab == 'Top Sellers'),
                      const SizedBox(width: 8),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Rating section
                  const Text(
                    'Rating',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF121826),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Stars rating
                  _buildRatingRow(5),
                  const SizedBox(height: 8),
                  _buildRatingRow(4),
                  const SizedBox(height: 8),
                  _buildRatingRow(3),
                  const SizedBox(height: 8),
                  _buildRatingRow(2),
                  const SizedBox(height: 8),
                  _buildRatingRow(1),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Apply button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Apply Now',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Category button widget
  Widget _buildCategoryButton(String label, {required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // Sort tab widget
  Widget _buildSortTab(String label, {required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // Rating row widget
  Widget _buildRatingRow(int rating) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRating = rating;
        });
      },
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
              color: selectedRating == rating ? Colors.black : Colors.white,
            ),
            child: selectedRating == rating 
                ? const Center(
                    child: Icon(
                      Icons.circle,
                      size: 8,
                      color: Colors.white,
                    ),
                  ) 
                : null,
          ),
          const SizedBox(width: 12),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                size: 20,
                color: index < rating ? Colors.amber : Colors.grey[300],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom thumb shape for the range slider
class _CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(12, 12);
  }

  @override
  void paint(
    PaintingContext context, 
    Offset center, 
    {required Animation<double> activationAnimation, 
    required Animation<double> enableAnimation, 
    required bool isDiscrete, 
    required TextPainter labelPainter, 
    required RenderBox parentBox, 
    required SliderThemeData sliderTheme, 
    required TextDirection textDirection, 
    required double value, 
    required double textScaleFactor, 
    required Size sizeWithOverflow}
  ) {
    final Canvas canvas = context.canvas;
    
    final Paint fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
      
    final Paint borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawCircle(center, 10, fillPaint);
    canvas.drawCircle(center, 10, borderPaint);
  }
}


