import 'package:flutter/material.dart';
import 'package:store_go/view/widgets/home/bottom_nav_bar.dart';

class BaseScreen extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final int currentIndex;
  final bool showBottomNav;

  const BaseScreen({
    super.key,
    required this.body,
    this.appBar,
    required this.currentIndex,
    this.showBottomNav = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar:
          showBottomNav ? CustomBottomNavBar(currentIndex: currentIndex) : null,
    );
  }
}
