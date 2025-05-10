import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/services/connection_service.dart';
import 'package:store_go/app/shared/widgets/bottom_nav_bar.dart';
import 'package:store_go/app/shared/controllers/navigation_controller.dart';
import 'package:store_go/features/home/views/screen/home_screen.dart';
import 'package:store_go/features/wishlist/views/wishlist_screen.dart';
import 'package:store_go/features/cart/views/screen/cart_screen.dart';
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
  final ConnectionService connectionService = Get.find<ConnectionService>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int currentIndex = navigationController.selectedIndex.value;
      bool isConnected = connectionService.isConnected.value;

      return Scaffold(
        body: IndexedStack(index: currentIndex, children: _screens),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Connection banner above the bottom nav bar
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: !isConnected ? 36 : 0,
              width: double.infinity,
              color: Colors.red.shade700,
              child:
                  !isConnected
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wifi_off, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'No Internet Connection',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      )
                      : null,
            ),
            // Bottom navigation bar
            BottomNavBar(
              currentIndex: currentIndex,
              onTabChange: navigationController.changeTab,
            ),
          ],
        ),
      );
    });
  }
}
