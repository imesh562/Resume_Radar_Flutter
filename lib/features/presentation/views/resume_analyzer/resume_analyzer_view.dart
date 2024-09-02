import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as path;
import 'package:resume_radar/features/presentation/common/app_button.dart';
import 'package:resume_radar/features/presentation/common/appbar.dart';
import 'package:resume_radar/utils/app_dimensions.dart';
import 'package:resume_radar/utils/enums.dart';
import 'package:sharpapi_flutter_client/sharpapi_flutter_client.dart';
import 'package:sharpapi_flutter_client/src/hr/models/parse_resume_model.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/navigation_routes.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../../bloc/user/user_bloc.dart';
import '../../common/app_attachment_field.dart';
import '../../common/app_button_outline.dart';
import '../base_view.dart';
import 'common/resume_data_field.dart';
import 'common/resume_data_field_2.dart';

class ResumeAnalyzerView extends BaseView {
  ResumeAnalyzerView({super.key});
  @override
  State<ResumeAnalyzerView> createState() => _ResumeAnalyzerViewState();
}

class _ResumeAnalyzerViewState extends BaseViewState<ResumeAnalyzerView> {
  var bloc = injection<UserBloc>();

  File? resume;
  ParseResumeModel? resumeData;

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: ResumeRadarAppBar(
        title: 'Resume Analyzer',
      ),
      backgroundColor: AppColors.colorWhite,
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
                  AppAttachmentField(
                    label: 'Select Your Resume',
                    hint: 'Tap here to attach file (10MB max)',
                    isRequired: true,
                    onChange: (file, fileName) {
                      if (file != null && fileName != null) {
                        setState(() {
                          resume = file;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a document";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  if (resume != null)
                    Center(
                      child: Column(
                        children: [
                          Container(
                            height: 300.h,
                            width: 170.w,
                            padding: EdgeInsets.all(8.r),
                            color: AppColors.checkBoxBorder,
                            child:
                                _getFilePreview(path.extension(resume!.path)),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  AppButton(
                    buttonText: 'Upload File',
                    onTapButton: () {
                      showProgressBar();
                      if (resume != null) {
                        SharpApi.parseResume(
                          resume: resume!,
                          language: SharpApiLanguages.ENGLISH,
                        ).then((value) {
                          hideProgressBar();
                          setState(() {
                            resumeData = value;
                          });
                        }).catchError((error) {
                          hideProgressBar();
                          showSnackBar("Something went wrong!", AlertType.FAIL);
                        });
                      }
                    },
                  ),
                  SizedBox(height: 20.h),
                  if (resumeData != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (resumeData!.candidateName != null &&
                            resumeData!.candidateName!.isNotEmpty)
                          ResumeDataField(
                            fieldName: 'Name: ',
                            fieldValue: resumeData!.candidateName ?? '',
                          ),
                        if (resumeData!.candidateEmail != null &&
                            resumeData!.candidateEmail!.isNotEmpty)
                          ResumeDataField(
                            fieldName: 'Email: ',
                            fieldValue: resumeData!.candidateEmail ?? '',
                          ),
                        if (resumeData!.candidatePhone != null &&
                            resumeData!.candidatePhone!.isNotEmpty)
                          ResumeDataField(
                            fieldName: 'Phone: ',
                            fieldValue: resumeData!.candidatePhone ?? '',
                          ),
                        if (resumeData!.candidateAddress != null &&
                            resumeData!.candidateAddress!.isNotEmpty)
                          ResumeDataField(
                            fieldName: 'Address: ',
                            fieldValue: resumeData!.candidateAddress ?? '',
                          ),
                        if (resumeData!.candidateLanguage != null &&
                            resumeData!.candidateLanguage!.isNotEmpty)
                          ResumeDataField(
                            fieldName: 'Language: ',
                            fieldValue: resumeData!.candidateLanguage ?? '',
                          ),
                        if (resumeData!.candidateSpokenLanguages != null &&
                            resumeData!.candidateSpokenLanguages!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Spoken Languages:',
                                style: TextStyle(
                                  fontSize: AppDimensions.kFontSize18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.matteBlack,
                                ),
                              ),
                              ...resumeData!.candidateSpokenLanguages!.map(
                                (lang) => Text(
                                  '• $lang',
                                  style: TextStyle(
                                    fontSize: AppDimensions.kFontSize18,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.matteBlack,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ),
                        if (resumeData!.candidateHonorsAndAwards != null &&
                            resumeData!.candidateHonorsAndAwards!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Honors and Awards:',
                                style: TextStyle(
                                  fontSize: AppDimensions.kFontSize18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.matteBlack,
                                ),
                              ),
                              ...resumeData!.candidateHonorsAndAwards!.map(
                                (award) => Text(
                                  '• $award',
                                  style: TextStyle(
                                    fontSize: AppDimensions.kFontSize18,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.matteBlack,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ),
                        if (resumeData!.candidateCoursesAndCertifications !=
                                null &&
                            resumeData!
                                .candidateCoursesAndCertifications!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Courses and Certifications:',
                                style: TextStyle(
                                  fontSize: AppDimensions.kFontSize18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.matteBlack,
                                ),
                              ),
                              ...resumeData!.candidateCoursesAndCertifications!
                                  .map(
                                (course) => Text(
                                  '• $course',
                                  style: TextStyle(
                                    fontSize: AppDimensions.kFontSize18,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.matteBlack,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (resumeData!.positions != null &&
                            resumeData!.positions!.isNotEmpty)
                          Column(
                            children: [
                              Text(
                                'Work Experience:',
                                style: TextStyle(
                                  fontSize: AppDimensions.kFontSize18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.matteBlack,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              ...resumeData!.positions!.map(
                                (position) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ResumeDataField2(
                                      fieldName: 'Position',
                                      fieldValue:
                                          '${position.positionName} at ${position.companyName}',
                                    ),
                                    if (position.startDate != null &&
                                        position.endDate != null)
                                      ResumeDataField2(
                                        fieldName: 'Period: ',
                                        fieldValue:
                                            'From ${position.startDate} to ${position.endDate}',
                                      ),
                                    if (position.jobDetails != null)
                                      ResumeDataField2(
                                        fieldName: 'Details: ',
                                        fieldValue: position.jobDetails ?? '',
                                      ),
                                    if (position.skills != null &&
                                        position.skills!.isNotEmpty)
                                      ResumeDataField2(
                                        fieldName: 'Skills: ',
                                        fieldValue: position.skills!.join(', '),
                                      ),
                                    SizedBox(height: 10.h),
                                    Divider(
                                      height: 0.75.h,
                                      thickness: 0.75.h,
                                      color: AppColors.matteBlack,
                                    ),
                                    SizedBox(height: 20.h),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        if (resumeData!.educationQualifications != null &&
                            resumeData!.educationQualifications!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Education:',
                                style: TextStyle(
                                  fontSize: AppDimensions.kFontSize18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.matteBlack,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              ...resumeData!.educationQualifications!.map(
                                (education) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ResumeDataField2(
                                      fieldName:
                                          '${(education.degreeType ?? '').replaceAll('or equivalent', '')}: ',
                                      fieldValue: education.schoolName ?? '',
                                    ),
                                    if (education.startDate != null &&
                                        education.endDate != null)
                                      ResumeDataField2(
                                        fieldName: 'Period: ',
                                        fieldValue:
                                            'From ${education.startDate} to ${education.endDate}',
                                      ),
                                    if (education.specializationSubjects !=
                                            null &&
                                        education
                                            .specializationSubjects!.isNotEmpty)
                                      ResumeDataField2(
                                        fieldName: 'Specialization: ',
                                        fieldValue:
                                            education.specializationSubjects ??
                                                '',
                                      ),
                                    SizedBox(height: 10.h),
                                    Divider(
                                      height: 0.75.h,
                                      thickness: 0.75.h,
                                      color: AppColors.matteBlack,
                                    ),
                                    SizedBox(height: 20.h),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        AppButtonOutline(
                          buttonText: 'View Score & Recommendations',
                          onTapButton: () {
                            Navigator.pushNamed(
                                context, Routes.kRecommendationAndOtherInfoView,
                                arguments: resumeData);
                          },
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getFilePreview(String fileType) {
    if (fileType == '.pdf') {
      return PDFView(
        filePath: resume!.path,
        autoSpacing: true,
        enableSwipe: true,
        pageSnap: true,
        fitPolicy: FitPolicy.BOTH,
      );
    } else {
      return const Text('Error reading document');
    }
  }

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}
