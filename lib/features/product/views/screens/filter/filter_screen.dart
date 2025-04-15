// main_filter_page.dart
import 'package:flutter/material.dart';
import 'package:store_go/features/product/views/widgets/filter/apply_button.dart';
import 'package:store_go/features/product/views/widgets/filter/category_section.dart';
import 'package:store_go/features/product/views/widgets/filter/filter_header.dart';
import 'package:store_go/features/product/views/widgets/filter/price_range_section.dart';
import 'package:store_go/features/product/views/widgets/filter/rating_section.dart';
import 'package:store_go/features/product/views/widgets/filter/sort_section.dart';


class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

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
          FilterHeader(
            onClear: () {
              Navigator.pop(context);
            },
            onClose: () {
              Navigator.pop(context);
            },
          ),
          
          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category section
                  CategorySection(
                    selectedCategory: selectedCategory,
                    onCategorySelected: (category) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Price range section
                  PriceRangeSection(
                    priceRange: priceRange,
                    onRangeChanged: (RangeValues values) {
                      setState(() {
                        priceRange = values;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sort by section
                  SortSection(
                    selectedTab: selectedTab,
                    onTabSelected: (tab) {
                      setState(() {
                        selectedTab = tab;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Rating section
                  RatingSection(
                    selectedRating: selectedRating,
                    onRatingSelected: (rating) {
                      setState(() {
                        selectedRating = rating;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Apply button
          ApplyButton(
            onApply: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}