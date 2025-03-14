import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/core/constants/assets_constants.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    Key? key,
    this.currentIndex = 0,
  }) : super(key: key);

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
          // Home Button (Active)
          _buildActiveNavItem(
            iconPath: ImageAsset.homeIcon,
            label: 'Home',
            isActive: currentIndex == 0,
            onTap: () {
              if (currentIndex != 0) Get.offAllNamed('/home');
            },
          ),

          // Wishlist Button
          _buildNavItem(
            iconPath: ImageAsset.heartIcon,
            isActive: currentIndex == 1,
            onTap: () {
              Get.toNamed('/wishlist');
            },
          ),

          // Cart Button
          _buildNavItem(
            iconPath: ImageAsset.bagIcon,
            isActive: currentIndex == 2,
            onTap: () {
              Get.toNamed('/cart');
            },
          ),

          // Profile Button
          _buildNavItem(
            iconPath: ImageAsset.profileIcon,
            isActive: currentIndex == 3,
            onTap: () {
              Get.toNamed('/profile');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActiveNavItem({
    required String iconPath,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              width: 24,
              height: 24,
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

  Widget _buildNavItem({
    required String iconPath,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return IconButton(
      icon: SvgPicture.asset(
        iconPath,
        colorFilter: ColorFilter.mode(
          isActive ? Colors.black : Colors.grey,
          BlendMode.srcIn,
        ),
        width: 28,
        height: 28,
      ),
      onPressed: onTap,
    );
  }
}
