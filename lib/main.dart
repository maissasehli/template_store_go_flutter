import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:store_go/app/di/initializer.dart';
import 'package:get/get.dart';
import 'package:store_go/app/shared/controllers/theme_controller.dart';
import 'package:store_go/app/core/config/main_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Easy Localization first
  await EasyLocalization.ensureInitialized();

  await AppInitializer.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar'), Locale('fr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use GetX to rebuild when theme changes
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetMaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          title: 'StoreGo',
          theme: themeController.theme,
          darkTheme: themeController.theme, // Let controller determine theme
          themeMode: themeController.themeMode,
          getPages: routes,
        );
      },
    );
  }
}
