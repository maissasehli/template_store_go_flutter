import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:store_go/core/di/service_locator.dart';
import 'package:store_go/core/services/local_storage/storage_service.dart';

class AppInitializer {
  static Future<void> init() async {
    // Step 1: Setup Flutter bindings
    WidgetsFlutterBinding.ensureInitialized();

    // Step 2: Initialize storage
    await GetStorage.init();
    await StorageService.init();

    // Step 3: Register all global dependencies
    await ServiceLocator.registerDependencies();
  }
}
