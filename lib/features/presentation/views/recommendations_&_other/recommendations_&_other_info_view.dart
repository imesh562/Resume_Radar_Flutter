import 'dart:ui';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:resume_radar/features/presentation/bloc/user/user_bloc.dart';
import 'package:resume_radar/utils/app_dimensions.dart';
import 'package:sharpapi_flutter_client/src/hr/models/parse_resume_model.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final double experienceWeight = 0.25;
  double educationScore = 0;
  double experienceScore = 0;
  double certificationScore = 0;
  double languageScore = 0;
  double honorsScore = 0;
  double skillsScore = 0;
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
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.colorWhite,
                                  borderRadius: BorderRadius.circular(8.r),
                                  boxShadow: [
                                    BoxShadow(
                                        color: AppColors.profileArrowColor,
                                        blurRadius: 15,
                                        offset: const Offset(0, 3))
                                  ],
                                ),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ListTileTheme(
                                    data: const ListTileThemeData(
                                      contentPadding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                      horizontalTitleGap: 0.0,
                                      minLeadingWidth: 0,
                                      dense: true,
                                    ),
                                    child: ExpansionTile(
                                      collapsedIconColor: AppColors.matteBlack,
                                      iconColor: AppColors.matteBlack,
                                      tilePadding: EdgeInsets.symmetric(
                                          horizontal: 14.h),
                                      title: Text(
                                        'Score Details',
                                        style: TextStyle(
                                          fontSize: AppDimensions.kFontSize14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.matteBlack,
                                        ),
                                      ),
                                      expandedAlignment: Alignment.centerLeft,
                                      childrenPadding: EdgeInsets.zero,
                                      dense: true,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 14.w),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Divider(
                                                height: 0.6.h,
                                                color: AppColors.lightGrey,
                                              ),
                                              SizedBox(height: 14.h),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Education Score',
                                                    style: TextStyle(
                                                      fontSize: AppDimensions
                                                          .kFontSize12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColors.matteBlack,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${educationScore.toInt()}/30',
                                                    style: TextStyle(
                                                      fontSize: AppDimensions
                                                          .kFontSize12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColors.matteBlack,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 14.h),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Experience Score',
                                                    style: TextStyle(
                                                      fontSize: AppDimensions
                                                          .kFontSize12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColors.matteBlack,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${experienceScore.toInt()}/25',
                                                    style: TextStyle(
                                                      fontSize: AppDimensions
                                                          .kFontSize12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColors.matteBlack,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 14.h),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Skills Score',
                                                    style: TextStyle(
                                                      fontSize: AppDimensions
                                                          .kFontSize12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColors.matteBlack,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${skillsScore.toInt()}/25',
                                                    style: TextStyle(
                                                      fontSize: AppDimensions
                                                          .kFontSize12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColors.matteBlack,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 14.h),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Certificates Score',
                                                    style: TextStyle(
                                                      fontSize: AppDimensions
                                                          .kFontSize12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColors.matteBlack,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${certificationScore.toInt()}/10',
                                                    style: TextStyle(
                                                      fontSize: AppDimensions
                                                          .kFontSize12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColors.matteBlack,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 14.h),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Languages Score',
                                                    style: TextStyle(
                                                      fontSize: AppDimensions
                                                          .kFontSize12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColors.matteBlack,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${languageScore.toInt()}/5',
                                                    style: TextStyle(
                                                      fontSize: AppDimensions
                                                          .kFontSize12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColors.matteBlack,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 14.h),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Honors & Awards Score',
                                                    style: TextStyle(
                                                      fontSize: AppDimensions
                                                          .kFontSize12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColors.matteBlack,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${honorsScore.toInt()}/5',
                                                    style: TextStyle(
                                                      fontSize: AppDimensions
                                                          .kFontSize12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColors.matteBlack,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 14.h),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.h),
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
                                            onTap: () {
                                              _launchUrl(Uri.parse(course.url));
                                            },
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
    // Education Score (Based on degree type) out of 30.
    if (resume.educationQualifications != null &&
        resume.educationQualifications!.isNotEmpty) {
      CandidateEducationModel highestEducation =
          getHighestEducation(resume.educationQualifications!);

      double baseEducationScore = (highestEducation.degreeType!.contains("PhD"))
          ? 30
          : (highestEducation.degreeType!.contains("Master"))
              ? 25
              : (highestEducation.degreeType!.contains("Bachelor"))
                  ? 20
                  : 10;

      educationScore = baseEducationScore;
    }

    // Experience Score (Based on years of experience) out of 25.
    if (resume.positions != null && resume.positions!.isNotEmpty) {
      int totalYears = calculateTotalYearsOfExperience(resume.positions!);

      experienceScore = (((totalYears /
                      (resume.positions == null || resume.positions!.isEmpty
                          ? 2
                          : resume.positions!.length * 2))
                  .clamp(0, 1)) *
              100) *
          experienceWeight;
    }

    // Certifications Score (Based on number of certifications) out of 10.
    if (resume.candidateCoursesAndCertifications != null &&
        resume.candidateCoursesAndCertifications!.isNotEmpty) {
      certificationScore =
          (resume.candidateCoursesAndCertifications!.length * 2.5)
              .clamp(0, 10)
              .toDouble();
    }

    // Languages Score (Based on number of languages spoken) out of 05.
    if (resume.candidateSpokenLanguages != null &&
        resume.candidateSpokenLanguages!.isNotEmpty) {
      languageScore =
          (resume.candidateSpokenLanguages!.length * 1).clamp(0, 5).toDouble();
    }

    // Honors and Awards Score (Based on number of awards) out of 5.
    if (resume.candidateHonorsAndAwards != null &&
        resume.candidateHonorsAndAwards!.isNotEmpty) {
      honorsScore =
          (resume.candidateHonorsAndAwards!.length * 1).clamp(0, 5).toDouble();
    }

    // Skills score out of 25.
    Set<String> uniqueSkills = {};

    if (resume.positions != null) {
      for (var position in resume.positions!) {
        if (position.skills != null) {
          uniqueSkills.addAll(position.skills!.map((s) => s.toLowerCase()));
        }
      }
    }

    if (resume.educationQualifications != null) {
      for (var edu in resume.educationQualifications!) {
        if (edu.specializationSubjects != null) {
          uniqueSkills.addAll(edu.specializationSubjects!
              .split(',')
              .map((s) => s.trim().toLowerCase()));
        }
      }
    }

    skillsScore = (uniqueSkills.length * 2).clamp(0, 20).toDouble();

    double totalScore = educationScore +
        experienceScore +
        certificationScore +
        languageScore +
        skillsScore +
        honorsScore;
    totalScore = (totalScore).clamp(0, 100);

    return totalScore;
  }

  CandidateEducationModel getHighestEducation(
      List<CandidateEducationModel> educationList) {
    educationList.sort((a, b) {
      return degreePriority(b.degreeType ?? '')
          .compareTo(degreePriority(a.degreeType ?? ''));
    });
    return educationList.first;
  }

  int degreePriority(String degreeType) {
    if (degreeType.contains("PhD")) return 4;
    if (degreeType.contains("Master")) return 3;
    if (degreeType.contains("Bachelor")) return 2;
    return 1;
  }

  int calculateTotalYearsOfExperience(List<CandidatePositionsModel> positions) {
    int totalYears = 0;
    int totalMonths = 0;
    for (var position in positions) {
      if (position.startDate != null) {
        DateTime startDate =
            DateFormat('yyyy-MM-dd').parse(position.startDate!);
        DateTime endDate = position.endDate != null
            ? DateFormat('yyyy-MM-dd').parse(position.endDate!)
            : DateTime.now();
        totalMonths +=
            ((endDate.difference(startDate).inDays).abs() / 30).round();
      }
    }
    totalYears += (totalMonths / 12).round();
    return totalYears;
  }

  List<String> generateResumeImprovements(ParseResumeModel resume) {
    List<String> improvements = [];

    Set<String> uniqueSkills = {};
    if (resume.positions != null) {
      for (var position in resume.positions!) {
        if (position.skills != null) {
          uniqueSkills.addAll(position.skills!.map((s) => s.toLowerCase()));
        }
      }
    }
    if (resume.educationQualifications != null) {
      for (var edu in resume.educationQualifications!) {
        if (edu.specializationSubjects != null) {
          uniqueSkills.addAll(edu.specializationSubjects!
              .split(',')
              .map((s) => s.trim().toLowerCase()));
        }
      }
    }

    if (uniqueSkills.isEmpty) {
      improvements.add(
          'Add relevant skills to your resume to showcase your expertise.');
    } else if (uniqueSkills.length < 5) {
      improvements.add(
          'Consider adding more skills to your resume to demonstrate a broader range of expertise.');
    }

    CandidateEducationModel highestEducation =
        getHighestEducation(resume.educationQualifications!);

    if (!(highestEducation.degreeType!.contains("Master") ||
        highestEducation.degreeType!.contains("PhD"))) {
      improvements.add(
          'Consider adding more educational qualifications or pursuing higher education.');
    }

    if (resume.positions == null || resume.positions!.length < 2) {
      improvements.add(
          'Gain more work experience or update the resume with more recent positions.');
    } else {
      DateTime now = DateTime.now();
      List<CandidatePositionsModel> positions = resume.positions ?? [];
      positions.sort((a, b) {
        DateTime dateA =
            a.endDate != null ? DateTime.parse(a.endDate!) : DateTime.now();
        DateTime dateB =
            b.endDate != null ? DateTime.parse(b.endDate!) : DateTime.now();
        return dateA.compareTo(dateB);
      });
      if (positions.isNotEmpty) {
        DateTime endDate = positions.last.endDate != null
            ? DateFormat('yyyy-MM-dd').parse(positions.last.endDate!)
            : DateTime.now();
        if (endDate.isBefore(now.subtract(const Duration(days: 180)))) {
          improvements.add(
              'Add more recent positions or update the end date of current positions.');
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

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}
