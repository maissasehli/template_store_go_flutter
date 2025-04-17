// widgets/filter_header.dart
import 'package:flutter/material.dart';

class FilterHeader extends StatelessWidget {
  final VoidCallback onClear;
  final VoidCallback onClose;

  const FilterHeader({
    super.key,
    required this.onClear,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: onClear,
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
            onPressed: onClose,
            icon: const Icon(Icons.close, size: 24),
          ),
        ],
      ),
    );
  }
}