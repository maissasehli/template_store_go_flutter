class AssetConfig {
  static const String rootImages = 'assets/images';
  static const String rootIcons = 'assets/icons';
  static const String rootSvg = 'assets/svg';
  // navbar icons
  static const String homeIcon = '$rootSvg/home.svg';
  static const String heartIcon = '$rootSvg/Heart.svg';
  static const String profileIcon = '$rootSvg/profile.svg';
  static const String panierIcon = '$rootSvg/panier.svg';
  // OnBoarding assets
  static const String onBoardingIconLogo = '$rootIcons/app_icon.png';
  static const String onBoardingIconBag = '$rootIcons/bag.png';
  static const String onBoardingHeaderMain = '$rootImages/fashion1.jpg';
  static const String onBoardingHeaderLeft = '$rootImages/fashion2.jpg';
  static const String onBoardingHeaderRight = '$rootImages/fashion.jpg';

  // Social Login Icons
  static const String appleIcon = '$rootSvg/apple.svg';
  static const String googleIcon = '$rootSvg/google.svg';
  static const String facebookIcon = '$rootSvg/facebook.svg';

  // Email related
  static const String sendMail = '$rootIcons/email_sent.png';
  static const String checkout = '$rootIcons/check-out.png';

  static const String bagIcon = '$rootSvg/bag2.svg';
  static const String emailSentIcon = '$rootSvg/email_sent.svg';

  static const String searchIcon = '$rootSvg/searchnormal1.svg';
  static const String discountshape = '$rootSvg/discountshape.svg';
  static const String delete = '$rootSvg/delete.svg';
  static const String arrowright2 = '$rootSvg/arrowright2.svg';

  static const String setting = '$rootSvg/setting-2.svg';
  static const String receipt = '$rootSvg/receipt1.svg';
    static const String filter = '$rootSvg/filter.svg';

  static const String notification = '$rootSvg/notificationbing.svg';
  static const String bell = '$rootIcons/bell 1.png';

  static const String Logout = '$rootSvg/Logout.svg';
  static const String location = '$rootSvg/location.svg';
  static const String Success = '$rootSvg/Success Icon.svg';

    static const String search = '$rootIcons/search.png';
        static const String reviews = '$rootIcons/review.png';



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
