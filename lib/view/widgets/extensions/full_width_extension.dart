import 'package:flutter/material.dart';

extension FullWidthExtension on Widget {
  Widget fullWidth() {
    return SizedBox(width: double.infinity, child: this);
  }
}
