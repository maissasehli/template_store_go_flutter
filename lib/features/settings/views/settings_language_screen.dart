import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/shared/extensions/buttons/primary_button.dart';
import 'package:store_go/app/shared/extensions/full_width_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/features/settings/controllers/settings_language_controller.dart';
import 'package:store_go/features/settings/views/widgets/settings_language_card.dart';

class SettingsLanguageScreen extends GetView<SettingsLanguageController> {
  const SettingsLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        title: Text(
          'language.select_a_language'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              color: AppColors.foreground(context),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: ThemeAwareSvg(
            assetPath:
                LocalizationService.isRtl(context)
                    ? AssetConfig.arrowRight
                    : AssetConfig.arrowLeft,
            height: 24,
            width: 24,
          ),
          onPressed: () => Get.back(),
        ),
        actions: null,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Explanation text with proper font styling
            Text(
              'language.explanation'.translate(),
              style: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(
                  color: AppColors.mutedForeground(context),
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 24), // Language list
            Expanded(
              child: GetBuilder<SettingsLanguageController>(
                builder: (controller) {
                  return ListView.separated(
                    itemCount: LocalizationService.languages.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final language = LocalizationService.languages[index];
                      return SettingsLanguageCard(
                        title: language["nativeName"],
                        subtitle: language["name"],
                        languageCode: language["code"],
                        icon: language["icon"],
                        isSelected:
                            controller.currentLanguage.value ==
                            language["code"],
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Save button with appropriate font styling
            Text(
                  'common.save'.translate(),
                  style: LocalizationService.getLocalizedTextStyle(
                    context,
                    const TextStyle(),
                  ),
                )
                .primaryButton(
                  context,
                  onPressed: () => controller.saveAndReturn(),
                )
                .fullWidth(),
          ],
        ),
      ),
    );
  }
}
