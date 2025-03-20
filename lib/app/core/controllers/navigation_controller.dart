import 'package:get/get.dart';


class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  void changeTab(int index) {
    // Update the current tab index
    selectedIndex.value = index;
  }

  // Navigate to a specific route while preserving the tab state
  void navigateTo(String route, {Map<String, dynamic>? arguments}) {
    Get.toNamed(route, arguments: arguments);
  }

  // Go back to main container with specific tab
  void goToTab(int index) {
    selectedIndex.value = index;
    Get.until((route) => route.settings.name == '/main');
  }
}
