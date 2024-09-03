import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as path;
import 'package:resume_radar/features/presentation/common/app_button.dart';
import 'package:resume_radar/features/presentation/common/appbar.dart';
import 'package:resume_radar/utils/enums.dart';
import 'package:resume_radar/utils/navigation_routes.dart';
import 'package:sharpapi_flutter_client/sharpapi_flutter_client.dart';
import 'package:sharpapi_flutter_client/src/hr/models/parse_resume_model.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../../bloc/user/user_bloc.dart';
import '../../common/app_attachment_field.dart';
import '../base_view.dart';

class MockInterviewCvScanView extends BaseView {
  MockInterviewCvScanView({super.key});
  @override
  State<MockInterviewCvScanView> createState() =>
      _MockInterviewCvScanViewState();
}

class _MockInterviewCvScanViewState
    extends BaseViewState<MockInterviewCvScanView> {
  var bloc = injection<UserBloc>();

  File? resume;
  ParseResumeModel? resumeData;

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: ResumeRadarAppBar(
        title: 'Mock Interview',
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
                    buttonText: 'Upload File & Begin Interview',
                    buttonType: resume != null
                        ? ButtonType.ENABLED
                        : ButtonType.DISABLED,
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
                          Navigator.pushNamed(
                            context,
                            Routes.kMockInterviewView,
                            arguments: resumeData,
                          );
                        }).catchError((error) {
                          hideProgressBar();
                          showSnackBar("Something went wrong!", AlertType.FAIL);
                        });
                      }
                    },
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
