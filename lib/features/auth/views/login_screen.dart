import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_color_utils.dart';
import 'package:store_go/features/auth/controllers/oauth_controller.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/auth/controllers/login_controller.dart';
import 'package:store_go/app/core/utils/alert_exit_app.dart';
import 'package:store_go/app/shared/extensions/buttons/primary_button.dart';
import 'package:store_go/app/shared/extensions/buttons/secondary_icon_text_button.dart';
import 'package:store_go/app/shared/extensions/buttons/text_button.dart';
import 'package:store_go/app/shared/extensions/fields/validated_fields.dart';
import 'package:store_go/app/shared/extensions/text_extensions.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';

class Login extends GetView<LoginController> {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final OAuthController oauthController = Get.put(OAuthController());
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
                      const Text('log in').heading2(context),
                      const SizedBox(height: 40),
                      "Email Address".emailField(
                        context,
                        fieldState: controller.emailFieldState,
                      ),
                      const SizedBox(height: 20),
                      "Password".passwordField(
                        context,
                        fieldState: controller.passwordFieldState,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {},
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => const Text('Continue').primaryButton(
                          context,
                          onPressed: controller.login,
                          isLoading: controller.isLoading.value,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Dont have an Account?'),
                          const Text('Create One').textButton(
                            context,
                            onPressed: controller.goToSignUp,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: Divider(color: colors.secondary)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('or').body(context),
                          ),
                          Expanded(child: Divider(color: colors.secondary)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Google Sign-In Button with loading state
                      Obx(
                        () => const Text(
                          'Continue With Google',
                        ).secondaryIconTextButton(
                          context,
                          onPressed:
                              oauthController.isLoading.value
                                  ? () {} // Empty function instead of null
                                  : () => oauthController.signInWithProvider(
                                    'google',
                                  ),
                          icon:
                              oauthController.isLoading.value
                                  ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  )
                                  : ThemeAwareSvg(
                                    onlyFill: false,
                                    assetPath: AssetConfig.googleIcon,
                                    colorName: AppColorName.primary,
                                  ),
                          alignContentLeft: true,
                          // Add an enabled parameter if your button extension supports it
                          enabled: !oauthController.isLoading.value,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Apple Sign-In Button with loading state
                      Obx(
                        () => const Text(
                          'Continue With Apple',
                        ).secondaryIconTextButton(
                          context,
                          onPressed: () {},
                          icon:
                              oauthController.isLoading.value
                                  ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  )
                                  : ThemeAwareSvg(
                                    assetPath: AssetConfig.appleIcon,
                                    colorName: AppColorName.primary,
                                  ),
                          alignContentLeft: true,
                          enabled: false,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Facebook Sign-In Button with loading state
                      Obx(
                        () => const Text(
                          'Continue With Facebook',
                        ).secondaryIconTextButton(
                          context,
                          onPressed: () {},
                          icon:
                              oauthController.isLoading.value
                                  ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  )
                                  : ThemeAwareSvg(
                                    onlyFill: false,
                                    assetPath: AssetConfig.facebookIcon,
                                    colorName: AppColorName.primary,
                                  ),
                          alignContentLeft: true,
                          enabled: false,
                        ),
                      ),
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
