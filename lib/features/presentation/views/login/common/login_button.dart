import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resume_radar/utils/app_dimensions.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/enums.dart';

class LoginButton extends StatefulWidget {
  final Function onTapButton;
  final ButtonType buttonType;
  final String buttonText;

  LoginButton({
    required this.onTapButton,
    this.buttonType = ButtonType.ENABLED,
    required this.buttonText,
  });

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 11.5.h),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6.r)),
          color: widget.buttonType == ButtonType.DISABLED
              ? AppColors.disableButtonColor
              : null,
          gradient: widget.buttonType == ButtonType.ENABLED
              ? const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.mainGradient1,
                    AppColors.mainGradient2,
                  ],
                  stops: [0.0478, 0.9548],
                )
              : null,
          boxShadow: widget.buttonType == ButtonType.ENABLED
              ? [
                  BoxShadow(
                    offset: const Offset(0, 18),
                    blurRadius: 7.3,
                    spreadRadius: -13,
                    color: AppColors.loginButtonShadow.withOpacity(0.33),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            widget.buttonText,
            style: TextStyle(
                color: widget.buttonType == ButtonType.ENABLED
                    ? AppColors.colorWhite
                    : AppColors.colorWhite.withAlpha(180),
                fontWeight: FontWeight.w600,
                fontSize: AppDimensions.kFontSize14),
          ),
        ),
      ),
      onTap: () {
        if (widget.buttonType == ButtonType.ENABLED) {
          widget.onTapButton();
        }
      },
    );
  }
}
