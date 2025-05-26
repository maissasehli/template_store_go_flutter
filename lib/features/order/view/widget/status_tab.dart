// File: lib/features/order/views/widgets/status_tab.dart

import 'package:flutter/material.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

class StatusTab extends StatelessWidget {
  final String status;
  final bool isSelected;
  final VoidCallback onTap;

  const StatusTab({
    super.key,
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRtl = LocalizationService.isRtl(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: isRtl ? 12 : 0, right: isRtl ? 0 : 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          status,
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
