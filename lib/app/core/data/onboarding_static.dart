import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/features/onBoarding/models/onboarding_model.dart';

class OnboardingStatic {
  // Onboarding page data
  static final List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      mainTitle: 'Discover Seamless',
      boldTitle: 'Shopping!',
      subtitle: 'Fast Delivery, Easy Returns, And Endless Choices Await You',
      mainImage: AssetConfig.onBoardingHeaderMain,
      leftImage: AssetConfig.onBoardingHeaderLeft,
      rightImage: AssetConfig.onBoardingHeaderRight,
    ),
    // You can add more onboarding pages here if needed
  ];
}
