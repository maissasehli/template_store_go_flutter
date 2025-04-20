class AppRoute {
  static const String settings = "/settings";
  static const String products = "/products";
  static const String mainContainer = "/main";
  static const String language = "/language";
  static const String onBoarding = "/onboarding";
  static const String login = "/login";
  static const String signup = "/signup";
  static const String profileSetup = "/profile-setup";
  static const String forgetPassword = "/forget-password";
  static const String emailConfirmation = "/emailConfirmation";
  static const String resetPassword = '/reset-password';
  static const String emailResetPasswordConfirmation = "/email-reset-password-confirmation";

  // Home and navigation
  static const String home = "/home";
  
  // Category routes
  static const String categories = "/categories";
  static const String categoryDetail = "/category/:id";
  
  // Product routes
  static const String productDetail = "/product/:id";
  static const String featuredProducts = "/products/featured";
  static const String newProducts = "/products/new";
  
  // Cart and checkout
  static const String cart = "/cart";
  static const String addCart = "/add-cart"; // Changed from add_cart
  static const String checkout = "/checkout";
  
  // User profile
  static const String editProfile = "/edit-profile"; // Changed from edit_profile
  static const String profile = "/profile";
  static const String orders = "/orders";
  static const String wishlist = "/wishlist";

  // Review routes
  static const String reviews = "/reviews/:productId"; // New route for reviews

  // Public routes
  static const List<String> publicRoutes = [
    language,
    onBoarding,
    login,
    signup,
    forgetPassword,
  ];
  static const String address = "/address";
  static const String addAddress = "/add-address"; // Changed from add_address
  static const String editAddress = "/edit-address"; // Changed from edit_address
  static const String orderDetails = "/order-details"; // Changed from order_details
  static const String payments = "/payments";
  static const String addPayment = "/add-payment"; // Changed from add_payment
  static const String editPayment = "/edit-payment"; // Changed from edit_payment
  static const String notifications = "/notifications";
  static const String filter = "/filter";
  static const String subcategoryProducts = '/subcategory-products';
}