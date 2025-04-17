import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/payment/controller/payment_controller.dart' show PaymentController, PaymentMethodModel;
import 'package:uuid/uuid.dart';

class AddPaypalPage extends StatefulWidget {
  const AddPaypalPage({Key? key}) : super(key: key);

  @override
  State<AddPaypalPage> createState() => _AddPaypalPageState();
}

class _AddPaypalPageState extends State<AddPaypalPage> {
  final PaymentController controller = Get.find<PaymentController>();
  final _formKey = GlobalKey<FormState>();
  
  // Form fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
          'Add PayPal',
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
                      
                      // Email Field
                      _buildTextField(
                        hint: 'PayPal Email',
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your PayPal email';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        isRounded: true,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Password Field
                      _buildTextField(
                        hint: 'Password',
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Additional Info
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black12, width: 0.5),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.black54, size: 18),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Your credentials are securely stored and used only for payment processing.',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                  onPressed: _savePaypal,
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
        color: Colors.black45,  // Texte saisi en gris, pas en noir
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

  void _savePaypal() {
    if (_formKey.currentState!.validate()) {
      final uuid = const Uuid().v4();
      
      controller.addPaymentMethod(
        PaymentMethodModel(
          id: uuid,
          type: 'paypal',
          email: _emailController.text,
        ),
      );
    }
  }
}