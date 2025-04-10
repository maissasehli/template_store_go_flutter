import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Home Button
          _buildNavItem(
            iconPath: AssetConfig.homeIcon,
            label: 'Home',
            isActive: currentIndex == 0,
            onTap: () {
              if (currentIndex != 0) Get.offAllNamed('/home');
            },
          ),

          // Wishlist Button
          _buildNavItem(
            iconPath: AssetConfig.heartIcon,
            label: 'Wishlist',
            isActive: currentIndex == 1,
            onTap: () {
              if (currentIndex != 1) Get.offAllNamed('/wishlist');
            },
          ),

          // Cart Button
          _buildNavItem(
            iconPath: AssetConfig.bagIcon,
            label: 'Cart',
            isActive: currentIndex == 2,
            onTap: () {
              if (currentIndex != 2) Get.offAllNamed('/cart');
            },
          ),

          // Profile Button
          _buildNavItem(
            iconPath: AssetConfig.profileIcon,
            label: 'Profile',
            isActive: currentIndex == 3,
            onTap: () {
              if (currentIndex != 3) Get.offAllNamed('/profile');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    // For active items: black pill with icon and text
    if (isActive) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                iconPath,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // For inactive items: just the icon
    return IconButton(
      onPressed: onTap,
      icon: SvgPicture.asset(
        iconPath,
        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
        width: 24,
        height: 24,
      ),
    );
  }
}
