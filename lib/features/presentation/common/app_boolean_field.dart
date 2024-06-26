import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_dimensions.dart';

class AppBooleanField extends StatefulWidget {
  final String? helpText;
  final Function(bool)? onChange;
  final bool isEnable;
  final String? label;
  final bool? initialValue;
  final bool isRequired;
  final Color? iconColor;

  const AppBooleanField({
    this.helpText,
    this.onChange,
    this.isEnable = true,
    this.isRequired = false,
    this.label,
    this.initialValue,
    this.iconColor,
  });

  @override
  State<AppBooleanField> createState() => _AppBooleanFieldState();
}

class _AppBooleanFieldState extends State<AppBooleanField> {
  bool groupValue = false;
  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      groupValue = widget.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 6.w, bottom: 6.h, right: 6.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(width: 6.w),
                Text(
                  (widget.label != null ? widget.label! : ''),
                  style: TextStyle(
                    fontSize: AppDimensions.kFontSize14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.matteBlack,
                  ),
                ),
                Baseline(
                  baseline: 6.h,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    widget.isRequired ? ' \u2217' : '',
                    style: TextStyle(
                      fontSize: AppDimensions.kFontSize14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.matteBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              if (widget.helpText != null && widget.helpText! != '')
                Row(
                  children: [
                    SuperTooltip(
                      showBarrier: true,
                      arrowLength: 5,
                      arrowBaseWidth: 5,
                      arrowTipDistance: 5,
                      hasShadow: false,
                      barrierColor: AppColors.colorTransparent,
                      backgroundColor: AppColors.matteBlack,
                      content: Text(
                        widget.helpText!,
                        softWrap: true,
                        style: TextStyle(
                          color: AppColors.colorWhite,
                          fontSize: AppDimensions.kFontSize12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      child: Icon(
                        Icons.info,
                        color: AppColors.matteBlack,
                        size: 14.w,
                      ),
                    ),
                    SizedBox(width: 5.w),
                  ],
                ),
              SizedBox(
                height: 30.h,
                width: 40.w,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: CupertinoSwitch(
                    value: groupValue,
                    activeColor: AppColors.primaryGreen,
                    trackColor: AppColors.colorImagePlaceholder,
                    onChanged: (value) {
                      if (widget.isEnable) {
                        setState(() {
                          groupValue = value;
                        });
                        if (widget.onChange != null) {
                          widget.onChange!(groupValue);
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
