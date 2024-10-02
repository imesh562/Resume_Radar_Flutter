import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:resume_radar/features/presentation/views/resume_analyzer/resume_analyzer_view.dart';
import 'package:resume_radar/utils/app_images.dart';
import 'package:resume_radar/utils/navigation_routes.dart';
import 'package:sharpapi_flutter_client/src/hr/models/parse_resume_model.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../../bloc/user/user_bloc.dart';
import '../base_view.dart';

class DashboardView extends BaseView {
  DashboardView({super.key});
  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends BaseViewState<DashboardView> {
  var bloc = injection<UserBloc>();
  List<Map<String, dynamic>> interviewData = [];
  List<ParseResumeModel> resumeData = [];
  List<HomeCardEntity> appCardList = [
    HomeCardEntity(
      icon: AppImages.icInterview,
      title: 'Mock Interview',
      index: 1,
    ),
    HomeCardEntity(
      icon: AppImages.icCvScan,
      title: 'Resume Analyzer',
      index: 2,
    ),
    HomeCardEntity(
      icon: AppImages.icQuiz,
      title: 'Quizzes',
      index: 3,
    ),
    HomeCardEntity(
      icon: AppImages.icLogout,
      bgColor: AppColors.errorRed,
      title: 'Log Out',
      index: 4,
    ),
  ];

  @override
  void initState() {
    super.initState();
    initUI();
  }

  void initUI() {
    setState(() {
      resumeData.clear();
      interviewData.clear();
      if (appSharedData.hasResumeAnalysisData()) {
        resumeData.addAll(appSharedData.getResumeAnalysisData());
      }
      if (appSharedData.hasMockInterviewData()) {
        interviewData.addAll(appSharedData.getMockInterviewData());
      }
    });
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      body: BlocProvider<UserBloc>(
        create: (_) => bloc,
        child: BlocListener<UserBloc, BaseState<UserState>>(
          listener: (_, state) {
            if (state is LogOutSuccessState) {
              logOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.kLoginView, (route) => false);
            }
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 46.h,
                          height: 46.h,
                          child: CircleAvatar(
                            backgroundColor: AppColors.darkStrokeGrey,
                            child: Center(
                              child: Text(
                                getFirstCharacters(
                                    '${appSharedData.getAppUser().firstName ?? ''} ${appSharedData.getAppUser().lastName ?? ''}'),
                                style: TextStyle(
                                    color: AppColors.matteBlack,
                                    fontSize: AppDimensions.kFontSize16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Welcome ${(appSharedData.getAppUser().firstName ?? '').split(' ').first},",
                                style: TextStyle(
                                  fontSize: AppDimensions.kFontSize14,
                                  color: AppColors.matteBlack,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    getTimeOfDayGreeting(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: AppDimensions.kFontSize14,
                                      color: AppColors.matteBlack,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    '!',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: AppDimensions.kFontSize14,
                                      color: AppColors.matteBlack,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          AppImages.appIcon,
                          height: 46.h,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Center(
                    child: Text(
                      "Latest Scores",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryGreen,
                        fontSize: AppDimensions.kFontSize16,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 23.5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Mock Interview",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.matteBlack,
                                fontSize: AppDimensions.kFontSize13,
                              ),
                            ),
                            SizedBox(height: 9.h),
                            SizedBox(
                              height: 90.w,
                              width: 90.w,
                              child: Center(
                                child: _getRadialGauge(appSharedData
                                        .hasMockInterviewData()
                                    ? appSharedData.getMockInterviewData()[0]
                                                ["performance"] !=
                                            null
                                        ? appSharedData
                                                .getMockInterviewData()[0]
                                            ["performance"]["overall_score"]
                                        : 0
                                    : 0),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20.w),
                        Container(
                          height: 120.h,
                          margin: EdgeInsets.only(top: 15.h),
                          child: VerticalDivider(
                            width: 1.w,
                            thickness: 1.w,
                            color: AppColors.lightGrey,
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Column(
                          children: [
                            Text(
                              'Resume Score',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.matteBlack,
                                fontSize: AppDimensions.kFontSize13,
                              ),
                            ),
                            SizedBox(height: 9.h),
                            SizedBox(
                              height: 90.w,
                              width: 90.w,
                              child: Center(
                                child: _getRadialGauge(
                                    appSharedData.hasResumeAnalysisData()
                                        ? calculateOverallScore(appSharedData
                                            .getResumeAnalysisData()[0])
                                        : 0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: appCardList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (appCardList[index].index == 1) {
                            Navigator.pushNamed(
                              context,
                              Routes.kMockInterviewCvScanView,
                            ).then((value) {
                              setState(() {
                                initUI();
                              });
                            });
                          } else if (appCardList[index].index == 2) {
                            Navigator.pushNamed(
                              context,
                              Routes.kResumeAnalyzerView,
                              arguments: ResumeAnalyzerViewArgs(),
                            ).then((value) {
                              setState(() {
                                initUI();
                              });
                            });
                          } else if (appCardList[index].index == 3) {
                            Navigator.pushNamed(
                              context,
                              Routes.kQuizzesView,
                            ).then((value) {
                              setState(() {
                                initUI();
                              });
                            });
                          } else {
                            showAppDialog(
                              title: 'Log Out',
                              description: 'Are you sure want to log out ?',
                              negativeButtonText: 'Cancel',
                              positiveButtonText: 'Log Out',
                              isDismissible: true,
                              onNegativeCallback: () {
                                Navigator.pop(context);
                              },
                              onPositiveCallback: () {
                                bloc.add(LogOutEvent());
                              },
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 9.5.h,
                            horizontal: 16.w,
                          ),
                          margin: index < appCardList.length - 1
                              ? EdgeInsets.only(bottom: 13.h)
                              : EdgeInsets.zero,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: appCardList[index].bgColor.withOpacity(0.75),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 40.w,
                                    child: Image.asset(
                                      appCardList[index].icon,
                                      height: 30.h,
                                      color: AppColors.matteBlack,
                                    ),
                                  ),
                                  SizedBox(width: 9.w),
                                  Text(
                                    appCardList[index].title,
                                    style: TextStyle(
                                      fontSize: AppDimensions.kFontSize16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.matteBlack,
                                    ),
                                  ),
                                ],
                              ),
                              Image.asset(
                                AppImages.icForward,
                                height: 24.h,
                                color: AppColors.matteBlack,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    'Mock Interview Results History',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryGreen,
                      fontSize: AppDimensions.kFontSize16,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  interviewData.isNotEmpty
                      ? ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: interviewData.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.kInterviewResultsView,
                                  arguments: interviewData[index],
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 9.5.h,
                                  horizontal: 16.w,
                                ),
                                margin: index < interviewData.length - 1
                                    ? EdgeInsets.only(bottom: 13.h)
                                    : EdgeInsets.zero,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: AppColors.checkBoxBorder,
                                    )),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      AppImages.icInterview,
                                      height: 30.h,
                                      color: AppColors.matteBlack,
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Name: ${appSharedData.getAppUser().firstName ?? ''} ${appSharedData.getAppUser().lastName ?? ''}',
                                            style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize:
                                                  AppDimensions.kFontSize14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.matteBlack,
                                            ),
                                          ),
                                          Text(
                                            'Score: ${interviewData[index]["performance"] != null ? interviewData[index]["performance"]["overall_score"] : '0'}/100',
                                            style: TextStyle(
                                              fontSize:
                                                  AppDimensions.kFontSize12,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.matteBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Image.asset(
                                      AppImages.icForward,
                                      height: 24.h,
                                      color: AppColors.matteBlack,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 10.w),
                                  Image.asset(
                                    AppImages.icEmptyLight,
                                    height: 100.h,
                                  ),
                                ],
                              ),
                              Text(
                                "No Interview Results",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: AppDimensions.kFontSize14,
                                  color: AppColors.lightGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(height: 15.h),
                  Text(
                    'Resume Results History',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryGreen,
                      fontSize: AppDimensions.kFontSize16,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  resumeData.isNotEmpty
                      ? ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: resumeData.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.kResumeAnalyzerView,
                                  arguments: ResumeAnalyzerViewArgs(
                                    isResultsView: true,
                                    resumeData: resumeData[index],
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 9.5.h,
                                  horizontal: 16.w,
                                ),
                                margin: index < resumeData.length - 1
                                    ? EdgeInsets.only(bottom: 13.h)
                                    : EdgeInsets.zero,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: AppColors.checkBoxBorder,
                                    )),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      AppImages.icCvScan,
                                      height: 30.h,
                                      color: AppColors.matteBlack,
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Name: ${resumeData[index].candidateName ?? ''}',
                                            style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize:
                                                  AppDimensions.kFontSize14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.matteBlack,
                                            ),
                                          ),
                                          Text(
                                            'Score: ${calculateOverallScore(resumeData[index])}/100',
                                            style: TextStyle(
                                              fontSize:
                                                  AppDimensions.kFontSize12,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.matteBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Image.asset(
                                      AppImages.icForward,
                                      height: 24.h,
                                      color: AppColors.matteBlack,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 10.w),
                                  Image.asset(
                                    AppImages.icEmptyLight,
                                    height: 100.h,
                                  ),
                                ],
                              ),
                              Text(
                                "No Resume Results",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: AppDimensions.kFontSize14,
                                  color: AppColors.lightGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(height: 15.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getRadialGauge(int score) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(2.49.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.circleColor3,
              width: 0.56.w,
            ),
          ),
        ),
        Transform.rotate(
          angle: 180 * (3.141592653589793 / 180),
          child: AnimatedRadialGauge(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
            radius: 100.r,
            value: double.parse(score.toString()),
            axis: GaugeAxis(
              min: 0,
              max: 1000,
              degrees: 360,
              style: GaugeAxisStyle(
                thickness: 4.99.w,
                background: AppColors.colorTransparent,
                cornerRadius: Radius.circular(100.r),
              ),
              progressBar: GaugeProgressBar.rounded(
                gradient: GaugeAxisGradient(
                  colors: [
                    AppColors.homeGradient2,
                    AppColors.homeGradient1,
                    AppColors.homeGradient2
                  ],
                  colorStops: const [0, 0.5, 1],
                ),
              ),
              pointer: null,
            ),
            builder: (context, child, value) => Center(
              child: Transform.rotate(
                angle: 180 * (3.141592653589793 / 180),
                child: Text(
                  score.toString(),
                  style: TextStyle(
                    fontSize: AppDimensions.kFontSize24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.circleTextColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String getTimeOfDayGreeting() {
    int hour;
    DateTime now = DateTime.now();
    hour = now.hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String getFirstCharacters(String input) {
    List<String> words = input.split(" ");
    if (words.length >= 2 && words[1].isNotEmpty) {
      String firstWord = words[0];
      String secondWord = words[1];
      String firstCharacters =
          "${firstWord[0].toUpperCase()}${secondWord[0].toUpperCase()}";
      return firstCharacters;
    } else {
      return words[0][0] + words[0][1];
    }
  }

  int calculateOverallScore(ParseResumeModel resume) {
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
    return score.clamp(0, 100).toInt();
  }

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}

class HomeCardEntity {
  final String icon;
  final String title;
  final Color bgColor;
  int index;

  HomeCardEntity({
    required this.icon,
    required this.title,
    required this.index,
    this.bgColor = AppColors.primaryGreen,
  });
}
