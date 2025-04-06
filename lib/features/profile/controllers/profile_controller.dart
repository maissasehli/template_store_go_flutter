import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/profile/services/user_api_service.dart';
import 'package:store_go/features/profile/user_model.dart';

class ProfileController extends GetxController {
  final UserApiService _userApiService;
  final logger = Logger();

  // Observable variables
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Constructor with dependency injection
  ProfileController(this._userApiService);

  @override
  void onInit() {
    super.onInit();
    fetchCurrentUser();
  }

  // Fetch current user data
  Future<void> fetchCurrentUser() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await _userApiService.getCurrentUser();

      if (response.statusCode == 200) {
        final userData = response.data['data'];
        user.value = UserModel.fromJson(userData);
        logger.i('User data fetched successfully: ${user.value?.name}');
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      logger.e('Error fetching user: $e');
      hasError.value = true;
      errorMessage.value = 'Failed to load profile. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh user data
  Future<void> refreshUserData() async {
    await fetchCurrentUser();
  }
}
