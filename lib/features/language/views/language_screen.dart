import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/onBoarding/controllers/onboarding_controller.dart';
import 'package:store_go/app/core/config/theme/colors.dart';
import 'package:store_go/app/core/config/routes_constants.dart';
import 'package:store_go/app/core/localization/change_local.dart';
import 'package:store_go/features/language/views/widgets/custombuttomlang.widgets.dart';



class Language extends GetView<LocaleController> {
  const Language({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: AppColorExtension.languageCardBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Select Language'.tr,
          style: const TextStyle(
            color: AppColorExtension.languageCardTextPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildLanguageCard(
              title: 'English',
              subtitle: 'English',
              languageCode: 'en',
              icon: Icons.language,
            ),
            const SizedBox(height: 16),
            _buildLanguageCard(
              title: 'العربية',
              subtitle: 'Arabic',
              languageCode: 'ar',
              icon: Icons.language,
            ),
            const SizedBox(height: 16),
            _buildLanguageCard(
              title: 'Français',
              subtitle: 'French',
              languageCode: 'fr',
              icon: Icons.language,
            ),
            const Spacer(),
            CustomBottomLanguage(
              text: 'Continue'.tr,
              onPressed: () => Get.toNamed(AppRoute.onBoarding),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required String title,
    required String subtitle,
    required String languageCode,
    required IconData icon,
  }) {
    return GetBuilder<LocaleController>(
      builder: (controller) {
        bool isSelected = controller.language?.languageCode == languageCode;
        return Card(
          elevation: isSelected ? 8 : 2,
          shadowColor: isSelected
              ? AppColorExtension.languageCardSelectedBorder
              : Colors.black12,
          color: AppColorExtension.languageCardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: isSelected
                  ? AppColorExtension.languageCardSelectedBorder
                  : AppColorExtension.languageCardUnselectedBorder,
              width: 2,
            ),
          ),
          child: InkWell(
            onTap: () {
              controller.changeLang(languageCode);
            },
            borderRadius: BorderRadius.circular(15),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColorExtension.languageIconBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: AppColorExtension.languageIconForeground,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColorExtension.languageCardTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColorExtension.languageCardTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: AppColorExtension.languageContinueButtonBackground,
                      size: 24,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}