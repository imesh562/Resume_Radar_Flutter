import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';

class ResumeDataField extends StatelessWidget {
  const ResumeDataField({
    super.key,
    required this.fieldName,
    required this.fieldValue,
  });

  final String fieldName;
  final String fieldValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fieldName,
              style: TextStyle(
                fontSize: AppDimensions.kFontSize18,
                fontWeight: FontWeight.w700,
                color: AppColors.matteBlack,
              ),
            ),
            Expanded(
              child: Text(
                fieldValue,
                style: TextStyle(
                  fontSize: AppDimensions.kFontSize18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.matteBlack,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
