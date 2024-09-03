import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resume_radar/features/presentation/common/appbar.dart';
import 'package:resume_radar/utils/app_images.dart';
import 'package:resume_radar/utils/navigation_routes.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../../bloc/user/user_bloc.dart';
import '../base_view.dart';
import 'custom/main_menu_item.dart';

class DashboardView extends BaseView {
  DashboardView({super.key});
  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends BaseViewState<DashboardView> {
  var bloc = injection<UserBloc>();

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: ResumeRadarAppBar(
        title: 'Main Menu',
        isGoBackVisible: false,
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
                  Container(
                    height: 300.h,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          AppColors.appButtonOutlineGradient1,
                          AppColors.appButtonOutlineGradient2,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: Image.asset(
                        AppImages.imgResumeRadar,
                        height: 200.h,
                        color: AppColors.matteBlack,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: MainMenuItem(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Routes.kMockInterviewCvScanView);
                              },
                              title: 'Mock\nInterview',
                              image: AppImages.icInterview,
                            ),
                          ),
                          SizedBox(width: 15.h),
                          Expanded(
                            child: MainMenuItem(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Routes.kResumeAnalyzerView);
                              },
                              title: 'Resume\nAnalyzer',
                              image: AppImages.icCvScan,
                              imageColor: AppColors.secondaryBlue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          Expanded(
                            child: MainMenuItem(
                              onTap: () {},
                              title: 'Quiz\nCenter',
                              image: AppImages.icQuiz,
                            ),
                          ),
                          SizedBox(width: 15.h),
                          Expanded(
                            child: MainMenuItem(
                              onTap: () {},
                              title: 'Logout',
                              image: AppImages.icLogout,
                              imageColor: AppColors.logOutColor,
                            ),
                          ),
                        ],
                      ),
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

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}
