import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/theme/app_color_extension.dart';
import 'package:store_go/app/core/theme/app_typography_extension.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  
  const CustomSearchBar({super.key, required this.onSearch});
  
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
    // Get theme extensions for colors and typography
    final colors = Theme.of(context).extension<AppColorExtension>()!;
    final typography = Theme.of(context).extension<AppTypographyExtension>()!;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIConfig.paddingMedium),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: colors.input,
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular / 2),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: UIConfig.paddingSmall + 2),
              child: SvgPicture.asset(
                AssetConfig.searchIcon,
                colorFilter: ColorFilter.mode(
                  colors.mutedForeground,
                  BlendMode.srcIn,
                ),
                height: 16,
                width: 16,
              ),
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: FocusNode(),
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular / 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular / 2),
                  ),
                  hintStyle: typography.bodySmall.copyWith(
                    color: colors.mutedForeground,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: UIConfig.paddingSmall),
                ),
                onSubmitted: widget.onSearch,
                onChanged: widget.onSearch,
                textInputAction: TextInputAction.search,
                style: typography.bodySmall.copyWith(
                  color: colors.inputForeground,
                ),
              ),
            ),
            if (_controller.text.isNotEmpty)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
                  onTap: () {
                    _controller.clear();
                    widget.onSearch('');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(UIConfig.paddingSmall / 2),
                    child: Icon(
                      Icons.clear,
                      size: 16,
                      color: colors.mutedForeground,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}