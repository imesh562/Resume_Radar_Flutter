import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:resume_radar/utils/app_dimensions.dart';

import '../../../../../../utils/app_colors.dart';

class PinPutComponent extends StatefulWidget {
  Function(String) onSubmit;
  final TextEditingController? textEditingController;
  final int? length;
  final TextInputType? textInputType;
  final bool obscureText;
  final bool isPreLogin;
  final FocusNode? focusNode;
  final bool forceErrorState;
  final String? Function(String?)? validator;

  PinPutComponent({
    required this.onSubmit,
    this.length = 6,
    this.textEditingController,
    this.textInputType,
    this.validator,
    this.focusNode,
    this.forceErrorState = false,
    this.isPreLogin = false,
    required this.obscureText,
  });

  @override
  State<PinPutComponent> createState() => _PinPutComponentState();
}

class _PinPutComponentState extends State<PinPutComponent> {
  late PinTheme defaultPinTheme;
  late PinTheme errorPinTheme;

  @override
  void initState() {
    super.initState();
    setState(() {
      defaultPinTheme = PinTheme(
        margin: EdgeInsets.only(right: 6.w),
        height: 40.h,
        width: 40.h,
        textStyle: TextStyle(
          fontSize: AppDimensions.kFontSize14,
          color: widget.isPreLogin
              ? AppColors.loginTitleColor
              : AppColors.darkGrey,
          fontWeight: FontWeight.w500,
        ),
        decoration: BoxDecoration(
          color: AppColors.colorWhite,
          border: Border.all(
            color:
                widget.isPreLogin ? AppColors.lightGrey : AppColors.lightGrey,
            width: 0.75.w,
          ),
          borderRadius: BorderRadius.circular(6.r),
        ),
      );

      errorPinTheme = PinTheme(
        margin: EdgeInsets.only(right: 6.w),
        height: 40.h,
        width: 40.h,
        textStyle: TextStyle(
          fontSize: AppDimensions.kFontSize14,
          color: widget.isPreLogin
              ? AppColors.loginTitleColor
              : AppColors.darkGrey,
          fontWeight: FontWeight.w500,
        ),
        decoration: BoxDecoration(
          color: AppColors.colorWhite,
          border: Border.all(
            color: AppColors.errorRed,
            width: 0.75.w,
          ),
          borderRadius: BorderRadius.circular(6.r),
        ),
      );
    });
  }

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, right: 9.w),
      child: Pinput(
        length: widget.length ?? 6,
        errorPinTheme: widget.forceErrorState ? errorPinTheme : defaultPinTheme,
        focusNode: widget.focusNode,
        errorBuilder: (value1, value2) {
          return Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Text(
              value1 ?? '',
              style: TextStyle(
                color: AppColors.errorRed,
                fontSize: AppDimensions.kFontSize10,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        },
        validator: widget.validator,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        autofillHints: const [AutofillHints.oneTimeCode],
        defaultPinTheme: defaultPinTheme,
        onChanged: (value) {
          widget.onSubmit(value);
          HapticFeedback.lightImpact();
        },
        closeKeyboardWhenCompleted: true,
        obscureText: widget.obscureText,
        obscuringWidget: Icon(
          Icons.circle,
          size: 16.h,
          color:
              widget.isPreLogin ? AppColors.colorBlack : AppColors.matteBlack,
        ),
        hapticFeedbackType: HapticFeedbackType.selectionClick,
        keyboardType: widget.textInputType ?? TextInputType.text,
        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        showCursor: true,
        controller: widget.textEditingController ?? _controller,
        onCompleted: (value) {},
      ),
    );
  }
}
