import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/data/onboarding_static.dart';
import 'package:store_go/app/core/services/image_preloader_manager.dart';
import 'package:store_go/app/shared/extensions/text_extensions.dart';
import 'package:store_go/features/onBoarding/views/widgets/onboarding_bg_icon.dart';
import 'package:store_go/features/onBoarding/views/widgets/onboarding_carousel_image.dart';
import 'package:store_go/features/onBoarding/controllers/onboarding_controller.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();
  final ImagePreloaderManager _preloaderManager =
      Get.find<ImagePreloaderManager>();
  int _currentPage = 0;
  bool _imagesLoaded = false;

  @override
  void initState() {
    super.initState();
    _preloadImages();
  }

  Future<void> _preloadImages() async {
    // Gather all image paths from the onboarding pages
    final List<String> imagePaths = [];

    for (final page in OnboardingStatic.pages) {
      imagePaths.add(page.mainImage);
      imagePaths.add(page.leftImage);
      imagePaths.add(page.rightImage);
    }

    // Preload all images at once
    await _preloaderManager.preloadScreenImages(context, imagePaths);

    // Also preload auth images to prepare for the next screens
    await _preloaderManager.preloadAuthImages(context);

    if (mounted) {
      setState(() {
        _imagesLoaded = true;
      });
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

    if (!_imagesLoaded) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // You could show your app logo here
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 20),
              const Text('Getting ready...').heading1(context),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          itemCount: OnboardingStatic.pages.length,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
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
                    SizedBox(
                      height: mainImageHeight,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // Left image (partially visible)
                          Positioned(
                            left: -screenWidth * 0.1,
                            child: OnboardingCarouselImage(
                              imagePath: page.leftImage,
                              width: sideImageWidth,
                              height: sideImageHeight,
                            ),
                          ),
                          // Right image (partially visible)
                          Positioned(
                            right: -screenWidth * 0.1,
                            child: OnboardingCarouselImage(
                              imagePath: page.rightImage,
                              width: sideImageWidth,
                              height: sideImageHeight,
                            ),
                          ),
                          // Main image (centered)
                          Center(
                            child: OnboardingCarouselImage(
                              imagePath: page.mainImage,
                              width: mainImageWidth,
                              height: mainImageHeight,
                            ),
                          ),
                        ],
                      ),
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

                          // Fixed spacing instead of Spacer for predictable layout
                          const SizedBox(height: 80.0),

                          // Get Started button
                          ElevatedButton(
                            onPressed: () {
                              if (_currentPage <
                                  OnboardingStatic.pages.length - 1) {
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
                              _currentPage < OnboardingStatic.pages.length - 1
                                  ? 'Next'
                                  : 'Get Started',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10.0),

                          // Sign in option
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
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

                    // Bottom spacing
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
