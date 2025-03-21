// lib/view/widgets/home/section_header.dart
import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/ui_config.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAllTap;

  const SectionHeader({
    Key? key,
    required this.title,
    required this.onSeeAllTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConfig.paddingMedium,
        vertical: UIConfig.paddingSmall,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: UIConfig.fontSizeRegular,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(onPressed: onSeeAllTap, child: const Text('See All')),
        ],
      ),
    );
  }
}
