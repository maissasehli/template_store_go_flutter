import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:store_go/core/constants/assets_constants.dart';
import 'package:store_go/view/widgets/ui/theme_toggle.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(String)? onSearch;
  
  const CustomAppBar({
    Key? key,
    this.onSearch,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          ThemeToggle(),
          // Avatar/profile image
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                'assets/images/profile_avatar.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      actions: [
Container(
  margin: const EdgeInsets.only(right: 16),
  width: 40,
  height: 40,
  decoration: const BoxDecoration(
    color: Colors.black,
    shape: BoxShape.circle,
  ),
  child: Center(  // Center the icon in the container
    child: SvgPicture.asset(
      ImageAsset.bagIcon,
      color: Colors.white,
      width: 16, 
      height: 16,  
    ),
  ),
)
      ],
    );
  }
  
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}