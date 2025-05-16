import 'package:flutter/material.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_color_extension.dart';

class NoSearchResult extends StatelessWidget {
  final VoidCallback? onExploreCategories;

  const NoSearchResult({super.key, this.onExploreCategories});
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorExtension>()!;

    return Column(
      children: [
        const SizedBox(height: 150),

        Image.asset(AssetConfig.search, width: 84, height: 84),
        const SizedBox(height: 24),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Sorry, we couldn\'t find any matching result for your Search.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: colors.foreground,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onExploreCategories,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
            'Explore Categories',
            style: TextStyle(
              color: colors.primaryForeground,
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        const Spacer(),
      ],
    );
  }
}
