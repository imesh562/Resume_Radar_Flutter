import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/navigation_routes.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../../bloc/user/user_bloc.dart';
import '../../common/app_text_field.dart';
import '../base_view.dart';
import '../login/common/login_button.dart';
import '../login/common/login_password_field.dart';
import '../success_view/success_view.dart';

class SignUpStep3Args {
  final String email;

  SignUpStep3Args({
    required this.email,
  });
}

class SignUpStep3View extends BaseView {
  final SignUpStep3Args signUpStep3Args;
  SignUpStep3View({required this.signUpStep3Args});

  @override
  State<SignUpStep3View> createState() => _SignUpStep3ViewState();
}

class _SignUpStep3ViewState extends BaseViewState<SignUpStep3View> {
  var bloc = injection<UserBloc>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _newPasswordKey = GlobalKey<FormState>();
  final _confirmPasswordKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  PhoneNumber? phoneNumber;
  final focusNode = FocusNode();

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      body: BlocProvider<UserBloc>(
        create: (_) => bloc,
        child: BlocListener<UserBloc, BaseState<UserState>>(
            listener: (_, state) {
              if (state is UserRegisterSuccessState) {
                Navigator.pushNamed(
                  context,
                  Routes.kSuccessView,
                  arguments: SuccessViewArgs(
                    onTapButton: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, Routes.kLoginView, (route) => false);
                    },
                    title: 'Your account has been\ncreated successfully',
                    buttonTitle: 'Back to login',
                    subTitle: "Welcome aboard! Your account setup is complete",
                  ),
                );
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 74.h),
                          Image.asset(
                            AppImages.appIcon,
                            height: 60.h,
                          ),
                          SizedBox(height: 42.85.h),
                          Text(
                            'Let’s setup your account',
                            style: TextStyle(
                              fontSize: AppDimensions.kFontSize20,
                              color: AppColors.appButtonGradient1,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 32.h),
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                AppTextField(
                                  label: 'Full name',
                                  isRequired: true,
                                  hint: 'Enter full name',
                                  filterType: FilterType.TYPE6,
                                  controller: firstNameController,
                                  maxLength: 60,
                                  inputType: TextInputType.name,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'First name required!';
                                    } else if (value.length < 3) {
                                      return 'First name is invalid!';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 24.h),
                                AppTextField(
                                  label: 'Last name',
                                  hint: 'Enter Last name',
                                  filterType: FilterType.TYPE6,
                                  controller: lastNameController,
                                  maxLength: 120,
                                  inputType: TextInputType.name,
                                ),
                                SizedBox(height: 24.h),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Form(
                            key: _newPasswordKey,
                            child: LoginPasswordField(
                              guideTitle: 'New password',
                              hint: 'Minimum 6 characters',
                              controller: _newPasswordController,
                              textInputFormatter:
                                  FilteringTextInputFormatter.deny(
                                      RegExp(r'\s')),
                              isRequired: true,
                              isPreLogin: true,
                              maxLines: 1,
                              maxLength: 60,
                              validator: (value) {
                                if (_newPasswordController.text.isEmpty) {
                                  return "Password is required!";
                                } else if (checkPassword(
                                    _newPasswordController.text)) {
                                  return "Passwords must contain at least one capital letter and one number!";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Form(
                            key: _confirmPasswordKey,
                            child: LoginPasswordField(
                              guideTitle: 'Re-enter new password',
                              hint: 'Minimum 6 characters',
                              controller: _confirmPasswordController,
                              textInputFormatter:
                                  FilteringTextInputFormatter.deny(
                                      RegExp(r'\s')),
                              isRequired: true,
                              isPreLogin: true,
                              maxLines: 1,
                              maxLength: 60,
                              validator: (value) {
                                if (_confirmPasswordController.text.isEmpty) {
                                  return "Password is required!";
                                } else if (_confirmPasswordController.text !=
                                    _newPasswordController.text) {
                                  return 'Passwords does not match!';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 56.h),
                          LoginButton(
                              buttonText: 'Done',
                              onTapButton: () {
                                bool isBasicInfoValid =
                                    formKey.currentState!.validate();
                                bool isNewPasswordValid =
                                    _newPasswordKey.currentState!.validate();
                                bool isConfirmPasswordValid =
                                    _confirmPasswordKey.currentState!
                                        .validate();
                                if (isNewPasswordValid &&
                                    isConfirmPasswordValid &&
                                    isBasicInfoValid) {
                                  bloc.add(UserRegisterEvent(
                                    email: widget.signUpStep3Args.email,
                                    password: _confirmPasswordController.text,
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                  ));
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
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

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}
