import 'package:store_go/core/constants/assets_constants.dart';
import 'package:store_go/core/model/onboarding/onboarding_model.dart';

class OnboardingStatic {
  // Onboarding page data
  static final List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      mainTitle: 'Discover Seamless',
      boldTitle: 'Shopping!',
      subtitle: 'Fast Delivery, Easy Returns, And Endless Choices Await You',
      mainImage: ImageAsset.onBoardingHeaderMain,
      leftImage: ImageAsset.onBoardingHeaderLeft,
      rightImage: ImageAsset.onBoardingHeaderRight,
    ),
    // You can add more onboarding pages here if needed
  ];
}