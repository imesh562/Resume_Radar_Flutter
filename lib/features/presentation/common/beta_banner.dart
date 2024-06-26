import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';

class BetaBanner extends StatelessWidget {
  final Widget child;
  static BannerConfig? bannerConfig;

  const BetaBanner({required this.child});

  @override
  Widget build(BuildContext context) {
    if (!AppConstants.isBeta) return child;
    bannerConfig ??= _getDefaultBanner();
    return Stack(
      children: <Widget>[
        child,
        Positioned(
          top: 0,
          right: 0,
          child: _buildBanner(context),
        )
      ],
    );
  }

  BannerConfig _getDefaultBanner() {
    return BannerConfig(
        bannerName: 'Beta', bannerColor: AppColors.declinedFillColor);
  }

  Widget _buildBanner(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: 50,
        height: 50,
        child: CustomPaint(
          painter: BannerPainter(
              message: bannerConfig!.bannerName,
              textDirection: Directionality.of(context),
              layoutDirection: Directionality.of(context),
              location: BannerLocation.topEnd,
              color: bannerConfig!.bannerColor),
        ),
      ),
    );
  }
}

class BannerConfig {
  final String bannerName;
  final Color bannerColor;

  BannerConfig({required this.bannerName, required this.bannerColor});
}
