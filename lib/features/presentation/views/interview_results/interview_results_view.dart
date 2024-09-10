import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resume_radar/features/presentation/bloc/otp/otp_bloc.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../domain/entities/common/interview_response.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../../common/appbar.dart';
import '../base_view.dart';

class InterviewResultsView extends BaseView {
  final Map<String, dynamic> responseJson;

  InterviewResultsView({super.key, required this.responseJson});
  @override
  State<InterviewResultsView> createState() => _InterviewResultsViewState();
}

class _InterviewResultsViewState extends BaseViewState<InterviewResultsView> {
  late OtpBloc bloc;
  InterviewResponse? interviewResponse;

  @override
  void initState() {
    super.initState();
    bloc = injection<OtpBloc>();
    interviewResponse = InterviewResponse.fromJson(
      Map<String, dynamic>.from(widget.responseJson),
    );
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: ResumeRadarAppBar(
        title: "Interview Feedback",
      ),
      body: BlocProvider<OtpBloc>(
        create: (_) => bloc,
        child: BlocListener<OtpBloc, BaseState<OtpState>>(
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
                            '${interviewResponse?.performance?.overallScore ?? 0}',
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
                    'Strengths',
                    style: TextStyle(
                      fontSize: AppDimensions.kFontSize20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.matteBlack,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  interviewResponse?.performance?.strengths.isNotEmpty ?? false
                      ? ListView.builder(
                          itemCount:
                              interviewResponse!.performance!.strengths.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Icon(
                                Icons.thumb_up,
                                color: AppColors.primaryGreen,
                                size: 25.h,
                              ),
                              title: Text(
                                interviewResponse!
                                    .performance!.strengths[index],
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
                            'No strengths recorded.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: AppDimensions.kFontSize16,
                              color: AppColors.waitingTimeColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                  Text(
                    'Weaknesses',
                    style: TextStyle(
                      fontSize: AppDimensions.kFontSize20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.matteBlack,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  interviewResponse?.performance?.weaknesses.isNotEmpty ?? false
                      ? ListView.builder(
                          itemCount:
                              interviewResponse!.performance!.weaknesses.length,
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
                                interviewResponse!
                                    .performance!.weaknesses[index],
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
                            'No weaknesses recorded.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: AppDimensions.kFontSize16,
                              color: AppColors.waitingTimeColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                  Text(
                    'Recommendations',
                    style: TextStyle(
                      fontSize: AppDimensions.kFontSize20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.matteBlack,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  interviewResponse?.performance?.recommendations.isNotEmpty ??
                          false
                      ? ListView.builder(
                          itemCount: interviewResponse!
                              .performance!.recommendations.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final course = interviewResponse!
                                .performance!.recommendations[index];
                            return Card(
                              elevation: 3,
                              child: ListTile(
                                title: Text(
                                  course,
                                  style: TextStyle(
                                    fontSize: AppDimensions.kFontSize16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.matteBlack,
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
      ),
    );
  }

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}
