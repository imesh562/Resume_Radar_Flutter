import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resume_radar/features/presentation/bloc/user/user_bloc.dart';
import 'package:resume_radar/utils/app_dimensions.dart';
import 'package:sharpapi_flutter_client/src/hr/models/parse_resume_model.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../../common/appbar.dart';
import '../base_view.dart';

class RecommendationAndOtherInfoView extends BaseView {
  final ParseResumeModel resumeData;
  RecommendationAndOtherInfoView({
    super.key,
    required this.resumeData,
  });
  @override
  State<RecommendationAndOtherInfoView> createState() =>
      _RecommendationAndOtherInfoViewState();
}

class _RecommendationAndOtherInfoViewState
    extends BaseViewState<RecommendationAndOtherInfoView> {
  var bloc = injection<UserBloc>();
  double overallScore = 0;
  List<String> improvements = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      overallScore = calculateOverallScore(widget.resumeData);
      improvements.addAll(generateResumeImprovements(widget.resumeData));
    });
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      resizeToAvoidBottomInset: false,
      appBar: ResumeRadarAppBar(
        title: 'Score & Recommendations',
      ),
      body: BlocProvider<UserBloc>(
        create: (_) => bloc,
        child: BlocListener<UserBloc, BaseState<UserState>>(
          listener: (_, state) {},
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Overall Score',
                          style: TextStyle(
                            fontSize: AppDimensions.kFontSize22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.matteBlack,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        CircleAvatar(
                          radius: 60.r,
                          backgroundColor: AppColors.primaryGreen,
                          child: Text(
                            '${overallScore.toInt()}',
                            style: TextStyle(
                              fontSize: AppDimensions.kFontSize42,
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    'Improvements to Make',
                    style: TextStyle(
                      fontSize: AppDimensions.kFontSize20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.matteBlack,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  improvements.isNotEmpty
                      ? ListView.builder(
                          itemCount: improvements.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Icon(
                                Icons.warning,
                                color: AppColors.errorRed,
                                size: 25.h,
                              ),
                              title: Text(
                                improvements[index],
                                style: TextStyle(
                                  fontSize: AppDimensions.kFontSize16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.matteBlack,
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            'No improvements needed!\nYour resume is great.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: AppDimensions.kFontSize16,
                              color: AppColors.waitingTimeColor,
                              fontWeight: FontWeight.w500,
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

  double calculateOverallScore(ParseResumeModel resume) {
    double score = 0;

    // Education Score (Out of 30)
    if (resume.educationQualifications != null) {
      int educationCount = resume.educationQualifications!.length;
      score += (educationCount > 0) ? (educationCount * 10).clamp(0, 30) : 0;
    }

    // Positions Score (Out of 30)
    if (resume.positions != null) {
      int positionsCount = resume.positions!.length;
      score += (positionsCount > 0) ? (positionsCount * 10).clamp(0, 30) : 0;
    }

    // Certifications Score (Out of 15)
    if (resume.candidateCoursesAndCertifications != null) {
      int certificationsCount =
          resume.candidateCoursesAndCertifications!.length;
      score += (certificationsCount > 0)
          ? (certificationsCount * 5).clamp(0, 15)
          : 0;
    }

    // Languages Score (Out of 10)
    if (resume.candidateSpokenLanguages != null) {
      int languagesCount = resume.candidateSpokenLanguages!.length;
      score += (languagesCount > 0) ? (languagesCount * 2).clamp(0, 10) : 0;
    }

    // Honors and Awards Score (Out of 15)
    if (resume.candidateHonorsAndAwards != null) {
      int awardsCount = resume.candidateHonorsAndAwards!.length;
      score += (awardsCount > 0) ? (awardsCount * 5).clamp(0, 15) : 0;
    }

    // Ensuring the score is capped at 100
    return score.clamp(0, 100);
  }

  List<String> generateResumeImprovements(ParseResumeModel resume) {
    List<String> improvements = [];

    // Check Education
    if (resume.educationQualifications == null ||
        resume.educationQualifications!.length < 2) {
      improvements.add(
          'Consider adding more educational qualifications or pursuing higher education.');
    }

    // Check Positions
    if (resume.positions == null || resume.positions!.length < 2) {
      improvements.add(
          'Gain more work experience or update the resume with more recent positions.');
    } else {
      DateTime now = DateTime.now();
      for (var position in resume.positions!) {
        DateTime? endDate =
            position.endDate != null ? DateTime.parse(position.endDate!) : null;
        if (endDate != null &&
            endDate.isBefore(now.subtract(const Duration(days: 730)))) {
          improvements.add(
              'Add more recent positions or update the end date of current positions.');
          break;
        }
      }
    }

    // Check Certifications
    if (resume.candidateCoursesAndCertifications == null ||
        resume.candidateCoursesAndCertifications!.isEmpty) {
      improvements.add(
          'Consider pursuing relevant certifications to enhance your resume.');
    }

    // Check Languages
    if (resume.candidateSpokenLanguages == null ||
        resume.candidateSpokenLanguages!.length < 2) {
      improvements.add(
          'Consider learning additional languages to enhance your global employability.');
    }

    // Check Honors and Awards
    if (resume.candidateHonorsAndAwards == null ||
        resume.candidateHonorsAndAwards!.isEmpty) {
      improvements.add(
          'Seek opportunities to earn honors and awards to showcase your achievements.');
    }

    // Additional Checks (Optional)
    if (resume.candidatePhone == null || resume.candidatePhone!.isEmpty) {
      improvements
          .add('Ensure that your phone number is included in the resume.');
    }
    if (resume.candidateEmail == null || resume.candidateEmail!.isEmpty) {
      improvements
          .add('Ensure that your email address is included in the resume.');
    }

    // Return the list of improvements
    return improvements;
  }

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}
