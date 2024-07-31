import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resume_radar/utils/app_dimensions.dart';
import 'package:resume_radar/utils/app_images.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/navigation_routes.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../../bloc/user/user_bloc.dart';
import '../../common/app_text_field.dart';
import '../base_view.dart';
import 'common/login_button.dart';
import 'common/login_password_field.dart';

class LoginView extends BaseView {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _SplashViewState();
}

class _SplashViewState extends BaseViewState<LoginView> {
  var bloc = injection<UserBloc>();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _fetchPushID();
    updateUI();
  }

  updateUI() {
    setState(() {
      if (appSharedData.hasRememberMe()) {
        _rememberMe = appSharedData.getRememberMe();
      }
      if (_rememberMe) {
        _emailController.text = appSharedData.getEmail()!;
        _passwordController.text = appSharedData.getPassword()!;
      }
    });
  }

  _fetchPushID() async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!appSharedData.hasPushToken()) {
        showProgressBar();
        FirebaseMessaging.instance.deleteToken().then((value) {
          hideProgressBar();
          if (appSharedData.getPushToken()!.isEmpty) {
            showProgressBar();
            FirebaseMessaging.instance.getToken().then((token) {
              hideProgressBar();
              if (token != null) {
                log(token ?? '');
                appSharedData.setPushToken(token ?? '');
              }
            });
          }
        });
      }
    });
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      resizeToAvoidBottomInset: false,
      body: BlocProvider<UserBloc>(
        create: (_) => bloc,
        child: BlocListener<UserBloc, BaseState<UserState>>(
          listener: (_, state) {
            if (state is LoginSuccessState) {
              bloc.add(AuthUserEvent(shouldShowProgress: false));
            } else if (state is AuthUserSuccessState) {
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.kDashboardView, (route) => false);
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
                padding: EdgeInsets.symmetric(horizontal: 33.w),
                child: Column(
                  children: [
                    SizedBox(height: 142.h),
                    Image.asset(
                      AppImages.appIcon,
                      height: 39.h,
                    ),
                    SizedBox(height: 14.05.h),
                    Text(
                      'Log in to Continue',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: AppDimensions.kFontSize20,
                        color: AppColors.loginTitleColor,
                      ),
                    ),
                    SizedBox(height: 55.h),
                    Form(
                      key: _emailKey,
                      child: AppTextField(
                        label: 'Email',
                        hint: 'Enter your email',
                        controller: _emailController,
                        titleImage: AppImages.icEmail,
                        isRequired: true,
                        isPreLogin: true,
                        maxLines: 1,
                        maxLength: 100,
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
                    SizedBox(height: 16.h),
                    Form(
                      key: _passwordKey,
                      child: LoginPasswordField(
                        guideTitle: 'Password',
                        hint: 'Enter your password',
                        controller: _passwordController,
                        isRequired: true,
                        maxLines: 1,
                        textInputFormatter:
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        isPreLogin: true,
                        maxLength: 60,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required!";
                          }
                          if (checkPassword(value)) {
                            return "Password is invalid!";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: AppColors.checkBoxBorder,
                            ),
                            child: Checkbox(
                              value: _rememberMe,
                              activeColor: AppColors.primaryGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              side: BorderSide(
                                color: AppColors.checkBoxBorder,
                                width: 0.75.w,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Remember Me',
                          style: TextStyle(
                              color: AppColors.textFieldTitleColor,
                              fontSize: AppDimensions.kFontSize12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 35.h),
                    LoginButton(
                        buttonText: 'Log In',
                        onTapButton: () {
                          bool isEmailValid =
                              _emailKey.currentState!.validate();
                          bool isPasswordValid =
                              _passwordKey.currentState!.validate();
                          if (isEmailValid && isPasswordValid) {
                            bloc.add(
                              UserLoginEvent(
                                userName: _emailController.text,
                                password: _passwordController.text,
                                rememberMe: _rememberMe,
                              ),
                            );
                          }
                        }),
                    const Spacer(),
                    Text(
                      '© ${DateTime.now().year} Neztdo Corporation',
                      style: TextStyle(
                        color: AppColors.lightGrey,
                        fontSize: AppDimensions.kFontSize12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 27.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            ///TODO: Add the link.
                          },
                          child: Text(
                            '•  Terms & Conditions',
                            style: TextStyle(
                              color: AppColors.lightGrey,
                              fontSize: AppDimensions.kFontSize10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            ///TODO: Add the link.
                          },
                          child: Text(
                            '•  Privacy Policy',
                            style: TextStyle(
                              color: AppColors.lightGrey,
                              fontSize: AppDimensions.kFontSize10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool checkPassword(String password) {
    RegExp regex = RegExp(r'^(?=.*[A-Z])(?=.*[0-9]).{6,}$');
    if (!regex.hasMatch(password)) {
      return true;
    } else {
      return false;
    }
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
