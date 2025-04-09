import 'package:flutter/material.dart';
import 'package:store_go/features/home/views/widgets/search_bar.dart';

class WishlistHeader extends StatelessWidget {
  final Function(String) onSearch;

  const WishlistHeader({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        CustomSearchBar(onSearch: onSearch),
        const SizedBox(height: 40),
      ],
    );
  }
}
