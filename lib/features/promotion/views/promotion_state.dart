import 'package:get/get.dart';
import 'package:store_go/features/promotion/models/promotion_model.dart';

class PromotionState {
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<Promotion> productPromotions = <Promotion>[].obs;
  final RxInt currentPromotionIndex = 0.obs;
  final RxBool isPromotionSheetOpen = false.obs;
  final Rx<Promotion?> selectedPromotion = Rx<Promotion?>(null);

  void setLoading(bool loading) {
    isLoading.value = loading;
  }

  void setError(String message) {
    hasError.value = true;
    errorMessage.value = message;
  }

  void clearError() {
    hasError.value = false;
    errorMessage.value = '';
  }

  void setProductPromotions(List<Promotion> promotions) {
    productPromotions.value = promotions;
    currentPromotionIndex.value = 0;
  }

  void clearPromotions() {
    productPromotions.clear();
    currentPromotionIndex.value = 0;
  }

  void setCurrentPromotionIndex(int index) {
    if (index >= 0 && index < productPromotions.length) {
      currentPromotionIndex.value = index;
    }
  }

  void nextPromotion() {
    if (productPromotions.isNotEmpty) {
      currentPromotionIndex.value = 
          (currentPromotionIndex.value + 1) % productPromotions.length;
    }
  }

  void previousPromotion() {
    if (productPromotions.isNotEmpty) {
      currentPromotionIndex.value = 
          (currentPromotionIndex.value - 1 + productPromotions.length) % productPromotions.length;
    }
  }

  void togglePromotionSheet() {
    isPromotionSheetOpen.value = !isPromotionSheetOpen.value;
  }

  void openPromotionSheet() {
    isPromotionSheetOpen.value = true;
  }

  void closePromotionSheet() {
    isPromotionSheetOpen.value = false;
  }

  void setSelectedPromotion(Promotion promotion) {
    selectedPromotion.value = promotion;
  }

  void clearSelectedPromotion() {
    selectedPromotion.value = null;
  }
}