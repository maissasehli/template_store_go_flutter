import 'package:flutter/material.dart';
import 'package:store_go/core/localization/changelocal.dart';
import 'package:get/get.dart';
import 'package:store_go/core/localization/translation.dart';
import 'package:store_go/routes.dart';
import 'package:store_go/core/services/services.dart'; // Import your services

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for async operations in main
  
  // Initialize services before creating the app
  await initialServices();
  
  runApp(const MyApp());
}

// Create a function to initialize all services
Future<void> initialServices() async {
  // Initialize shared preferences service
  await Get.putAsync(() => MyServices().init());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    LocaleController controller = Get.put(LocaleController());
    return GetMaterialApp(
      translations: MyTranslation(),
      debugShowCheckedModeBanner: false,
      title: 'StoreGo',
      locale: controller.language,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      getPages: routes,
    );
  }
}