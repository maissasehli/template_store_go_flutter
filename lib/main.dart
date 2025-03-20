import 'package:flutter/material.dart';
import 'package:store_go/core/di/initializer.dart';
import 'package:store_go/core/localization/change_local.dart';
import 'package:get/get.dart';
import 'package:store_go/core/localization/translation.dart';
import 'package:store_go/core/theme/theme_controller.dart';
import 'package:store_go/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppInitializer.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    LocaleController controller = Get.put(LocaleController());
    // Use GetX to rebuild when theme changes
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetMaterialApp(
          translations: MyTranslation(),
          debugShowCheckedModeBanner: false,
          title: 'StoreGo',
          locale: controller.language,
          theme: themeController.theme,
          darkTheme: themeController.theme, // Let controller determine theme
          themeMode: themeController.themeMode,
          getPages: routes,
        );
      },
    );
  }
}
