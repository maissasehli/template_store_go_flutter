import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_color_extension.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/theme/app_theme.dart';
import 'package:store_go/features/search/views/search_page.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final String initialValue;
  
  const CustomSearchBar({
    super.key,
    required this.onSearch,
    this.initialValue = '',
  });
  
  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorExtension>()!;

    return GestureDetector(
      onTap: () {
        // Unfocus the text field when tapping outside of it
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: UIConfig.paddingMedium),
        child: Container(
          height: 40, // Increased height for better vertical padding
          decoration: BoxDecoration(
            color: colors.input,
            borderRadius: BorderRadius.circular(AppTheme.globalInputsRadius),
            border: Border.all(
              color: _isFocused ? colors.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment
                    .center, // Ensure everything is centered vertically
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SvgPicture.asset(
                  AssetConfig.searchIcon,
                  colorFilter: ColorFilter.mode(
                    colors.inputForeground,
                    BlendMode.srcIn,
                  ),
                  height: 16,
                  width: 16,
                ),
              ),
              Expanded(
                child: Center(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true, // Helps with vertical centering
                      hintStyle: TextStyle(
                        color: colors.mutedForeground,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                      contentPadding: EdgeInsets.zero, // Remove all padding
                    ),
                    onSubmitted: (value) {
                      // Navigate to search page when search button on keyboard is pressed
                      Get.to(() => SearchPage(initialQuery: value));
                    },
                    // Removing onChanged to prevent requests on each keystroke
                    textInputAction: TextInputAction.search,
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.inputForeground,
                    ),
                  ),
                ),
              ),
              if (_controller.text.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min, // Take only the space needed
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Align vertically centered
                  children: [
                    // Clear button
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
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.clear,
                            size: 16,
                            color: colors.mutedForeground,
                          ),
                        ),
                      ),
                    ), // Search button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          // Only trigger search when the button is pressed
                          widget.onSearch(_controller.text);
                          Get.to(
                            () => SearchPage(initialQuery: _controller.text),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Icon(
                            Icons.search,
                            size: 18,
                            color: colors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}