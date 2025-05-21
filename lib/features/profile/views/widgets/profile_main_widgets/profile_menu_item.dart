import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/theme/app_color_utils.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';

class ProfileMenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRtl = LocalizationService.isRtl(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: SvgPicture.asset(
          icon,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            AppColors.mutedForeground(context),
            BlendMode.srcIn,
          ),
        ),
        title: Text(
          title,
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.foreground(context),
            ),
          ),
        ),
        trailing: ThemeAwareSvg(
          assetPath: isRtl ? AssetConfig.arrowLeft : AssetConfig.arrowRight,
          height: 24,
          width: 24,
          colorName: AppColorName.foreground,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
