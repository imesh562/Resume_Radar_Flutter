import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resume_radar/features/presentation/bloc/otp/otp_bloc.dart';
import 'package:resume_radar/features/presentation/views/sign_up/sign_up_step2.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/navigation_routes.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../../common/app_text_field.dart';
import '../../common/appbar.dart';
import '../base_view.dart';
import '../login/common/login_button.dart';

class SignUpStep1View extends BaseView {
  @override
  State<SignUpStep1View> createState() => _SignUpStep1ViewState();
}

class _SignUpStep1ViewState extends BaseViewState<SignUpStep1View> {
  var bloc = injection<OtpBloc>();
  final _emailController = TextEditingController();
  final _emailKey = GlobalKey<FormState>();

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
            if (state is CheckEmailSuccessState) {
              bloc.add(SendOtpEvent(
                email: _emailController.text,
                isForgotPassword: true,
              ));
            } else if (state is SendOtpSuccessState) {
              Navigator.pushNamed(
                context,
                Routes.kSignUpStep2,
                arguments: SignUpStep2Args(emailAddress: _emailController.text),
              );
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
                    SizedBox(height: 12.05.h),
                    Text(
                      'Check your email',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: AppDimensions.kFontSize20,
                        color: AppColors.loginTitleColor,
                      ),
                    ),
                    SizedBox(height: 21.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 23.w),
                      child: Text(
                        'Please enter your email address to check if you are registered.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: AppDimensions.kFontSize14,
                          color: AppColors.textFieldTitleColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 56.h),
                    Form(
                      key: _emailKey,
                      child: AppTextField(
                        label: 'Email',
                        hint: 'Enter your email',
                        controller: _emailController,
                        isRequired: true,
                        isPreLogin: true,
                        maxLines: 1,
                        maxLength: 100,
                        titleImage: AppImages.icEmail,
                        inputType: TextInputType.emailAddress,
                        textInputFormatter: FilteringTextInputFormatter.deny(
                            RegExp(r'[^\w.@]')),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email is required!";
                          } else if (!EmailValidator.validate(value)) {
                            return "Email is invalid!";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 35.h),
                    LoginButton(
                      buttonText: 'Check',
                      onTapButton: () {
                        bool isEmailValid = _emailKey.currentState!.validate();
                        if (isEmailValid) {
                          bloc.add(
                              CheckEmailEvent(email: _emailController.text));
                        }
                      },
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                              color: AppColors.loginTitleColor,
                              fontSize: AppDimensions.kFontSize14,
                              fontWeight: FontWeight.w400),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, Routes.kLoginView, (route) => false);
                          },
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              color: AppColors.primaryGreen,
                              fontSize: AppDimensions.kFontSize14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 35.h),
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
