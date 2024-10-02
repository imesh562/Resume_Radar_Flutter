import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../data/models/responses/get_quizzes_response.dart';

class QuizComponent extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback onTap;

  const QuizComponent({
    Key? key,
    required this.quiz,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.colorImagePlaceholder.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quiz.title ?? '',
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: AppDimensions.kFontSize16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.matteBlack,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    quiz.description ?? '',
                    maxLines: 2,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: AppDimensions.kFontSize14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textFieldTitleColor,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                    decoration: BoxDecoration(
                      color: AppColors.colorWhite,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'Skill: ${quiz.skill}',
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: AppDimensions.kFontSize12,
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
