import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:store_go/core/constants/assets_constants.dart';
import 'package:store_go/core/constants/ui.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  
  const CustomSearchBar({
    super.key,
    required this.onSearch,
  });
  
  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.paddingMedium),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SvgPicture.asset(
                ImageAsset.searchIcon,
                colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                height: 16,
                width: 16,
              )
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onSubmitted: widget.onSearch,
                textInputAction: TextInputAction.search,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            // Add clear button
            if (_controller.text.isNotEmpty)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    _controller.clear();
                    widget.onSearch('');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.clear, size: 16, color: Colors.grey.shade600),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}