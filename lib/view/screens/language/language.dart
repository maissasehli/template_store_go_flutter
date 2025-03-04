import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/color.dart';
import 'package:store_go/core/localization/changelocal.dart';
import 'package:store_go/view/widgets/Language/custombuttomlang.dart';

class Language extends GetView<LocaleController> {
  const Language({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Select Language'.tr,
          style: const TextStyle(
            color: AppColors.primary,
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
          shadowColor:
              isSelected ? AppColors.primaryShadow : Colors.black12,
          color: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
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
                      color: AppColors.primaryWithOpacity,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.primary,
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
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
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