import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/services/enhanced_image_cache.dart';

class OnboardingImageSlider extends StatefulWidget {
  final List<String> imagePaths;
  final int currentIndex;
  final Function(int) onPageChanged;

  const OnboardingImageSlider({
    Key? key,
    required this.imagePaths,
    required this.currentIndex,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  State<OnboardingImageSlider> createState() => _OnboardingImageSliderState();
}

class _OnboardingImageSliderState extends State<OnboardingImageSlider> {
  late PageController _pageController;
  final enhancedCache = Get.find<EnhancedImageCache>();

  Future<bool> isImageCached(String imagePath) async {
    return true; // or your actual implementation
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.currentIndex,
      viewportFraction: 0.90, // Fine-tuned for better centering
    );
  }

  @override
  void didUpdateWidget(OnboardingImageSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _pageController.animateToPage(
        widget.currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width to calculate width
    final screenWidth = MediaQuery.of(context).size.width;
    // Make the image width match viewport fraction
    final imageWidth = screenWidth * 0.90;
    // Use 9:16 aspect ratio
    final imageHeight = imageWidth * 9 / 16;

    // Calculate additional padding needed for scale transform
    final scaleFactor = 1.0;
    final extraPadding = screenWidth * (1 - scaleFactor) / 2;

    return Padding(
      // Add horizontal padding to prevent clipping after scaling
      padding: EdgeInsets.symmetric(horizontal: extraPadding),
      child: Transform.scale(
        scale: scaleFactor,
        child: SizedBox(
          height: imageHeight + 60,
          // Use ClipRect to ensure no overflow
          child: ClipRect(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.imagePaths.length,
              onPageChanged: widget.onPageChanged,
              padEnds: true, // Enable padding for better centering
              physics:
                  const BouncingScrollPhysics(), // Add bouncy physics for better feel
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 0.0;
                    if (_pageController.position.haveDimensions) {
                      value = index.toDouble() - (_pageController.page ?? 0);
                      value = (value.abs() * 0.3).clamp(0.0, 1.0);
                    }

                    // Reduce the scale difference so inactive images are more visible
                    final double scaleFactor = 1.0 - (value * 0.20);

                    return Center(
                      child: Transform.scale(
                        scale: scaleFactor,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: 1.0 - (value * 0.4),
                            child: Container(
                            // Remove negative margin and use zero margin instead
                            margin: EdgeInsets.zero,
                            alignment: Alignment.bottomCenter, // Added alignment
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: FutureBuilder<bool>(
                              future: Future.value(
                              enhancedCache.isImageCached(
                                widget.imagePaths[index],
                              ),
                              ),
                              builder: (context, snapshot) {
                                final isCached = snapshot.data ?? false;

                                return isCached
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(16.0),
                                      child: Image.asset(
                                        widget.imagePaths[index],
                                        fit: BoxFit.cover,
                                        width: imageWidth,
                                        height: imageHeight,
                                      ),
                                    )
                                    : Container(
                                      height: imageHeight,
                                      width: imageWidth,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.grey[300]!,
                                            Colors.grey[100]!,
                                            Colors.grey[300]!,
                                          ],
                                        ),
                                      ),
                                    );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
