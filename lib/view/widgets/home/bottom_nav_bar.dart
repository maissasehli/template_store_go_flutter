import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:store_go/core/constants/routes_constants.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
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
        // ignore: deprecated_member_use
        tabBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        selectedIndex: currentIndex,
        onTabChange: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed(AppRoute.home);
              break;
            case 1:
              Get.offAllNamed(AppRoute.categories);
              break;
            case 2:
              Get.offAllNamed(AppRoute.wishlist);
              break;
            case 3:
              Get.offAllNamed(AppRoute.cart);
              break;
            case 4:
              Get.offAllNamed(AppRoute.profile);
              break;
          }
        },
        tabs: const [
          GButton(icon: Icons.home_outlined, text: 'Home'),
          GButton(icon: Icons.category_outlined, text: 'Categories'),
          GButton(icon: Icons.favorite_border, text: 'Wishlist'),
          GButton(icon: Icons.shopping_cart_outlined, text: 'Cart'),
          GButton(icon: Icons.person_outline, text: 'Profile'),
        ],
      ),
    );
  }
}
