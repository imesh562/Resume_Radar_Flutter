import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';

class MainMenuItem extends StatelessWidget {
  final Function() onTap;
  final String title;
  final String image;
  final Color? imageColor;
  final double? imageHeight;
  const MainMenuItem({
    required this.onTap,
    required this.title,
    required this.image,
    this.imageColor,
    this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 200.h,
        padding: EdgeInsets.all(
          10.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Stack(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: AppColors.matteBlack,
                height: 0,
                fontSize: AppDimensions.kFontSize24,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                children: [
                  SizedBox(height: 70.h),
                  Image.asset(
                    image,
                    height: imageHeight ?? 110.h,
                    color: imageColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
