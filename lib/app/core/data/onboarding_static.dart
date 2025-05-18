import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/features/onBoarding/models/onboarding_model.dart';

class OnboardingStatic {
  // Onboarding page data
  static List<OnboardingPageModel> get pages {
    // Get the full string and split it for display
    final String discoverShopping = 'onboarding.discover_shopping'.translate();
    final List<String> words = discoverShopping.split(' ');

    // For more language-friendly splitting, use the first word as mainTitle
    // and the rest as boldTitle
    final String mainTitle = words.isNotEmpty ? words[0] : '';
    final String boldTitle = words.length > 1 ? words.sublist(1).join(' ') : '';

    return [
      OnboardingPageModel(
        mainTitle: mainTitle,
        boldTitle: boldTitle,
        subtitle: 'onboarding.fast_delivery'.translate(),
        mainImage: AssetConfig.onBoardingHeaderMain,
        leftImage: AssetConfig.onBoardingHeaderLeft,
        rightImage: AssetConfig.onBoardingHeaderRight,
      ),
      // You can add more onboarding pages here if needed
    ];
  }
}
