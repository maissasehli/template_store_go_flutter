class AssetConfig {
  // Root paths for assets
  static const String rootImages = 'assets/images';
  static const String rootIcons = 'assets/icons';
  static const String rootSvg = 'assets/svg';

  // Navbar icons
  static const String homeIcon = '$rootSvg/home.svg';
  static const String heartIcon = '$rootSvg/Heart.svg';
  static const String profileIcon = '$rootSvg/profile.svg';
  static const String panierIcon = '$rootSvg/panier.svg';

  // Onboarding assets
  static const String onBoardingIconLogo = '$rootIcons/app_icon.png';
  static const String onBoardingIconBag = '$rootIcons/bag.png';
  static const String onBoardingHeaderMain = '$rootImages/fashion1.jpg';
  static const String onBoardingHeaderLeft = '$rootImages/fashion2.jpg';
  static const String onBoardingHeaderRight = '$rootImages/fashion.jpg';

  // Social login icons
  static const String appleIcon = '$rootSvg/apple.svg';
  static const String googleIcon = '$rootSvg/google.svg';
  static const String facebookIcon = '$rootSvg/facebook.svg';

  // Email-related assets
  static const String sendMail = '$rootIcons/email_sent.png';
  static const String checkout = '$rootIcons/check-out.png';

  // General icons
  static const String bagIcon = '$rootSvg/bag2.svg';
  static const String emailSentIcon = '$rootSvg/email_sent.svg';
  static const String searchIcon = '$rootSvg/searchIcon.svg';
  static const String discountShape = '$rootSvg/discountShape.svg';
  static const String delete = '$rootSvg/delete.svg';
  static const String arrowRight2 = '$rootSvg/arrowRight2.svg';
  static const String setting = '$rootSvg/setting-2.svg';
  static const String receipt = '$rootSvg/receipt1.svg';
  static const String filter = '$rootSvg/filter.svg';
  static const String notification = '$rootSvg/notification.svg';
  static const String bell = '$rootIcons/bell 1.png';
  static const String logout = '$rootSvg/logout.svg'; 
  static const String location = '$rootSvg/location.svg';
  static const String success = '$rootSvg/success_icon.svg'; 
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