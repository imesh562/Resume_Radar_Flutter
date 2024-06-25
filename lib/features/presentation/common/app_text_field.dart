import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resume_radar/utils/app_dimensions.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/enums.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final Widget? icon;
  final Widget? action;
  final String? hint;
  final String? helpText;
  final Function(String)? onTextChanged;
  final Function()? onFocusLoss;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final bool? isEnable;
  final bool? changeColorOnDisable;
  final bool? isRequired;
  final bool? showError;
  final int? maxLength;
  final String? label;
  final bool? obscureText;
  final bool? shouldRedirectToNextField;
  final String? initialValue;
  final int? maxLines;
  final bool? isCurrency;
  final FocusNode? focusNode;
  final FilterType? filterType;
  final Function(String)? onSubmit;
  final TextInputFormatter? textInputFormatter;
  final GlobalKey<FormFieldState<String>>? fieldKey;
  final String? titleImage;
  final bool isPreLogin;
  final bool isFormField;
  final Color? iconColor;
  final Color? bgColor;

  AppTextField({
    this.controller,
    this.icon,
    this.action,
    this.hint,
    this.helpText,
    this.label,
    this.isRequired = false,
    this.showError = true,
    this.maxLength = 250,
    this.maxLines = 1,
    this.onTextChanged,
    this.onFocusLoss,
    this.inputType,
    this.focusNode,
    this.validator,
    this.onSubmit,
    this.initialValue,
    this.filterType,
    this.isEnable = true,
    this.changeColorOnDisable = false,
    this.obscureText = false,
    this.isCurrency = false,
    this.shouldRedirectToNextField = true,
    this.textInputFormatter,
    this.fieldKey,
    this.titleImage,
    this.isPreLogin = false,
    this.isFormField = false,
    this.iconColor,
    this.bgColor,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  int totalCount = 0;
  TextEditingController? _controller;
  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      if (widget.initialValue != null) {
        widget.controller!.text = widget.initialValue!;
      }
      _controller = widget.controller;
    } else {
      if (widget.initialValue != null) {
        _controller = TextEditingController(text: widget.initialValue);
      } else {
        _controller = TextEditingController();
      }
    }

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode;
    } else {
      _focusNode = FocusNode();
    }

    _focusNode!.addListener(() {
      if (!_focusNode!.hasFocus) {
        if (widget.onFocusLoss != null) {
          widget.onFocusLoss!();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 6.w, bottom: 6.h, right: 6.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.titleImage != null)
                Row(
                  children: [
                    Image.asset(
                      widget.titleImage!,
                      height: 20.h,
                      opacity: widget.changeColorOnDisable!
                          ? const AlwaysStoppedAnimation(.4)
                          : null,
                    ),
                    SizedBox(width: 4.w),
                  ],
                ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: (widget.label != null ? widget.label! : ''),
                    style: TextStyle(
                      fontSize: AppDimensions.kFontSize14,
                      fontWeight: FontWeight.w400,
                      color: widget.isPreLogin
                          ? widget.changeColorOnDisable!
                              ? AppColors.textFieldTitleColor.withOpacity(0.4)
                              : AppColors.textFieldTitleColor
                          : widget.changeColorOnDisable!
                              ? AppColors.matteBlack.withOpacity(0.4)
                              : AppColors.matteBlack,
                    ),
                    children: [
                      TextSpan(
                        text: widget.isRequired! ? ' \u2217' : '',
                        style: TextStyle(
                          fontSize: AppDimensions.kFontSize14,
                          fontWeight: FontWeight.w400,
                          color: widget.isPreLogin
                              ? widget.changeColorOnDisable!
                                  ? AppColors.textFieldTitleColor
                                      .withOpacity(0.4)
                                  : AppColors.textFieldTitleColor
                              : widget.changeColorOnDisable!
                                  ? AppColors.matteBlack.withOpacity(0.4)
                                  : AppColors.matteBlack,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (widget.helpText != null && widget.helpText! != '')
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
                      color: widget.isPreLogin
                          ? widget.changeColorOnDisable!
                              ? AppColors.textFieldTitleColor.withOpacity(0.4)
                              : AppColors.textFieldTitleColor
                          : widget.changeColorOnDisable!
                              ? AppColors.colorWhite.withOpacity(0.4)
                              : AppColors.colorWhite,
                      fontSize: AppDimensions.kFontSize12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  child: Icon(
                    Icons.info,
                    color: widget.isPreLogin
                        ? widget.changeColorOnDisable!
                            ? AppColors.textFieldTitleColor.withOpacity(0.4)
                            : AppColors.textFieldTitleColor
                        : widget.changeColorOnDisable!
                            ? AppColors.matteBlack.withOpacity(0.4)
                            : AppColors.matteBlack,
                    size: 14.w,
                  ),
                )
            ],
          ),
        ),
        TextFormField(
          onChanged: (text) {
            if (widget.isCurrency!) {
              int commaCount = text.split(',').length - 1;
              int dotCount = text.split('.').length - 1;
              setState(() {
                totalCount = commaCount + dotCount;
              });
            }
            if (widget.onTextChanged != null) {
              widget.onTextChanged!(text);
            }
          },
          key: widget.fieldKey,
          validator: widget.validator,
          onFieldSubmitted: (value) {
            if (widget.onSubmit != null) widget.onSubmit!(value);
          },
          focusNode: _focusNode,
          controller: _controller,
          obscureText: widget.obscureText!,
          textInputAction: widget.shouldRedirectToNextField!
              ? TextInputAction.next
              : TextInputAction.done,
          enabled: widget.isEnable,
          maxLines: widget.maxLines,
          textCapitalization: TextCapitalization.sentences,
          maxLength: widget.isCurrency!
              ? widget.maxLength != null
                  ? widget.maxLength! + totalCount
                  : null
              : widget.maxLength,
          inputFormatters: [
            if (widget.isCurrency!) CurrencyTextInputFormatter(symbol: ''),
            if (widget.textInputFormatter != null) widget.textInputFormatter!,
            if (widget.filterType == FilterType.TYPE1)
              FilteringTextInputFormatter.allow(
                RegExp(r'^[0-9,.]*$'), // Allow digits, dots, and commas.
              ),
            if (widget.filterType == FilterType.TYPE2)
              FilteringTextInputFormatter.allow(
                RegExp(
                    r'[a-zA-Z\s]'), // Allow only, a to z, A to Z or a whitespace.
              ),
            if (widget.filterType == FilterType.TYPE3)
              FilteringTextInputFormatter.allow(
                RegExp(
                    r'[a-zA-Z0-9\s]'), // Allow only, a to z, A to Z or a whitespace and digits.
              ),
            if (widget.filterType == FilterType.TYPE4)
              FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9]')), // Only allow digits
            if (widget.filterType == FilterType.TYPE5)
              FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+\.?\d{0,2}')), // Allow integer or double
            if (widget.filterType == FilterType.TYPE6)
              FilteringTextInputFormatter.allow(
                  RegExp(r'[^\d]')) // Allow anything except numbers
          ],
          style: TextStyle(
            fontSize: AppDimensions.kFontSize14,
            fontWeight: widget.isPreLogin ? FontWeight.w500 : FontWeight.w600,
            color: widget.isPreLogin
                ? widget.changeColorOnDisable!
                    ? AppColors.loginTitleColor.withOpacity(0.4)
                    : AppColors.loginTitleColor
                : widget.changeColorOnDisable!
                    ? AppColors.matteBlack.withOpacity(0.4)
                    : AppColors.matteBlack,
          ),
          keyboardType: widget.inputType ?? TextInputType.text,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(left: 11.w, top: 11.5.h, bottom: 11.5.h),
            isDense: true,
            counterText: "",
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(6.r),
              ),
              borderSide: widget.bgColor == null
                  ? BorderSide(
                      color: widget.isPreLogin
                          ? widget.changeColorOnDisable!
                              ? AppColors.loginTitleColor.withOpacity(0.2)
                              : AppColors.checkBoxBorder
                          : widget.changeColorOnDisable!
                              ? AppColors.lightGrey.withOpacity(0.2)
                              : AppColors.lightGrey,
                      width: 0.75.w,
                    )
                  : BorderSide(
                      width: 0,
                      color: widget.bgColor!.withOpacity(0.15),
                    ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(6.r),
              ),
              borderSide: BorderSide(
                color: widget.isPreLogin
                    ? widget.changeColorOnDisable!
                        ? AppColors.loginTitleColor.withOpacity(0.2)
                        : AppColors.checkBoxBorder
                    : widget.changeColorOnDisable!
                        ? AppColors.lightGrey.withOpacity(0.2)
                        : AppColors.lightGrey,
                width: 0.75.w,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(6.r),
              ),
              borderSide: BorderSide(
                color: widget.isPreLogin
                    ? widget.changeColorOnDisable!
                        ? AppColors.loginTitleColor.withOpacity(0.2)
                        : AppColors.checkBoxBorder
                    : widget.changeColorOnDisable!
                        ? AppColors.lightGrey.withOpacity(0.2)
                        : AppColors.lightGrey,
                width: 0.75.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(6.r),
              ),
              borderSide: BorderSide(
                color: widget.isPreLogin
                    ? widget.changeColorOnDisable!
                        ? AppColors.loginTitleColor.withOpacity(0.2)
                        : AppColors.checkBoxBorder
                    : widget.changeColorOnDisable!
                        ? AppColors.lightGrey.withOpacity(0.2)
                        : AppColors.lightGrey,
                width: 0.75.w,
              ),
            ),
            focusedErrorBorder: widget.showError!
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.r),
                    ),
                    borderSide: BorderSide(
                      color: AppColors.errorRed,
                      width: 0.75.w,
                    ),
                  )
                : OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.r),
                    ),
                    borderSide: BorderSide(
                      color: widget.isPreLogin
                          ? widget.changeColorOnDisable!
                              ? AppColors.loginTitleColor.withOpacity(0.2)
                              : AppColors.checkBoxBorder
                          : widget.changeColorOnDisable!
                              ? AppColors.lightGrey.withOpacity(0.2)
                              : AppColors.lightGrey,
                      width: 0.75.w,
                    ),
                  ),
            errorBorder: widget.showError!
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.r),
                    ),
                    borderSide: BorderSide(
                      color: AppColors.errorRed,
                      width: 0.75.w,
                    ),
                  )
                : OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.r),
                    ),
                    borderSide: BorderSide(
                      color: widget.isPreLogin
                          ? widget.changeColorOnDisable!
                              ? AppColors.loginTitleColor.withOpacity(0.2)
                              : AppColors.checkBoxBorder
                          : widget.changeColorOnDisable!
                              ? AppColors.lightGrey.withOpacity(0.2)
                              : AppColors.lightGrey,
                      width: 0.75.w,
                    ),
                  ),
            errorMaxLines: 2,
            errorStyle: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: AppDimensions.kFontSize10,
              fontWeight: FontWeight.w400,
              color: AppColors.errorRed,
            ),
            prefixIcon: widget.icon,
            prefixIconConstraints: BoxConstraints(minWidth: 55.w),
            suffixIconConstraints:
                BoxConstraints(minWidth: 24.w, maxHeight: 24.h),
            suffixIcon: widget.action,
            filled: true,
            hintText: widget.hint,
            hintStyle: TextStyle(
                color: widget.isPreLogin
                    ? AppColors.loginSubTitleColor
                    : AppColors.darkStrokeGrey,
                fontSize: AppDimensions.kFontSize12,
                fontWeight: FontWeight.w400),
            fillColor: widget.isPreLogin
                ? AppColors.colorWhite
                : widget.bgColor != null
                    ? widget.bgColor!.withOpacity(0.15)
                    : AppColors.colorWhite,
          ),
        ),
      ],
    );
  }
}
