import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resume_radar/features/presentation/bloc/user/user_bloc.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_images.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../base_view.dart';
import '../login/common/login_button.dart';

class SuccessViewArgs {
  final bool viewLogo;
  final String title;
  final String subTitle;
  final String buttonTitle;
  final Function onTapButton;

  SuccessViewArgs({
    this.viewLogo = true,
    required this.title,
    required this.subTitle,
    required this.buttonTitle,
    required this.onTapButton,
  });
}

class SuccessView extends BaseView {
  final SuccessViewArgs successViewArgs;

  SuccessView({super.key, required this.successViewArgs});
  @override
  State<SuccessView> createState() => _SuccessViewState();
}

class _SuccessViewState extends BaseViewState<SuccessView> {
  var bloc = injection<UserBloc>();

  @override
  Widget buildView(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.successViewArgs.onTapButton();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.colorWhite,
        resizeToAvoidBottomInset: false,
        body: BlocProvider<UserBloc>(
          create: (_) => bloc,
          child: BlocListener<UserBloc, BaseState<UserState>>(
            listener: (_, state) {},
            child: Stack(
              children: [
                Image.asset(
                  AppImages.imgBg2,
                  height: 349.h,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Image.asset(
                    AppImages.imgBg1,
                    height: 432.h,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Column(
                    children: [
                      if (widget.successViewArgs.viewLogo)
                        Column(
                          children: [
                            SizedBox(height: 142.h),
                            Padding(
                              padding: EdgeInsets.only(right: 15.w),
                              child: Image.asset(
                                AppImages.appIcon,
                                height: 38.95.h,
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 16.05.h),
                      Text(
                        widget.successViewArgs.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppDimensions.kFontSize20,
                          color: AppColors.loginTitleColor,
                        ),
                      ),
                      SizedBox(height: 37.h),
                      Image.asset(
                        AppImages.imgSuccess,
                        height: 81.65.h,
                      ),
                      SizedBox(height: 24.35.h),
                      Text(
                        widget.successViewArgs.subTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: AppDimensions.kFontSize14,
                          color: AppColors.settingsTextColor,
                        ),
                      ),
                      SizedBox(height: 57.h),
                      LoginButton(
                        buttonText: widget.successViewArgs.buttonTitle,
                        onTapButton: widget.successViewArgs.onTapButton,
                      )
                    ],
                  ),
                ),
              ],
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
