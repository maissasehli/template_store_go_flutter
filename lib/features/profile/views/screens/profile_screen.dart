import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/auth/services/auth_service.dart';
import 'package:store_go/features/profile/controllers/profile_controller.dart';
import 'package:store_go/features/profile/views/widgets/profile_main_widgets/profile_header.dart';
import 'package:store_go/features/profile/views/widgets/profile_main_widgets/user_details_card.dart';
import 'package:store_go/features/profile/views/widgets/profile_main_widgets/profile_menu_section.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  AuthService get authService => Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: AppColors.background(context),
      systemNavigationBarIconBrightness:
          brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: Scaffold(
        backgroundColor: AppColors.background(context),
        body: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return _buildLoadingState(context);
            }

            if (controller.hasError.value) {
              return _buildErrorState(context);
            }

            return _buildContent(context);
          }),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: AppColors.primary(context)),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            controller.errorMessage.value,
            style: TextStyle(color: AppColors.foreground(context)),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.fetchCurrentUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
            ),
            child: Text(
              'Retry',
              style: TextStyle(color: AppColors.primaryForeground(context)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.fetchCurrentUser,
      color: AppColors.primary(context),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Profile Header Section
              ProfileHeader(user: controller.user.value),
              // User Details Card
              UserDetailsCard(user: controller.user.value),
              const SizedBox(height: 24),
              // Menu Options
              ProfileMenuSection(authService: authService),
            ],
          ),
        ),
      ),
    );
  }
}
