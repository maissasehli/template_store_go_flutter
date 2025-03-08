import 'package:flutter/material.dart';
import 'package:store_go/bindings/auth_binding.dart';
import 'package:store_go/core/localization/changelocal.dart';
import 'package:get/get.dart';
import 'package:store_go/core/localization/translation.dart';
import 'package:store_go/core/services/authMiddelware.service.dart';
import 'package:store_go/core/theme/theme_controller.dart';
import 'package:store_go/routes.dart';
import 'package:store_go/core/services/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:store_go/core/di/dependency_injection.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize dependencies
  await DependencyInjection.init();
  // Register MyServices asynchronously before running the app
  await Get.putAsync(() async => await MyServices().init());

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    debug: true,
  );
  await Get.putAsync(() => AuthMiddlewareService().init());

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
          initialRoute: '/',
          getPages: routes,
        );
      },
    );
  }
}
