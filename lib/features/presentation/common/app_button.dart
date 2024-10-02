import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_dimensions.dart';
import '../../../utils/enums.dart';

class AppButton extends StatefulWidget {
  final String buttonText;
  final Function onTapButton;
  final double width;
  final ButtonType buttonType;
  final Widget? prefixIcon;
  final Color? buttonColor;
  final Color? textColor;

  AppButton(
      {required this.buttonText,
      required this.onTapButton,
      this.width = 0,
      this.prefixIcon,
      this.buttonColor,
      this.textColor,
      this.buttonType = ButtonType.ENABLED});

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 13.5.h),
        width: widget.width == 0 ? double.infinity : widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6.r)),
          color: widget.buttonColor != null
              ? widget.buttonType == ButtonType.ENABLED
                  ? widget.buttonColor
                  : AppColors.profileArrowColor
              : AppColors.primaryGreen,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.prefixIcon ?? const SizedBox.shrink(),
              widget.prefixIcon != null
                  ? SizedBox(width: 5.w)
                  : const SizedBox.shrink(),
              Text(
                widget.buttonText,
                style: TextStyle(
                    color: widget.buttonType == ButtonType.ENABLED
                        ? widget.textColor ?? AppColors.colorWhite
                        : widget.textColor != null
                            ? widget.textColor!.withAlpha(180)
                            : AppColors.colorWhite.withAlpha(180),
                    fontWeight: FontWeight.w600,
                    fontSize: AppDimensions.kFontSize14),
              ),
            ],
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
