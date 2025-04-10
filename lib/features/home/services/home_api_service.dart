import 'package:dio/dio.dart' as dio;
import 'package:logger/logger.dart';
import 'package:store_go/app/core/services/api_client.dart';

class HomeApiService {
  final ApiClient _apiClient;

  HomeApiService(this._apiClient);

  Future<dio.Response> getHomeData() async {
    try {
      Logger().d("Getting home data (categories + products)");
      final response = await _apiClient.get("/home"); // <-- si ta route backend c'est /api/mobile-app/home
      Logger().d(response.toString());
      return response;
    } catch (e) {
      Logger().e("Error getting home data: $e");
      rethrow;
    }
  }
}
