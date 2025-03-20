import 'package:flutter/material.dart';
import 'package:store_go/app/core/config/theme/ui.dart';
import 'package:store_go/features/home/models/size_variant_model.dart';

class SizeSelector extends StatelessWidget {
  final List<SizeVariantModel> sizes;
  final String? selectedSizeId;
  final Function(String) onSizeSelected;

  const SizeSelector({
    Key? key,
    required this.sizes,
    required this.selectedSizeId,
    required this.onSizeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Size',
              style: TextStyle(
                fontSize: UIConstants.fontSizeMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Show size guide dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Size Guide'),
                    content: Container(
                      width: double.maxFinite,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Sizing information for this product.'),
                          // Add size chart here
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                'Size Guide',
                style: TextStyle(
                  fontSize: UIConstants.fontSizeSmall,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: sizes.map((size) {
              final isSelected = size.id == selectedSizeId;
              final isAvailable = size.isAvailable;
              
              return GestureDetector(
                onTap: isAvailable ? () => onSizeSelected(size.id) : null,
                child: Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.only(right: UIConstants.paddingSmall),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : isAvailable
                            ? Colors.white
                            : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(UIConstants.borderRadiusSmall),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : isAvailable
                              ? Colors.grey.shade300
                              : Colors.grey.shade200,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    size.name,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : isAvailable
                              ? Colors.black
                              : Colors.grey,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}