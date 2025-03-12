import 'package:flutter/material.dart';
import 'package:store_go/core/constants/assets_constants.dart';
import 'package:store_go/view/widgets/ui/cached_asset_image.dart';


class OnBoardingBgIcon extends StatelessWidget {
  final double? bottom;
  final double? top;
  final double? left;
  final double? right;
  final double size;
  final double rotationAngle;

  const OnBoardingBgIcon({
    super.key,
    this.bottom,
    this.top,
    this.left,
    this.right,
    required this.size,
    this.rotationAngle = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom != double.infinity ? bottom : null,
      top: top != double.infinity ? top : null,
      left: left != double.infinity ? left : null,
      right: right != double.infinity ? right : null,
      child: Transform.rotate(
        angle: rotationAngle * 3.14159 / 180,
        child: CachedAssetImage(
          imagePath: ImageAsset.onBoardingIconBag,
          width: size,
          height: size,
          color: Colors.white,
        ),
      ),
    );
  }
}
