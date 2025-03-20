import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/view/widgets/home/bottom_nav_bar.dart';
import 'package:store_go/controller/other/navigation_controller.dart';
import 'package:store_go/view/screens/home/home_screen.dart';
import 'package:store_go/view/screens/wishlist/wishlist_screen.dart';
import 'package:store_go/view/screens/cart/cart_screen.dart';
import 'package:store_go/view/screens/profile/profile_screen.dart';

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
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: currentIndex,
          onTabChange: navigationController.changeTab,
        ),
      );
    });
  }
}
