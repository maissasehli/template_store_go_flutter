import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/assets_constants.dart';
import 'package:store_go/core/constants/ui.dart';
import 'package:store_go/controller/auth/login_controller.dart';
import 'package:store_go/core/functions/alert_exit_app.dart';
import 'package:store_go/view/widgets/extensions/buttons/primary_button.dart';
import 'package:store_go/view/widgets/extensions/buttons/secondary_icon_text_button.dart';
import 'package:store_go/view/widgets/extensions/buttons/text_button.dart';
import 'package:store_go/view/widgets/extensions/fields/validated_fields.dart';
import 'package:store_go/view/widgets/extensions/text_extensions.dart';
import 'package:store_go/view/widgets/ui/theme_aware_svg.dart';
import 'package:store_go/view/widgets/ui/theme_toggle.dart';

class Login extends GetView<LoginController> {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Show the exit confirmation dialog when the user presses the back button
        return await alertExitApp(context);
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(actions: [ThemeToggle()]),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: controller.loginFormKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: UIConstants.paddingLarge,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 60),
                      const Text('log in').heading1(context),
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
                          const Text(
                            'Create One',
                          ).textButton(context, onPressed: controller.goToSignUp),
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
                      const Text('Continue With Google').secondaryIconTextButton(
                        context,
                        onPressed: () => {debugPrint('google')},
                        icon: ThemeAwareSvg(
                          assetPath: ImageAsset.googleIcon,
                          color: colors.primary,
                        ),
                        alignContentLeft: true,
                      ),
                        const SizedBox(height: 20),
                      // Apple Sign-In Button with loading state
                      const Text('Continue With Apple').secondaryIconTextButton(
                        context,
                        onPressed: () {},
                        icon: ThemeAwareSvg(
                          assetPath: ImageAsset.appleIcon,
                          color: colors.primary,
                          onlyFill: true,
                        ),
                        alignContentLeft: true,
                      ),
                      const SizedBox(height: 20),
                      // Facebook Sign-In Button with loading state
                      const Text(
                        'Continue With Facebook',
                      ).secondaryIconTextButton(
                        context,
                        onPressed: () {},
                        icon: ThemeAwareSvg(
                          assetPath: ImageAsset.facebookIcon,
                          color: colors.primary,
                        ),
                        alignContentLeft: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
          
      ));
  }
}
