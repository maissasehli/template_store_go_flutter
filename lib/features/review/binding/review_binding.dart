import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/review/controllers/review_controller.dart';
import 'package:store_go/features/review/repositories/review_repository.dart';

class ReviewBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();

    Get.lazyPut<ReviewRepository>(
      () => ReviewRepository(apiClient: apiClient),
    );

    Get.lazyPut<ReviewController>(
      () => ReviewController(repository: Get.find<ReviewRepository>()),
    );
  }
}