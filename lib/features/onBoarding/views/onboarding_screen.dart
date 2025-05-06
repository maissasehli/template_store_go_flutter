import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/data/onboarding_static.dart';
import 'package:store_go/app/core/services/enhanced_image_cache.dart';
import 'package:store_go/app/core/services/image_preloader_manager.dart';
import 'package:store_go/app/shared/extensions/text_extensions.dart';
import 'package:store_go/features/onBoarding/views/widgets/onboarding_bg_icon.dart';
import 'package:store_go/features/onBoarding/views/widgets/onboarding_carousel_image.dart';
import 'package:store_go/features/onBoarding/controllers/onboarding_controller.dart';
import 'package:store_go/features/onBoarding/views/widgets/skeleton_animation.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();
  final ImagePreloaderManager _preloaderManager = Get.find<ImagePreloaderManager>();
  final RxInt _currentPage = 0.obs;
  
  // Clear cache on start to ensure skeleton animations are visible for demo
  @override
  void initState() {
    super.initState();
    
    // Clear any existing cache to ensure we see the skeletons
    Get.find<EnhancedImageCache>().clearAllImages();
    
    // Start preloading with a delay to see the skeletons
    Future.delayed(const Duration(milliseconds: 500), () {
      _preloadImages();
    });
  }
Future<void> _preloadImages() async {
  final List<String> imagePaths = [];

  for (final page in OnboardingStatic.pages) {
    imagePaths.add(page.mainImage);
    imagePaths.add(page.leftImage);
    imagePaths.add(page.rightImage);
  }

  for (final path in imagePaths) {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return; // Check if the widget is still mounted
    await Get.find<EnhancedImageCache>().cacheAssetImage(context, path);
  }

  if (mounted) {
    await _preloaderManager.preloadAuthImages(context);
  }
}

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    // Get the screen width to calculate image dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    double mainImageWidth = screenWidth * 0.80;
    double sideImageWidth = screenWidth * 0.16;
    double sideImageHeight = 210.0;
    double mainImageHeight = 230.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          itemCount: OnboardingStatic.pages.length,
          onPageChanged: (index) {
            _currentPage.value = index;
          },
          itemBuilder: (context, index) {
            final page = OnboardingStatic.pages[index];

            return Stack(
              children: [
                // Background "bag" icons with absolute positioning
                const OnBoardingBgIcon(
                  size: 110,
                  top: 20,
                  right: -40,
                  rotationAngle: -30,
                ),
                const OnBoardingBgIcon(
                  size: 180,
                  bottom: -50,
                  left: -80,
                  rotationAngle: 15,
                ),
                const OnBoardingBgIcon(
                  size: 130,
                  bottom: 300,
                  left: -50,
                  rotationAngle: 30,
                ),
                const OnBoardingBgIcon(
                  size: 150,
                  bottom: 100,
                  right: -55,
                  rotationAngle: -20,
                ),
                const OnBoardingBgIcon(
                  size: 80,
                  bottom: 300,
                  right: -30,
                  rotationAngle: -18,
                ),

                // Main content with proper layout structure
                Column(
                  children: [
                    const SizedBox(height: 60.0), // Top spacing
                    // Image carousel with three images
                   OnboardingImageCarousel(
                      mainImage: page.mainImage,
                      leftImage: page.leftImage,
                      rightImage: page.rightImage,
                    ),

                    const SizedBox(height: 80.0),

                    // Main text content and buttons with proper padding
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          Text(
                            page.mainTitle,
                            style: const TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            page.boldTitle,
                            style: const TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          // Subtitle
                          Text(
                            page.subtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white70,
                            ),
                          ),

                          const SizedBox(height: 80.0),

                          // Get Started button
                          Obx(() => ElevatedButton(
                            onPressed: () {
                              if (_currentPage.value < OnboardingStatic.pages.length - 1) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                controller.navigateToLogin();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: Text(
                              _currentPage.value < OnboardingStatic.pages.length - 1
                                  ? 'Next'
                                  : 'Get Started',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),

                          const SizedBox(height: 10.0),

                          // Sign in option
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have account?',
                                style: TextStyle(color: Colors.white60),
                              ),
                              TextButton(
                                onPressed: controller.nextPage,
                                child: const Text(
                                  'Sign in',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}