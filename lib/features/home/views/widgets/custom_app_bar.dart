import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/theme/app_color_extension.dart';
import 'package:store_go/app/shared/widgets/universal_cached_image.dart';
import 'package:store_go/features/profile/controllers/profile_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(String)? onSearch;
  final ProfileController profileController;
  
  const CustomAppBar({
    super.key, 
    this.onSearch, 
    required this.profileController
  });

  @override
  Widget build(BuildContext context) {
    // Get theme extensions for colors
    final colors = Theme.of(context).extension<AppColorExtension>()!;
    
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: colors.background,
      title: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colors.border, 
                width: 1
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular / 2),
              child: Obx(
                () => UniversalCachedImage(
                  imagePath: profileController.user.value?.avatar ?? "",
                  source: ImageSource.network,
                ),
              )
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: UIConfig.paddingMedium),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              AssetConfig.bag,
              colorFilter: ColorFilter.mode(
                colors.primaryForeground,
                BlendMode.srcIn,
              ),
              width: 16,
              height: 16,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}