import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/config/theme/app_color_utils.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChange;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: GNav(
        gap: 8,
        activeColor: Theme.of(context).primaryColor,
        color: Colors.grey,
        iconSize: 24,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        duration: const Duration(milliseconds: 400),
        tabBackgroundColor: Theme.of(context).primaryColor,
        selectedIndex: currentIndex,
        onTabChange: onTabChange,
        tabs: [
          // Home Tab
          GButton(
            icon: Icons.home_outlined, // Keep this for now
            text: 'Home',
            textColor: Theme.of(context).colorScheme.onPrimary,
            leading: ThemeAwareSvg(
              assetPath: AssetConfig.homeIcon,
              width: 24,
              height: 24,
              colorName:
                  currentIndex == 0
                      ? AppColorName.primaryForeground
                      : AppColorName.muted,
            ),
          ),
          // Wishlist Tab
          GButton(
            icon: Icons.favorite_border, // Keep this for now
            text: 'Wishlist',
            textColor: Theme.of(context).colorScheme.onPrimary,
            leading: ThemeAwareSvg(
              assetPath: AssetConfig.heartIcon,
              width: 24,
              height: 24,
              colorName:
                  currentIndex == 1
                      ? AppColorName.primaryForeground
                      : AppColorName.muted,
            ),
          ),
          // Cart Tab
          GButton(
            icon: Icons.shopping_cart_outlined,
            text: 'Cart',
            textColor: Theme.of(context).colorScheme.onPrimary,
            leading: ThemeAwareSvg(
              assetPath: AssetConfig.panierIcon,
              width: 24,
              height: 24,
              colorName:
                  currentIndex == 2
                      ? AppColorName.primaryForeground
                      : AppColorName.muted,
            ),
          ),
          // Profile Tab
          GButton(
            icon: Icons.person_outline,
            text: 'Profile',
            textColor: Theme.of(context).colorScheme.onPrimary,
            leading: ThemeAwareSvg(
              assetPath: AssetConfig.profileIcon,
              width: 24,
              height: 24,
              colorName:
                  currentIndex == 3
                      ? AppColorName.primaryForeground
                      : AppColorName.muted,
            ),
          ),
        ],
      ),
    );
  }
}
