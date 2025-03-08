import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app_theme.dart';

class ThemeController extends GetxController {
  // Storage for theme settings
  final _storage = GetStorage();
  final _themeKey = 'theme_mode';

  // Observable to track theme mode
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  // Getter for current theme mode
  ThemeMode get themeMode => _themeMode.value;

  // Computed property to determine if dark mode is active
  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.system) {
      return SchedulerBinding.instance.window.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode.value == ThemeMode.dark;
  }

  // Get the correct ThemeData based on current mode
  ThemeData get theme => isDarkMode ? AppTheme.dark() : AppTheme.light();

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  // Load saved theme mode from storage
  void _loadThemeMode() {
    final themeModeIndex = _storage.read(_themeKey) ?? 0;
    _themeMode.value = ThemeMode.values[themeModeIndex];
  }

  // Change theme mode and save to storage
  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    _storage.write(_themeKey, mode.index);
    Get.changeTheme(
        mode == ThemeMode.dark ? AppTheme.dark() : AppTheme.light());
    update(); // Update all dependent widgets
  }

  // Toggle between light and dark mode
  void toggleTheme() {
    if (_themeMode.value == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
}
