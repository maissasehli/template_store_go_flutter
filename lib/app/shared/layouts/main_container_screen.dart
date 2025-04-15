import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/shared/widgets/bottom_nav_bar.dart';
import 'package:store_go/app/shared/controllers/navigation_controller.dart';
import 'package:store_go/features/home/views/home_screen.dart';
import 'package:store_go/features/wishlist/views/wishlist_screen.dart';
import 'package:store_go/features/cart/views/cart_screen.dart';
import 'package:store_go/features/profile/views/screens/profile_screen.dart';

class MainContainerScreen extends StatelessWidget {
  final NavigationController navigationController =
      Get.find<NavigationController>();

  MainContainerScreen({super.key});

  final List<Widget> _screens = [
    HomeScreen(),
    WishlistPage(),
    CartScreen(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int currentIndex = navigationController.selectedIndex.value;

      return Scaffold(
        body: IndexedStack(index: currentIndex, children: _screens),
        bottomNavigationBar: BottomNavBar(
          currentIndex: currentIndex,
          onTabChange: navigationController.changeTab,
        ),
      );
    });
  }
}