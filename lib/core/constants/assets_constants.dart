class ImageAsset {
  static const String rootImages = 'assets/images';
  static const String rootIcons = 'assets/icons';
  static const String rootSvgIcons = 'assets/icons/svg';

  // OnBoarding assets
  static const String onBoardingIconLogo = '$rootIcons/app_icon.png';
  static const String onBoardingIconBag = '$rootIcons/bag.png';
  static const String onBoardingHeaderMain = '$rootImages/fashion1.jpg';
  static const String onBoardingHeaderLeft = '$rootImages/fashion2.jpg';
  static const String onBoardingHeaderRight = '$rootImages/fashion.jpg';

  // Social Login Icons
  static const String appleIcon = '$rootSvgIcons/apple.svg';
  static const String googleIcon = '$rootSvgIcons/google.svg';
  static const String facebookIcon = '$rootSvgIcons/facebook.svg';

  // Email related
  static const String sendMail = '$rootIcons/email_sent.png';

  // Other icons
  static const String bagIcon = '$rootIcons/bag2.svg';
  static const String emailSentIcon = '$rootIcons/email_sent.svg';
  static const String heartIcon = '$rootIcons/heart.svg';
  static const String homeIcon = '$rootIcons/home2.svg';
  static const String profileIcon = '$rootIcons/profile.svg';
  static const String searchIcon = '$rootIcons/searchnormal1.svg';
  static const String heardIcon = '$rootIcons/heart.svg';
  static const String vectorIcon = '$rootIcons/Vector.svg';
  static const String icon = '$rootIcons/icon.svg';




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
  ];

  // Get all icons
  static List<String> get allIcons => [
    appleIcon,
    googleIcon,
    facebookIcon,
    sendMail,
    bagIcon,
    emailSentIcon,
    heartIcon,
    homeIcon,
    profileIcon,
    searchIcon,
  ];
}
