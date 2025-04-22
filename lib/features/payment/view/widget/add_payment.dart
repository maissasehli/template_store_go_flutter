import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/payment/controller/payment_controller.dart';
import 'package:uuid/uuid.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({Key? key}) : super(key: key);

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final PaymentController controller = Get.find<PaymentController>();
  final _formKey = GlobalKey<FormState>();
  
  // Form fields
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  
  @override
  void dispose() {
    _cardNumberController.dispose();
    _cvvController.dispose();
    _expiryController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  String _maskCardNumber(String cardNumber) {
    if (cardNumber.length < 4) return cardNumber;
    return '**** ' + cardNumber.substring(cardNumber.length - 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'Add Card',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Card Number Field
                      _buildTextField(
                        hint: 'Card Number',
                        controller: _cardNumberController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter card number';
                          }
                          if (value.length < 16) {
                            return 'Please enter a valid card number';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        isRounded: true,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // CVV and Expiry in a row
                      Row(
                        children: [
                          // CVV Field
                          Expanded(
                            child: _buildTextField(
                              hint: 'CVV',
                              controller: _cvvController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter CVV';
                                }
                                return null;
                              },
                              obscureText: true,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Expiry Field
                          Expanded(
                            child: _buildTextField(
                              hint: 'Exp',
                              controller: _expiryController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter expiry';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.datetime,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Cardholder Name Field
                      _buildTextField(
                        hint: 'Cardholder Name',
                        controller: _cardHolderController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter cardholder name';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              // Save Button at bottom of screen
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 24, top: 8),
                child: TextButton(
                  onPressed: _saveCard,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    bool obscureText = false,
    TextInputType? keyboardType,
    bool isRounded = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.black45,
          fontSize: 14,
        ),
        fillColor: const Color(0xFFF5F5F5),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: isRounded 
              ? BorderRadius.circular(30)  
              : BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black12, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: isRounded 
              ? BorderRadius.circular(30)
              : BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black12, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: isRounded 
              ? BorderRadius.circular(30)
              : BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black12, width: 0.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        errorStyle: const TextStyle(height: 0), // Cache le texte d'erreur
      ),
      cursorColor: Colors.black26,  // Curseur en gris clair
    );
  }

  void _saveCard() {
    if (_formKey.currentState!.validate()) {
      final uuid = const Uuid().v4();
      final maskedNumber = _maskCardNumber(_cardNumberController.text);
      
      controller.addPaymentMethod(
        PaymentMethodModel(
          id: uuid,
          type: 'card',
          maskedNumber: maskedNumber,
          cardType: 'mastercard', // Par défaut mastercard
        ),
      );
    }
  }
}