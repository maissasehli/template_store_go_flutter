import 'package:get/get.dart';
import 'package:store_go/features/promotion/repositories/promotion_repository.dart';
import 'package:store_go/app/core/services/api_client.dart';

class PromotionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PromotionRepository>(
      () => PromotionRepository(
        apiClient: Get.find<ApiClient>(),
      ),
    );
  }
}