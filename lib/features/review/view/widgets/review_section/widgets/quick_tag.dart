import 'package:flutter/material.dart';

class QuickTag extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const QuickTag({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(  // Fixed: Changed 'Boxeration' to 'BoxDecoration'
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, fontFamily: 'Poppins', color: Colors.black87),
        ),
      ),
    );
  }
}