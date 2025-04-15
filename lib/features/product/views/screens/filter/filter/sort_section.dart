// widgets/sort_section.dart
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
        
        // Sort tabs
        Row(
          children: [
            SortTab(
              label: 'New Today',
              isSelected: selectedTab == 'New Today',
              onTap: () => onTabSelected('New Today'),
            ),
            const SizedBox(width: 8),
            SortTab(
              label: 'Top Sellers',
              isSelected: selectedTab == 'Top Sellers',
              onTap: () => onTabSelected('Top Sellers'),
            ),
          ],
        ),
      ],
    );
  }
}