import 'dart:ui';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resume_radar/features/presentation/bloc/user/user_bloc.dart';
import 'package:resume_radar/utils/app_dimensions.dart';
import 'package:sharpapi_flutter_client/src/hr/models/parse_resume_model.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_images.dart';
import '../../../domain/entities/common/course_entity.dart';
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
  List<Course> courses = [];
  List<Course> recommendations = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    List<Course> coursesData = await loadCoursesFromCsv();
    setState(() {
      overallScore = calculateOverallScore(widget.resumeData);
      improvements.addAll(generateResumeImprovements(widget.resumeData));
      courses.addAll(coursesData);
      recommendations.addAll(recommendCourses(widget.resumeData, courses));
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
          child: Stack(
            children: [
              Row(
                children: [
                  Image.asset(
                    AppImages.imgBg2,
                    height: 349.h,
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  AppImages.imgBg1,
                  height: 432.h,
                ),
              ),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
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
                    ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 15.w),
                          decoration: BoxDecoration(
                            color: AppColors.colorWhite.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                      physics:
                                          const NeverScrollableScrollPhysics(),
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
                                              fontSize:
                                                  AppDimensions.kFontSize16,
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
                              Text(
                                'Recommended Courses',
                                style: TextStyle(
                                  fontSize: AppDimensions.kFontSize20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.matteBlack,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              recommendations.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: recommendations.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final course = recommendations[index];
                                        return Card(
                                          elevation: 3,
                                          child: ListTile(
                                            title: Text(
                                              course.courseTitle,
                                              style: TextStyle(
                                                fontSize:
                                                    AppDimensions.kFontSize16,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.matteBlack,
                                              ),
                                            ),
                                            subtitle: Text(
                                              'Subscribers: ${course.numSubscribers}\nSubject: ${course.subject}',
                                              style: TextStyle(
                                                fontSize:
                                                    AppDimensions.kFontSize14,
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    AppColors.waitingTimeColor,
                                              ),
                                            ),
                                            trailing: Icon(
                                              Icons.arrow_forward,
                                              color: AppColors.primaryGreen,
                                              size: 30.h,
                                            ),
                                            onTap: () {},
                                          ),
                                        );
                                      },
                                    )
                                  : Center(
                                      child: Text(
                                        'No recommendations available at the moment.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: AppDimensions.kFontSize16,
                                          color: AppColors.waitingTimeColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                              SizedBox(height: 40.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Column(),
            ],
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

    if (resume.educationQualifications == null ||
        resume.educationQualifications!.length < 2) {
      improvements.add(
          'Consider adding more educational qualifications or pursuing higher education.');
    }

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

    if (resume.candidateCoursesAndCertifications == null ||
        resume.candidateCoursesAndCertifications!.isEmpty) {
      improvements.add(
          'Consider pursuing relevant certifications to enhance your resume.');
    }

    if (resume.candidateSpokenLanguages == null ||
        resume.candidateSpokenLanguages!.length < 2) {
      improvements.add(
          'Consider learning additional languages to enhance your global employability.');
    }

    if (resume.candidateHonorsAndAwards == null ||
        resume.candidateHonorsAndAwards!.isEmpty) {
      improvements.add(
          'Seek opportunities to earn honors and awards to showcase your achievements.');
    }

    if (resume.candidatePhone == null || resume.candidatePhone!.isEmpty) {
      improvements
          .add('Ensure that your phone number is included in the resume.');
    }
    if (resume.candidateEmail == null || resume.candidateEmail!.isEmpty) {
      improvements
          .add('Ensure that your email address is included in the resume.');
    }

    return improvements;
  }

  Future<List<Course>> loadCoursesFromCsv() async {
    final rawData =
        await rootBundle.loadString('datasets/csv/udemy_courses.csv');
    List<List<dynamic>> csvData = const CsvToListConverter().convert(rawData);
    List<Course> courses = csvData.map((row) => Course.fromList(row)).toList();
    return courses;
  }

  List<Course> recommendCourses(ParseResumeModel resume, List<Course> courses,
      {int topN = 5}) {
    List<Course> recommendedCourses = [];

    List<String> skills = [];
    if (resume.positions != null) {
      for (var position in resume.positions!) {
        if (position.skills != null) {
          skills.addAll(position.skills!);
        }
      }
    }
    if (resume.educationQualifications != null) {
      for (var edu in resume.educationQualifications!) {
        if (edu.specializationSubjects != null) {
          skills.addAll(edu.specializationSubjects!.split(','));
        }
      }
    }

    skills = skills.map((skill) => skill.trim().toLowerCase()).toSet().toList();

    for (var skill in skills) {
      for (var course in courses) {
        if (course.courseTitle.toLowerCase().contains(skill)) {
          recommendedCourses.add(course);
        }
      }
    }

    recommendedCourses
        .sort((a, b) => b.numSubscribers.compareTo(a.numSubscribers));
    return recommendedCourses.take(topN).toList();
  }

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}
