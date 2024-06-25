import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppRectangleShimmer extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  final double? borderRadius;

  AppRectangleShimmer(
      {required this.color,
      required this.width,
      required this.height,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: color.withOpacity(.8),
      highlightColor: color.withOpacity(.4),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color.withOpacity(.8),
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
        ),
      ),
    );
  }
}
