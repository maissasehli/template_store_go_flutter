import 'package:flutter/material.dart';
import 'package:store_go/core/constants/imageasset.dart';
import 'package:store_go/core/model/onboarding/onboarging_page_model.dart';

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