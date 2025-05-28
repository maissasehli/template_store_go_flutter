class AppRoute {
  // define that the this class has no constructor
  AppRoute._();
  static const String settings = "/settings";
  static const String products = "/products";
  static const String mainContainer = "/main";
  static const String language = "/language";
  static const String settingsLanguage = "/settings-language";
  static const String onBoarding = "/onboarding";
  static const String login = "/login";
  static const String signup = "/signup";
  static const String profileSetup = "/profile-setup";
  static const String forgetPassword = "/forget-password";
  static const String emailConfirmation = "/emailConfirmation";
  static const String resetPassword = '/reset-password';
  static const String emailResetPasswordConfirmation =
      "/email-reset-password-confirmation";

  // Home and navigation
  static const String home = "/home";

  // Category routes
  static const String categories = "/categories";
  static const String categoryDetail = "/category/:id";

  // Product routes
  static const String productDetail = "/product/:id";
  static const String featuredProducts =
      "/products/featured"; // Optional, for specific lists
  static const String newProducts =
      "/products/new"; // Optional, for specific lists
  // Cart and checkout
  static const String cart = "/cart";
  static const String addCart = "/add-cart";
  static const String checkout = "/checkout";
  static const String paymentProcessing = "/payment-processing";
  static const String orderConfirmation = "/order-confirmation";
  static const String orderFailure = "/order-failure";

  // User profile
  static const String editProfile = "/edit-profile";
  static const String profile = "/profile";
  static const String orders = "/orders";
  static const String wishlist = "/wishlist";

  // Review routes
  static const String reviews = "/reviews/:productId";
  static const String verifyOtp = "/verify-otp";
  static const String resetPasswordNew = "/reset-password-new";

  // Public routes
  static const List<String> publicRoutes = [
    language,
    onBoarding,
    login,
    signup,
    forgetPassword,
    verifyOtp,
    resetPasswordNew,
  ];
  static const String address = "/address";
  static const String addAddress = "/add-address";
  static const String editAddress = "/edit-address";
  static const String orderDetails = "/order-details";
  static const String payments = "/payments";
  static const String addPayment = "/add-payment";
  static const String editPayment = "/edit-payment";
  static const String paymentHistory = "/payment-history";
  static const String paymentSuccess = "/payment-success";
  static const String paymentFailure = "/payment-failure";
  static const String notifications = "/notifications";
  static const String filter = "/filter";
  static const String subcategoryProducts = '/subcategory-products';
  static const String promotionProducts = '/promotion-products';

}
