class ImageAsset {
  static const String rootImages = 'assets/images';
  static const String rootIcons = 'assets/icons';

  // OnBoarding assets
  static const String onBoardingIconLogo = '$rootIcons/app_icon.png';
  static const String onBoardingIconBag = '$rootIcons/bag.png';
  static const String onBoardingHeaderMain = '$rootImages/fashion1.jpg';
  static const String onBoardingHeaderLeft = '$rootImages/fashion2.jpg';
  static const String onBoardingHeaderRight = '$rootImages/fashion.jpg';

  // Social Login Icons
  static const String appleIcon = '$rootIcons/apple.svg';
  static const String googleIcon = '$rootIcons/google.svg';
  static const String facebookIcon = '$rootIcons/facebook.svg';

  // Email related
  static const String sendMail = '$rootIcons/email_sent.png';

  // Get all onboarding images as a list
  static List<String> get allOnboardingImages => [
    onBoardingIconLogo,
    onBoardingIconBag,
    onBoardingHeaderMain,
    onBoardingHeaderLeft,
    onBoardingHeaderRight,
  ];

  // Get all auth images
  static List<String> get allAuthImages => [
    appleIcon,
    googleIcon,
    facebookIcon,
    sendMail,
  ];
}
