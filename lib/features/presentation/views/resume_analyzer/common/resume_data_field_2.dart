import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';

class ResumeDataField2 extends StatelessWidget {
  const ResumeDataField2({
    super.key,
    required this.fieldName,
    required this.fieldValue,
  });

  final String fieldName;
  final String fieldValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldName,
          style: TextStyle(
            fontSize: AppDimensions.kFontSize16,
            fontWeight: FontWeight.w600,
            color: AppColors.matteBlack,
          ),
        ),
        Text(
          fieldValue,
          style: TextStyle(
            fontSize: AppDimensions.kFontSize16,
            fontWeight: FontWeight.w400,
            color: AppColors.matteBlack,
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
