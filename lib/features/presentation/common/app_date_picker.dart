import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:resume_radar/utils/app_dimensions.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';

class AppDatePicker extends StatefulWidget {
  final String? hint;
  final String? helpText;
  String? Function(String?)? validator;
  final bool? isEnable;
  final bool? isRequired;
  final bool? showIcon;
  final bool? showClear;
  final Function()? onClear;
  final String? label;
  final String? titleImage;
  final String? format;
  final DateTime? initialValue;
  final DateTime? lastDate;
  final DateTime? firstDate;
  final Function(DateTime?)? onSelect;
  final GlobalKey<FormFieldState<String>>? fieldKey;
  final bool isFormField;
  final Color? iconColor;
  final Color? bgColor;

  AppDatePicker({
    this.hint,
    this.helpText,
    this.label,
    this.titleImage,
    this.format,
    this.isRequired = false,
    this.validator,
    this.onSelect,
    this.initialValue,
    this.isEnable = true,
    this.showIcon = true,
    this.showClear = false,
    this.lastDate,
    this.firstDate,
    this.fieldKey,
    this.isFormField = false,
    this.iconColor,
    this.bgColor,
    this.onClear,
  });

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  TextEditingController? _controller;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller = TextEditingController(
          text: DateFormat(widget.format != null
                  ? getFormat(widget.format!)
                  : 'dd/MM/yyyy')
              .format(widget.initialValue!));
    } else {
      _controller = TextEditingController();
    }
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
                      color: AppColors.matteBlack,
                    ),
                    children: [
                      TextSpan(
                        text: widget.isRequired! ? ' \u2217' : '',
                        style: TextStyle(
                          fontSize: AppDimensions.kFontSize14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.matteBlack,
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
                )
            ],
          ),
        ),
        Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (widget.isEnable!) {
                  _selectDate(context);
                }
              },
              child: TextFormField(
                validator: widget.validator,
                controller: _controller,
                key: widget.fieldKey,
                enabled: false,
                textAlignVertical: TextAlignVertical.bottom,
                style: TextStyle(
                  fontSize: AppDimensions.kFontSize14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.matteBlack,
                ),
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
                            color: widget.bgColor != null
                                ? widget.bgColor!.withOpacity(0.15)
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
                      color: AppColors.lightGrey,
                      width: 0.75.w,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.r),
                    ),
                    borderSide: BorderSide(
                      color: AppColors.lightGrey,
                      width: 0.75.w,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.r),
                    ),
                    borderSide: BorderSide(
                      color: AppColors.lightGrey,
                      width: 0.75.w,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.r),
                    ),
                    borderSide: BorderSide(
                      color: AppColors.errorRed,
                      width: 0.75.w,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.r),
                    ),
                    borderSide: BorderSide(
                      color: AppColors.errorRed,
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
                  suffixIconConstraints: BoxConstraints(maxHeight: 28.h),
                  suffixIcon: widget.showIcon! &&
                          (widget.showClear == false ||
                              _controller!.text.isEmpty)
                      ? Padding(
                          padding: EdgeInsets.only(right: 11.w),
                          child: Image.asset(
                            AppImages.icCalendar,
                            width: 20.w,
                            color: AppColors.lightGrey,
                          ),
                        )
                      : null,
                  filled: true,
                  hintText: widget.hint,
                  hintStyle: TextStyle(
                      color: AppColors.darkStrokeGrey,
                      fontSize: AppDimensions.kFontSize12,
                      fontWeight: FontWeight.w400),
                  fillColor: widget.bgColor != null
                      ? widget.bgColor!.withOpacity(0.15)
                      : AppColors.colorWhite,
                ),
              ),
            ),
            if (widget.showClear != null &&
                widget.showClear! &&
                _controller!.text.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                    height: 40.h,
                    width: 30.w,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _controller!.clear();
                          selectedDate = null;
                          if (widget.onClear != null) {
                            widget.onClear!();
                          }
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 11.w),
                        child: Icon(
                          Icons.close,
                          size: 20.h,
                          color: AppColors.lightGrey,
                        ),
                      ),
                    )),
              )
          ],
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate != null
          ? selectedDate!
          : widget.initialValue ?? DateTime.now(),
      firstDate: widget.firstDate == null ? DateTime(1) : widget.firstDate!,
      lastDate: widget.lastDate == null
          ? DateTime.now().add(const Duration(days: 365 * 1000))
          : widget.lastDate!,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primaryGreen,
            hintColor: AppColors.primaryGreen,
            colorScheme: ColorScheme.light(primary: AppColors.primaryGreen),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        if (selectedDate != null) {
          _controller!.text = DateFormat(widget.format != null
                  ? getFormat(widget.format!.toLowerCase())
                  : 'dd/MM/yyyy')
              .format(selectedDate!);
          if (widget.onSelect != null) {
            widget.onSelect!(selectedDate!);
          }
        }
      });
    } else {
      if (selectedDate == null) {
        if (widget.onSelect != null) {
          widget.onSelect!(null);
        }
      }
    }
  }

  String getFormat(String format) {
    switch (format) {
      case 'DD/MM/YY':
        return 'dd/MM/yyyy';
      case 'MM/DD/YY':
        return 'MM/dd/yyyy';
      case 'YY/DD/MM':
        return 'yyyy/dd/MM';
      case 'YY/MM/DD':
        return 'yyyy/MM/dd';
      default:
        return 'dd/MM/yyyy';
    }
  }
}
