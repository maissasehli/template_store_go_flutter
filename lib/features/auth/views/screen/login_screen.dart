import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/auth/controllers/login_controller.dart';
import 'package:store_go/app/core/utils/alert_exit_app.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/shared/extensions/buttons/primary_button.dart';
import 'package:store_go/app/shared/extensions/buttons/text_button.dart';
import 'package:store_go/app/shared/extensions/fields/validated_fields.dart';
import 'package:store_go/app/shared/extensions/text_extensions.dart';

class Login extends GetView<LoginController> {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    // Make sure controller is properly initialized
    controller.reinitializeIfNeeded();

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Show the exit confirmation dialog when the user presses the back button
        return await alertExitApp(context);
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: controller.loginFormKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: UIConfig.paddingLarge,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 60),
                      // Apply NotoKufiArabic font to the title through heading2 extension
                      Text('auth.login'.translate()).heading2(context),
                      const SizedBox(height: 40),
                      // Email field with appropriate font through extension
                      'auth.email'.translate().emailField(
                        context,
                        fieldState: controller.emailFieldState,
                      ),
                      const SizedBox(height: 20),
                      // Password field with appropriate font through extension
                      'auth.password'.translate().passwordField(
                        context,
                        fieldState: controller.passwordFieldState,
                      ),
                      const SizedBox(height: 10),
                      // Forgot password with Arabic font
                      Align(
                        alignment: LocalizationService.getStartAlignment(context),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoute.forgetPassword);
                          },
                          child: Text(
                            'auth.forgot_password'.translate(),
                            style: LocalizationService.getLocalizedTextStyle(
                              context,
                              const TextStyle(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Continue button with Arabic font
                      Obx(
                        () => Text(
                          'common.continue'.translate(),
                          style: LocalizationService.getLocalizedTextStyle(
                            context,
                            const TextStyle(),
                          ),
                        ).primaryButton(
                          context,
                          onPressed: controller.login,
                          isLoading: controller.isLoading.value,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Don't have an account row with Arabic font
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'auth.dont_have_account'.translate(),
                            style: LocalizationService.getLocalizedTextStyle(
                              context,
                              const TextStyle(),
                            ),
                          ),
                          Text(
                            'auth.create_one'.translate(),
                            style: LocalizationService.getLocalizedTextStyle(
                              context,
                              const TextStyle(),
                            ),
                          ).textButton(
                            context,
                            onPressed: controller.goToSignUp,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
