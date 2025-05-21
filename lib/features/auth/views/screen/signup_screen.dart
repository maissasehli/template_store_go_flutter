import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/features/auth/controllers/signup_controller.dart';
import 'package:store_go/app/core/theme/colors.dart';
import 'package:store_go/app/core/utils/alert_exit_app.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/shared/extensions/buttons/primary_button.dart';
import 'package:store_go/app/shared/extensions/fields/validated_fields.dart';
import 'package:store_go/app/shared/extensions/text_extensions.dart';

class Signup extends GetView<SignupController> {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isRtl = LocalizationService.isRtl(context);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => await alertExitApp(context),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.background(context),
          appBar: AppBar(
            backgroundColor: AppColors.background(context),
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon:
                  LocalizationService.isRtl(context)
                      ? ThemeAwareSvg(
                        assetPath: AssetConfig.arrowRight,
                        height: 24,
                        width: 24,
                      )
                      : ThemeAwareSvg(
                        assetPath: AssetConfig.arrowLeft,
                        height: 24,
                        width: 24,
                      ),
              onPressed: () => Get.back(),
            ),
          ),
          body: SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return Form(
                key: controller.signupFormKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppColor.spacingM,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        Text('auth.signup'.translate()).heading3(context),
                        const SizedBox(height: 20),
                        // First Name Field
                        'auth.first_name'.translate().textField(
                          context,
                          fieldState: controller.firstNameFieldState,
                        ),
                        const SizedBox(height: 20),
                        // Last Name Field
                        'auth.last_name'.translate().textField(
                          context,
                          fieldState: controller.lastNameFieldState,
                        ),
                        const SizedBox(height: 20),
                        // Email Field
                        'auth.email'.translate().emailField(
                          context,
                          fieldState: controller.emailFieldState,
                        ),
                        const SizedBox(height: 20),
                        // Password Field
                        'auth.password'.translate().passwordField(
                          context,
                          fieldState: controller.passwordFieldState,
                        ),
                        const SizedBox(height: 20),
                        // Signup Button
                        Text(
                          'common.continue'.translate(),
                          style: LocalizationService.getLocalizedTextStyle(
                            context,
                            const TextStyle(),
                          ),
                        ).primaryButton(
                          context,
                          onPressed: controller.signUp,
                          isLoading: controller.isLoading.value,
                        ),
                        const SizedBox(height: 20),

                        // Already have account row - fixed for RTL
                        Align(
                          alignment:
                              isRtl
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // LTR order (text first, then login link)
                              Text(
                                'auth.already_have_account'.translate(),
                                style:
                                    LocalizationService.getLocalizedTextStyle(
                                      context,
                                      const TextStyle(fontSize: 14),
                                    ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: Text(
                                  'auth.login'.translate(),
                                  style:
                                      LocalizationService.getLocalizedTextStyle(
                                        context,
                                        TextStyle(
                                          color: AppColors.primary(context),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
