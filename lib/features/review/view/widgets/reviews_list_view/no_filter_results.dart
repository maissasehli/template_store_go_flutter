// no_filter_results.dart
import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';

class NoFilterResults extends StatelessWidget {
  final VoidCallback onReset;

  const NoFilterResults({
    super.key,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No reviews match your filter',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onReset,
            child: Text(
              'Show all reviews',
              style: TextStyle(
                color: AppColors.primary(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}