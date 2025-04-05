import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:store_go/features/auth/services/auth_service.dart';

class LifecycleObserver extends GetxController with WidgetsBindingObserver {
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _authService.handleAppResume();
    }
  }
}
