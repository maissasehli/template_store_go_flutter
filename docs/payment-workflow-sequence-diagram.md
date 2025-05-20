# Payment Workflow Sequence Diagram

This diagram illustrates the complete payment flow in the StoreGo mobile app, from adding an item to cart through checkout and payment processing with Stripe.

```mermaid
sequenceDiagram
    participant User
    participant MobileApp as Flutter Mobile App
    participant AppAPI as StoreGo API
    participant Stripe
    participant Database

    %% Add to Cart Flow
    User->>MobileApp: Select product and add to cart
    MobileApp->>AppAPI: POST /api/mobile-app/products/cart/:productId
    AppAPI->>Database: Check product availability
    Database-->>AppAPI: Product available
    AppAPI->>Database: Add to cart
    AppAPI-->>MobileApp: Return updated cart
    MobileApp-->>User: Show updated cart

    %% Apply Promotions Flow
    User->>MobileApp: View Cart / Begin Checkout
    MobileApp->>AppAPI: POST /api/mobile-app/cart/check-promotions
    AppAPI->>Database: Find applicable promotions
    Database-->>AppAPI: Return promotions
    AppAPI-->>MobileApp: Return eligible promotions
    MobileApp-->>User: Display available promotions

    opt User selects promotion
        User->>MobileApp: Select promotion
        MobileApp->>AppAPI: POST /api/mobile-app/checkout/apply-promotion
        AppAPI->>Database: Validate & apply promotion
        Database-->>AppAPI: Return updated prices
        AppAPI-->>MobileApp: Return discount details
        MobileApp-->>User: Show discounted total
    end

    %% Checkout Flow
    User->>MobileApp: Proceed to checkout
    MobileApp-->>User: Display shipping & payment form
    User->>MobileApp: Enter shipping address & payment details

    %% Payment Processing
    Note over MobileApp: Using Flutter Stripe SDK
    MobileApp->>MobileApp: Collect card details securely
    MobileApp->>Stripe: Create Payment Method
    Stripe-->>MobileApp: Return Payment Method ID

    MobileApp->>AppAPI: POST /api/mobile-app/payments/process
    Note right of MobileApp: Send payment method ID, order ID, amount

    AppAPI->>Stripe: Create Payment Intent

    alt Payment requires authentication (3D Secure)
        Stripe-->>AppAPI: Requires additional authentication
        AppAPI-->>MobileApp: Return client_secret & status="requires_action"
        MobileApp->>Stripe: Handle Next Action (3D Secure)
        Stripe->>User: Display 3D Secure authentication
        User->>Stripe: Complete authentication
        Stripe-->>MobileApp: Authentication result
        MobileApp->>AppAPI: Check payment status
        AppAPI->>Stripe: Check Payment Intent status
        Stripe-->>AppAPI: Final payment status
    else No authentication required
        Stripe-->>AppAPI: Payment intent succeeded
    end

    alt Payment successful
        AppAPI->>Database: Create payment record
        AppAPI->>Database: Create order
        AppAPI->>Database: Clear cart items
        Database-->>AppAPI: Confirmation
        AppAPI-->>MobileApp: Return success & order details
        MobileApp-->>User: Display order confirmation
    else Payment failed
        AppAPI-->>MobileApp: Return error details
        MobileApp-->>User: Show payment failure
    end

    %% Webhook handling (asynchronous)
    Stripe--)AppAPI: Send webhook events
    Note over AppAPI: Process payment_intent.succeeded
    Note over AppAPI: Or payment_intent.payment_failed
    AppAPI->>Database: Update payment/order status if needed
```

## Key Components in the Payment Flow

### Client-Side (Flutter Mobile App)

- Securely collects payment information using Flutter Stripe SDK
- Creates payment method token without sending card details to server
- Handles 3D Secure authentication when required
- Displays appropriate success or error messages to user

### Server-Side (StoreGo API)

- Validates request data including order details and payment information
- Creates payment intent with Stripe using customer's payment method
- Processes the payment and handles success/failure scenarios
- Records payment in database and updates order status
- Implements webhook handlers for asynchronous payment events

### Stripe

- Processes the payment securely
- Handles card authentication (3D Secure) when required
- Sends webhook events for payment status updates
- Provides tools for refunds and payment management

### Database

- Stores cart items, orders, and payment records
- Tracks payment status and order fulfillment
- Associates payments with orders and customers

## Error Handling

The sequence diagram includes error handling for payment failures. Additional error scenarios not shown in the diagram include:

1. **Card declined**: Stripe returns specific error code and message
2. **Network failures**: App implements retry mechanism
3. **Expired payment sessions**: System detects and requests new payment method
4. **Server-side validation failures**: API returns appropriate error codes

## Security Considerations

- JWT authentication for all API calls
- Tokenized payment methods (card details never touch StoreGo servers)
- HTTPS for all communications
- Idempotency keys to prevent duplicate charges
- Webhook signature verification
