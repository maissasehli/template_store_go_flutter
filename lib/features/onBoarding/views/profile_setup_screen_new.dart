import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/shared/extensions/buttons/primary_button.dart';
import 'package:store_go/features/onBoarding/controllers/profile_setup_controller.dart';
import 'package:store_go/app/core/theme/colors.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/shared/extensions/text_extensions.dart';
import 'package:store_go/features/onBoarding/views/widgets/gender_button.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileSetupController controller = Get.put(ProfileSetupController());

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppColor.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    'Tell us About yourself',
                    textAlign: TextAlign.center,
                  ).heading3(context),

                  const SizedBox(height: 40),

                  Text('Who do you shop for?').body(context),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      GenderButton(
                        selectedGender: controller.selectedGender,
                        text: 'Men',
                        gender: 'Homme',
                        onGenderSelected: controller.selectGender,
                      ),
                      const SizedBox(width: 15),
                      GenderButton(
                        selectedGender: controller.selectedGender,
                        text: 'Women',
                        gender: 'Femme',
                        onGenderSelected: controller.selectGender,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text("How Old are you?").body(context),
                  const SizedBox(height: 15),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.input(context),
                      borderRadius: BorderRadius.circular(
                        AppColor.globalBorderRadius,
                      ),
                    ),
                    child: Obx(
                      () => DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text(
                            'Age Range',
                            style: TextStyle(
                              color: AppColors.mutedForeground(context),
                            ),
                          ),
                          value: controller.selectedAgeRange.value,
                          items:
                              controller.ageRanges.map((String range) {
                                return DropdownMenuItem<String>(
                                  value: range,
                                  child: Text(
                                    range,
                                    style: TextStyle(
                                      color: AppColors.inputForeground(context),
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: controller.selectAgeRange,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.mutedForeground(context),
                          ),
                          style: TextStyle(
                            color: AppColors.inputForeground(context),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  Obx(
                    () => Text(
                      'Finish',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ).primaryButton(
                      context,
                      onPressed:
                          controller.isFormValid
                              ? controller.finishUserProfileSetup
                              : () {},
                      isLoading: controller.isLoading.value,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            // Back Button
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.foreground(context),
                ),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
