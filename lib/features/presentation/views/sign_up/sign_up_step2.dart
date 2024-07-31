import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resume_radar/features/presentation/common/appbar.dart';
import 'package:resume_radar/features/presentation/views/sign_up/sign_up_step3.dart';
import 'package:resume_radar/features/presentation/views/sign_up/widgets/pin_put_component.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/navigation_routes.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../../bloc/otp/otp_bloc.dart';
import '../../common/otp_count_down.dart';
import '../base_view.dart';
import '../login/common/login_button.dart';

class SignUpStep2Args {
  final String emailAddress;

  SignUpStep2Args({
    required this.emailAddress,
  });
}

class SignUpStep2 extends BaseView {
  final SignUpStep2Args signUpStep2Args;
  SignUpStep2({required this.signUpStep2Args});

  @override
  State<SignUpStep2> createState() => _ResetPasswordStep2State();
}

class _ResetPasswordStep2State extends BaseViewState<SignUpStep2> {
  var bloc = injection<OtpBloc>();
  final _otpController = TextEditingController();
  OTPCountDown? _otpCountDown;
  bool _isCountDownFinished = false;
  String? _countDown;
  final _otpKey = GlobalKey<FormState>();
  String? error;

  @override
  void initState() {
    super.initState();
    _startCountDown(30);
  }

  void _startCountDown(int remainingTime) {
    _isCountDownFinished = false;
    _otpCountDown = OTPCountDown.startOTPTimer(
      timeInMS: remainingTime * 1000,
      currentCountDown: (String countDown) {
        _countDown = countDown;
        if (mounted) {
          setState(() {});
        }
      },
      onFinish: () {
        _isCountDownFinished = true;
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: ResumeRadarAppBar(
        isPreLogin: true,
      ),
      body: BlocProvider<OtpBloc>(
        create: (_) => bloc,
        child: BlocListener<OtpBloc, BaseState<OtpState>>(
          listener: (_, state) {
            if (state is VerifyOtpSuccessState) {
              Navigator.pushReplacementNamed(context, Routes.kSignUpStep3,
                  arguments: SignUpStep3Args(
                    email: widget.signUpStep2Args.emailAddress,
                  ));
            } else if (state is SendOtpSuccessState) {
              showSnackBar(
                state.message,
                state.isSent ? AlertType.SUCCESS : AlertType.WARNING,
              );
              _startCountDown(30);
            } else if (state is VerifyOtpFailedState) {
              setState(() {
                error = state.message;
              });
              _otpKey.currentState!.validate();
            }
          },
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
                    SizedBox(height: 142.h),
                    Image.asset(
                      AppImages.appIcon,
                      height: 60.h,
                    ),
                    SizedBox(height: 18.05.h),
                    Text(
                      'Verify your email',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: AppDimensions.kFontSize20,
                        color: AppColors.loginTitleColor,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Column(
                        children: [
                          Text(
                            'A six digit verification code has been sent to the',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.5.h,
                              fontWeight: FontWeight.w400,
                              fontSize: AppDimensions.kFontSize14,
                              color: AppColors.textFieldTitleColor,
                            ),
                          ),
                          Text(
                            widget.signUpStep2Args.emailAddress,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.5.h,
                              fontWeight: FontWeight.w500,
                              fontSize: AppDimensions.kFontSize14,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          Text(
                            'Enter the verification code to continue',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.5.h,
                              fontWeight: FontWeight.w400,
                              fontSize: AppDimensions.kFontSize14,
                              color: AppColors.textFieldTitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 44.h),
                    Form(
                      key: _otpKey,
                      child: PinPutComponent(
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 6) {
                            return 'Verification Code required';
                          } else if (error != null) {
                            return error;
                          }
                          return null;
                        },
                        obscureText: false,
                        isPreLogin: true,
                        textEditingController: _otpController,
                        textInputType: TextInputType.number,
                        forceErrorState: (_otpController.text.isEmpty ||
                                _otpController.text.length < 6) ||
                            error != null,
                        onSubmit: (otp) {
                          if (otp.length == 6) {
                            setState(() {
                              error = null;
                            });
                            bloc.add(VerifyOtpEvent(
                                email: widget.signUpStep2Args.emailAddress,
                                otp: _otpController.text));
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 35.h),
                    LoginButton(
                        buttonText: 'Enter',
                        onTapButton: () {
                          setState(() {
                            error = null;
                          });
                          if (_otpKey.currentState!.validate()) {
                            bloc.add(VerifyOtpEvent(
                                email: widget.signUpStep2Args.emailAddress,
                                otp: _otpController.text));
                          }
                        }),
                    const Spacer(),
                    Text(
                      (_countDown != null) ? _countDown! : '',
                      style: TextStyle(
                        fontSize: AppDimensions.kFontSize12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.colorBlack,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 17.h),
                    IgnorePointer(
                      ignoring: !_isCountDownFinished,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Didn’t you receive the OTP?   ',
                            style: TextStyle(
                              color: _isCountDownFinished
                                  ? AppColors.loginTitleColor
                                  : AppColors.profileArrowColor,
                              fontSize: AppDimensions.kFontSize12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _otpController.clear();
                              });
                              bloc.add(SendOtpEvent(
                                email: widget.signUpStep2Args.emailAddress,
                                isForgotPassword: true,
                              ));
                            },
                            child: Text(
                              'Resend',
                              style: TextStyle(
                                color: _isCountDownFinished
                                    ? AppColors.primaryGreen
                                    : AppColors.profileArrowColor,
                                fontSize: AppDimensions.kFontSize12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50.h),
                  ],
                ),
              ),
            ],
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
