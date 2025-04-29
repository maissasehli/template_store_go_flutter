import 'package:get_storage/get_storage.dart';
import 'package:store_go/app/di/service_locator.dart';
import 'package:store_go/app/core/services/storage_service.dart';

class AppInitializer {
  static Future<void> init() async {

    // Step 1: Initialize storage
    await GetStorage.init();
    await StorageService.init();

    // Step 2: Register all global dependencies
    await ServiceLocator.registerDependencies();
  }
}
