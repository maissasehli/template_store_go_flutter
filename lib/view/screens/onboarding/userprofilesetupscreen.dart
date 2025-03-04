import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/controller/onboarding/userprofilesetupcontroller.dart';
import 'package:store_go/core/constants/color.dart';

class UserProfileSetupScreen extends StatelessWidget {
  const UserProfileSetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProfileSetupController controller = 
        Get.put(UserProfileSetupController());

    return Scaffold(
      backgroundColor: AppColor.primaryColor,
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
                    style: AppColor.titleLarge.copyWith(
                      color: AppColor.textPrimaryColor,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  
                  Text(
                    'Who do you shop for?',
                    style: AppColor.bodyMedium.copyWith(
                      color: AppColor.textSecondaryColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  Row(
                    children: [
                      _buildGenderButton(controller, 'Men', 'Homme'),
                      const SizedBox(width: 15),
                      _buildGenderButton(controller, 'Women', 'Femme'),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  Text(
                    'How Old are you?',
                    style: AppColor.bodyMedium.copyWith(
                      color: AppColor.textSecondaryColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColor.inputBackgroundColor,
                      borderRadius: BorderRadius.circular(AppColor.globalBorderRadius),
                    ),
                    child: Obx(() => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text(
                          'Age Range',
                          style: TextStyle(color: AppColor.inputTextColor),
                        ),
                        value: controller.selectedAgeRange.value,
                        items: controller.ageRanges.map((String range) {
                          return DropdownMenuItem<String>(
                            value: range,
                            child: Text(range),
                          );
                        }).toList(),
                        onChanged: controller.selectAgeRange,
                        style: TextStyle(color: AppColor.textPrimaryColor),
                      ),
                    )),
                  ),
                  
                  const Spacer(),
                  
                  Obx(() => Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: controller.isFormValid 
                        ? AppColor.secondaryColor 
                        : Colors.grey[300],
                      borderRadius: BorderRadius.circular(AppColor.globalBorderRadius),
                    ),
                    child: ElevatedButton(
                      onPressed: controller.isFormValid 
                        ? controller.finishUserProfileSetup 
                        : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppColor.globalBorderRadius),
                        ),
                      ),
                      child: Text(
                        'Finish',
                        style: TextStyle(
                          color: controller.isFormValid 
                            ? Colors.white 
                            : Colors.grey[500],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            
            // Back Button
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColor.textPrimaryColor),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderButton(
    UserProfileSetupController controller, 
    String text, 
    String gender
  ) {
    return Expanded(
      child: Obx(() => Container(
        decoration: BoxDecoration(
          color: controller.selectedGender.value == gender 
            ? AppColor.secondaryColor 
            : Colors.white,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(AppColor.globalBorderRadius),
        ),
        child: ElevatedButton(
          onPressed: () => controller.selectGender(gender),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppColor.globalBorderRadius),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: controller.selectedGender.value == gender 
                ? Colors.white 
                : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      )),
    );
  }
}