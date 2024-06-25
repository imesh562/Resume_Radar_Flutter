import 'dart:io';
import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as bs;
import 'package:resume_radar/utils/app_images.dart';

import '../../../core/configurations/app_config.dart';
import '../../../core/service/dependency_injection.dart';
import '../../../flavors/flavor_banner.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_dimensions.dart';
import '../../../utils/enums.dart';
import '../../data/datasources/shared_preference.dart';
import '../bloc/base_bloc.dart';
import '../bloc/base_event.dart';
import '../bloc/base_state.dart';
import '../common/app_button.dart';
import '../common/app_button_outline.dart';

abstract class BaseView extends StatefulWidget {
  BaseView({Key? key}) : super(key: key);
}

abstract class BaseViewState<Page extends BaseView> extends State<Page> {
  final appSharedData = injection<AppSharedData>();

  Base<BaseEvent, BaseState<dynamic>> getBloc();

  Widget buildView(BuildContext context);

  bool _isProgressShow = false;

  @override
  void initState() {
    super.initState();
    if (AppConfig.deviceOS == DeviceOS.ANDROID) {
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return FlavorBanner(
      child: BlocProvider<Base>(
        create: (_) => getBloc(),
        child: BlocListener<Base, BaseState>(
          listener: (context, state) {
            if (state is APILoadingState) {
              showProgressBar();
            } else {
              hideProgressBar();
              if (state is APIFailureState) {
                showSnackBar(state.errorResponseModel.responseError ?? '',
                    AlertType.FAIL);
              } else if (state is AuthorizedFailureState) {
                if (state.isSplash) {
                  logOut();

                  /// Navigate to login screen.
                } else {
                  showAppDialog(
                    description: state.errorResponseModel.responseError,
                    onPositiveCallback: () {
                      logOut();

                      /// Navigate to login screen.
                    },
                  );
                }
              }
            }
          },
          child: Listener(
            child: Container(
                margin: EdgeInsets.only(bottom: Platform.isIOS ? 5.h : 0),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: buildView(context),
                )),
          ),
        ),
      ),
    );
  }

  void logOut() {
    setState(() {
      if (appSharedData.hasAppToken()) {
        appSharedData.clearAppToken();
      }
    });
  }

  void showAppDialog({
    String? title,
    String? description,
    Color? descriptionColor,
    String? positiveButtonText,
    String? negativeButtonText,
    VoidCallback? onPositiveCallback,
    VoidCallback? onNegativeCallback,
    bool? isDismissible,
  }) {
    bs.showMaterialModalBottomSheet(
      context: context,
      expand: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            if (isDismissible != null && isDismissible) {
              return true;
            } else {
              return false;
            }
          },
          child: Container(
            constraints: BoxConstraints(
              maxHeight: 236.h,
            ),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppColors.colorWhite,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.colorBlack.withOpacity(0.35),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 0.5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                Center(
                  child: Container(
                    height: 4.h,
                    width: 35.w,
                    decoration: BoxDecoration(
                      color: AppColors.colorImagePlaceholder,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                ),
                if (title != null)
                  Column(
                    children: [
                      SizedBox(height: 24.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Text(
                          title ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppDimensions.kFontSize14,
                            fontWeight: FontWeight.w600,
                            color: descriptionColor ?? AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 24.h),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.w),
                            child: Text(
                              description ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: AppDimensions.kFontSize12,
                                fontWeight: FontWeight.w400,
                                color: descriptionColor ?? AppColors.darkGrey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 27.w),
                        child: Row(
                          mainAxisAlignment: negativeButtonText != null
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.center,
                          children: [
                            if (negativeButtonText != null)
                              AppButtonOutline(
                                buttonText: negativeButtonText,
                                onTapButton: onNegativeCallback ??
                                    () {
                                      Navigator.pop(context);
                                    },
                                width: 164.w,
                              ),
                            AppButton(
                              buttonText: positiveButtonText ?? 'Ok',
                              onTapButton: onPositiveCallback ??
                                  () {
                                    Navigator.pop(context);
                                  },
                              width: 164.w,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h)
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void showCustomDialog(Widget child) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 31.w),
            decoration: BoxDecoration(
              color: AppColors.colorWhite,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.colorBlack.withOpacity(0.35),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 0.5),
                ),
              ],
            ),
            child: IntrinsicHeight(child: child),
          );
        });
      },
    );
  }

  showProgressBar() {
    if (!_isProgressShow) {
      _isProgressShow = true;
      showGeneralDialog(
          context: context,
          barrierDismissible: false,
          transitionBuilder: (context, a1, a2, widget) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Transform.scale(
                scale: a1.value,
                child: Opacity(
                  opacity: a1.value,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      alignment: FractionalOffset.center,
                      child: Wrap(
                        children: [
                          Container(
                            color: Colors.transparent,
                            child: SpinKitFadingFour(
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return const SizedBox.shrink();
          });
    }
  }

  hideProgressBar() {
    if (_isProgressShow) {
      Navigator.pop(context);
      _isProgressShow = false;
    }
  }

  showSnackBar(String message, AlertType alertType) {
    Flushbar flushBar = Flushbar(
      duration: const Duration(seconds: 2),
      messageColor: AppColors.colorWhite,
      isDismissible: true,
      messageText: Text(
        message,
        style: TextStyle(
          fontSize: AppDimensions.kFontSize14,
          fontWeight: FontWeight.w400,
          color: AppColors.colorWhite,
        ),
      ),
      boxShadows: const [
        BoxShadow(
          color: Color(0x0E0E0E40),
          spreadRadius: 0,
          blurRadius: 10,
          offset: Offset(0, 0),
        ),
      ],
      padding: EdgeInsets.symmetric(vertical: 13.5.h, horizontal: 26.w),
      mainButton: Image.asset(
        AppImages.icCross,
        height: 16.h,
      ),
      icon: alertType == AlertType.FAIL
          ? Image.asset(
              AppImages.icWarningRounded,
              height: 25.h,
            )
          : alertType == AlertType.SUCCESS
              ? Image.asset(
                  AppImages.icSuccessRounded,
                  height: 25.h,
                )
              : Image.asset(
                  AppImages.icWarningRounded,
                  height: 25.h,
                ),
      backgroundColor: alertType == AlertType.FAIL
          ? AppColors.errorRed
          : alertType == AlertType.SUCCESS
              ? AppColors.waitingTimeColor
              : AppColors.warningColor,
    );
    if (!flushBar.isAppearing() &&
        !flushBar.isShowing() &&
        !flushBar.isHiding()) {
      flushBar.show(context);
    }
  }
}
