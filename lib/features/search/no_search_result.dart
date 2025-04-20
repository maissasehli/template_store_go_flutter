import 'package:flutter/material.dart';
import 'package:store_go/app/core/config/assets_config.dart';

class NoSearchResult extends StatelessWidget {
  final VoidCallback? onExploreCategories;
  
  const NoSearchResult({
    super.key,
    this.onExploreCategories
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 150),
        
        Image.asset(
          AssetConfig.search,
          width: 84,
          height: 84,
        ),
        const SizedBox(height: 24),
        
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Sorry, we couldn\'t find any matching result for your Search.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        ElevatedButton(
          onPressed: onExploreCategories,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            'Explore Categories',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        
        const Spacer(),
      ],
    );
  }
}