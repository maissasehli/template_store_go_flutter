import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:store_go/features/orders/controllers/order_controller.dart';

class OrderStatusTabsRow extends StatelessWidget {
  final StoreOrdersController controller;
  
  const OrderStatusTabsRow({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: controller.availableStatuses.map((status) {
          return Obx(() => StatusTabItem(
            status: status,
            isSelected: controller.selectedStatus.value == status,
            onTap: () => controller.setSelectedStatus(status),
          ));
        }).toList(),
      ),
    );
  }
}

class StatusTabItem extends StatelessWidget {
  final String status;
  final bool isSelected;
  final VoidCallback onTap;

  const StatusTabItem({
    Key? key,
    required this.status,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
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
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}