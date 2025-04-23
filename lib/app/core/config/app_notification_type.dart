class AppNotificationType {
  // Private constructor prevents instantiation
  AppNotificationType._();

  // Define all notification types as static constants
  static const String orderStatusUpdate = 'order_status_update';
  static const String deliveryUpdate = 'delivery_update';
  static const String paymentConfirmation = 'payment_confirmation';
  static const String priceDrop = 'price_drop';
  static const String backInStock = 'back_in_stock';
  static const String newPromotion = 'new_promotion';
  static const String orderShipped = 'order_shipped';
  static const String reviewReminder = 'review_reminder';
  static const String welcomeMessage = 'welcome_message';
  static const String cartReminder = 'cart_reminder';
  static const String personalizedOffer = 'personalized_offer';
  static const String returnStatusUpdate = 'return_status_update';
  static const String newProduct = 'new_product';

  // List of all values (useful for validation)
  static const List<String> values = [
    orderStatusUpdate,
    deliveryUpdate,
    paymentConfirmation,
    priceDrop,
    backInStock,
    newPromotion,
    orderShipped,
    reviewReminder,
    welcomeMessage,
    cartReminder,
    personalizedOffer,
    returnStatusUpdate,
    newProduct,
  ];
}
