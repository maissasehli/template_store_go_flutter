import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/shared/extensions/buttons/primary_button.dart';
import 'package:store_go/app/shared/extensions/full_width_extension.dart';
import 'package:store_go/app/shared/widgets/theme_toggle.dart';
import 'package:store_go/features/language/controllers/language_controller.dart';
import 'package:store_go/features/language/views/widgets/language_card.dart';

class LanguageScreen extends GetView<LanguageController> {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'language.select_a_language'.translate(),
          style: TextStyle(
            color: AppColors.foreground(context),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [ThemeToggle()],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Moved Obx to only wrap the part that needs reactivity
            Expanded(
              child: ListView.separated(
                itemCount: controller.languages.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final language = controller.languages[index];
                  // Use Obx only where you need reactivity
                  return Obx(
                    () => LanguageCard(
                      title: language["nativeName"],
                      subtitle: language["name"],
                      languageCode: language["code"],
                      icon: language["icon"],
                      isSelected:
                          controller.currentLanguage.value ==
                          language["code"],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text("common.continue".translate())
                .primaryButton(
                  context,
                  onPressed: () => controller.onSaveLanguage(context),
                )
                .fullWidth(),
          ],
        ),
      ),
    );
  }
}
