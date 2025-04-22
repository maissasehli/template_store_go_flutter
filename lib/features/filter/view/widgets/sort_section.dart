import 'package:flutter/material.dart';
import 'sort_tab.dart';

class SortSection extends StatelessWidget {
  final String selectedTab;
  final Function(String) onTabSelected;

  const SortSection({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            SortTab(
              label: 'New Today',
              isSelected: selectedTab == 'New Today',
              onTap: () => onTabSelected('New Today'),
            ),
            SortTab(
              label: 'Top Sellers',
              isSelected: selectedTab == 'Top Sellers',
              onTap: () => onTabSelected('Top Sellers'),
            ),
            SortTab(
              label: 'Price: Low to High',
              isSelected: selectedTab == 'Price: Low to High',
              onTap: () => onTabSelected('Price: Low to High'),
            ),
            SortTab(
              label: 'Price: High to Low',
              isSelected: selectedTab == 'Price: High to Low',
              onTap: () => onTabSelected('Price: High to Low'),
            ),
          ],
        ),
      ],
    );
  }
}