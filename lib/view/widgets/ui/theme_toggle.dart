import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/theme/theme_controller.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<ThemeController>(
      builder: (controller) {
        return IconButton(
          icon: Icon(
            controller.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            controller.toggleTheme();
          },
          tooltip: controller.isDarkMode
              ? 'Switch to Light Mode'
              : 'Switch to Dark Mode',
        );
      },
    );
  }
}
