import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/ui_config.dart';

class SkeletonAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const SkeletonAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  SkeletonAnimationState createState() => SkeletonAnimationState();
}

class SkeletonAnimationState extends State<SkeletonAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class SkeletonContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const SkeletonContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  factory SkeletonContainer.circular({
    double? width,
    double? height,
    double radius = 8,
  }) =>
      SkeletonContainer(
        width: width,
        height: height,
        borderRadius: BorderRadius.circular(radius),
      );

  factory SkeletonContainer.rectangular({
    double? width,
    double? height,
  }) =>
      SkeletonContainer(
        width: width,
        height: height,
        borderRadius: const BorderRadius.all(Radius.circular(0)),
      );

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class CategorySkeletonLoader extends StatelessWidget {
  const CategorySkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      padding: const EdgeInsets.symmetric(horizontal: UIConfig.paddingMedium),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: UIConfig.paddingSmall),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SkeletonContainer.circular(
                width: 60,
                height: 60,
                radius: 30,
              ),
              const SizedBox(height: 8),
              SkeletonContainer.rectangular(
                width: 50,
                height: 12,
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProductSkeletonLoader extends StatelessWidget {
  final bool isHorizontal;

  const ProductSkeletonLoader({
    super.key,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return _buildHorizontalLoader();
    } else {
      return _buildGridLoader();
    }
  }

  Widget _buildHorizontalLoader() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        padding: const EdgeInsets.symmetric(
          horizontal: UIConfig.paddingMedium,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: UIConfig.paddingMedium),
            child: _buildProductSkeletonCard(),
          );
        },
      ),
    );
  }

  Widget _buildGridLoader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIConfig.paddingMedium),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return _buildProductSkeletonCard();
        },
      ),
    );
  }

  Widget _buildProductSkeletonCard() {
    return Container(
      width: 160,
      clipBehavior: Clip.antiAlias, // Add this to prevent overflow
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use LayoutBuilder to get available space
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Add this to prevent vertical overflow
            children: [
              SkeletonContainer.circular(
                width: constraints.maxWidth, // Use available width
                height: constraints.maxWidth * 0.95, // Proportional height
                radius: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(UIConfig.paddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Add this to prevent vertical overflow
                  children: [
                    SkeletonContainer.rectangular(
                      width: constraints.maxWidth * 0.75, // Use percentage of available width
                      height: 16,
                    ),
                    const SizedBox(height: 8),
                    SkeletonContainer.rectangular(
                      width: constraints.maxWidth * 0.5, // Use percentage of available width
                      height: 14,
                    ),
                    const SizedBox(height: 8),
                    // Fix the row overflow
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Use this instead of Spacer
                      children: [
                        SkeletonContainer.rectangular(
                          width: constraints.maxWidth * 0.45, // Use percentage
                          height: 12,
                        ),
                        SkeletonContainer.circular(
                          width: 24,
                          height: 24,
                          radius: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}