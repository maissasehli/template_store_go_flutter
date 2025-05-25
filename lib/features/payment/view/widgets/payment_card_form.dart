import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

class PaymentCardForm extends StatefulWidget {
  final Function(Map<String, dynamic>)? onCardChanged;
  final Function()? onSubmit;
  final bool enabled;

  const PaymentCardForm({
    Key? key,
    this.onCardChanged,
    this.onSubmit,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<PaymentCardForm> createState() => _PaymentCardFormState();
}

class _PaymentCardFormState extends State<PaymentCardForm> {
  CardEditController? _cardController;
  bool _cardComplete = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Information',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CardField(
            onCardChanged: (card) {
              setState(() {
                _cardComplete = card?.complete ?? false;
              });

              if (card != null && widget.onCardChanged != null) {
                widget.onCardChanged!({
                  'complete': card.complete,
                  'number': card.number,
                  'cvc': card.cvc,
                  'expiryMonth': card.expiryMonth,
                  'expiryYear': card.expiryYear,
                });
              }
            },
            enablePostalCode: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintText: 'Enter card details',
              hintStyle: TextStyle(color: Colors.grey.shade500),
            ),
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.lock_outline, size: 16, color: Colors.grey.shade600),
            SizedBox(width: 4),
            Text(
              'Your payment information is secure and encrypted',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        if (widget.onSubmit != null) ...[
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  (_cardComplete && widget.enabled) ? widget.onSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Pay Now',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Map<String, dynamic>? get cardDetails {
    if (!_cardComplete) return null;

    // Return card details that can be used with Stripe SDK
    return {'complete': _cardComplete};
  }

  bool get isComplete => _cardComplete;
}

class PaymentMethodPicker extends StatefulWidget {
  final Function(String?)? onPaymentMethodSelected;
  final List<Map<String, dynamic>> savedMethods;

  const PaymentMethodPicker({
    Key? key,
    this.onPaymentMethodSelected,
    this.savedMethods = const [],
  }) : super(key: key);

  @override
  State<PaymentMethodPicker> createState() => _PaymentMethodPickerState();
}

class _PaymentMethodPickerState extends State<PaymentMethodPicker> {
  String? _selectedMethodId;
  bool _useNewCard = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),

        // Saved payment methods
        if (widget.savedMethods.isNotEmpty) ...[
          ...widget.savedMethods.map((method) => _buildSavedMethodTile(method)),
          SizedBox(height: 8),
        ],

        // Add new card option
        _buildNewCardTile(),
      ],
    );
  }

  Widget _buildSavedMethodTile(Map<String, dynamic> method) {
    final isSelected = _selectedMethodId == method['id'] && !_useNewCard;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethodId = method['id'];
          _useNewCard = false;
        });
        widget.onPaymentMethodSelected?.call(method['id']);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.credit_card,
              color:
                  isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade600,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${method['brand']} •••• ${method['last4']}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Expires ${method['exp_month']}/${method['exp_year']}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Radio<bool>(
              value: false,
              groupValue: _useNewCard,
              onChanged: (value) {
                setState(() {
                  _selectedMethodId = method['id'];
                  _useNewCard = false;
                });
                widget.onPaymentMethodSelected?.call(method['id']);
              },
              activeColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewCardTile() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _useNewCard = true;
          _selectedMethodId = null;
        });
        widget.onPaymentMethodSelected?.call(null);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                _useNewCard
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade300,
            width: _useNewCard ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.add_card,
              color:
                  _useNewCard
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade600,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Add new card',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            Radio<bool>(
              value: true,
              groupValue: _useNewCard,
              onChanged: (value) {
                setState(() {
                  _useNewCard = true;
                  _selectedMethodId = null;
                });
                widget.onPaymentMethodSelected?.call(null);
              },
              activeColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  bool get useNewCard => _useNewCard;
  String? get selectedMethodId => _selectedMethodId;
}
