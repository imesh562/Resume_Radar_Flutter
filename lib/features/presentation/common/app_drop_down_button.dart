import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_dimensions.dart';
import '../../domain/entities/common/drop_down_item.dart';
import 'app_dropdown_bootomsheet.dart';

class AppDropDownButton extends StatefulWidget {
  final String? label;
  final String? bottomSheetTitle;
  final String? buttonText;
  final String? hint;
  final List<DropDownItem> itemList;
  final List<DropDownItem>? selectedValues;
  final String? helpText;
  final bool? isRequired;
  final bool showSelectAll;
  final bool? showInitialsIcon;
  final Function(List<DropDownItem>) onTap;
  final bool? isAscending;
  final bool isMultiSelect;
  final bool isEnable;
  final bool? showSearch;
  final bool isGroup;
  final Color? selectedTextColor;
  final String? Function(String?)? validator;
  final GlobalKey<FormFieldState<String>>? fieldKey;
  final String? titleImage;
  final Color? iconColor;
  final Color? bgColor;

  const AppDropDownButton({
    required this.label,
    required this.itemList,
    this.helpText,
    this.buttonText,
    this.hint,
    this.bottomSheetTitle,
    this.selectedValues,
    this.showInitialsIcon,
    this.isEnable = true,
    this.isAscending,
    this.isRequired = false,
    this.showSearch = false,
    this.showSelectAll = false,
    this.isGroup = false,
    required this.onTap,
    required this.isMultiSelect,
    this.selectedTextColor,
    this.validator,
    this.fieldKey,
    this.titleImage,
    this.iconColor,
    this.bgColor,
  });

  @override
  State<AppDropDownButton> createState() => _AppDropDownButtonState();
}

class _AppDropDownButtonState extends State<AppDropDownButton> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void didUpdateWidget(covariant AppDropDownButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedValues != widget.selectedValues) {
      _initializeController();
    }
  }

  void _initializeController() {
    setState(() {
      if (widget.selectedValues != null && widget.selectedValues!.isNotEmpty) {
        _controller = TextEditingController(
          text: widget.selectedValues!.length > 1
              ? '${widget.selectedValues!.length} selected'
              : widget.selectedValues!.first.fieldText,
        );
      } else {
        _controller = TextEditingController();
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
        InkWell(
          onTap: () {
            if (widget.itemList.isNotEmpty) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                isDismissible: true,
                backgroundColor: AppColors.colorWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(9.r),
                  ),
                ),
                builder: (BuildContext context) {
                  return AppDropdownBottomSheet(
                    list: widget.itemList,
                    title: widget.bottomSheetTitle,
                    isEnable: widget.isEnable,
                    isGroup: widget.isGroup,
                    searchHint: 'Search..',
                    isAscending: widget.isAscending,
                    isMultiSelect: widget.isMultiSelect,
                    showSelectAll: widget.showSelectAll,
                    selectedValues: widget.selectedValues,
                    showSearch: widget.showSearch!,
                    buttonText: widget.buttonText,
                    showInitialsIcon: widget.showInitialsIcon ?? false,
                    onSelect: (values) {
                      setState(() {
                        if (widget.isEnable) {
                          _controller!.text = values.length > 1
                              ? '${values.length} selected'
                              : values.first.fieldText;
                        }
                      });
                      widget.onTap(values);
                    },
                  );
                },
              ).then((value) {
                if (_controller!.text == '') {
                  widget.onTap([]);
                }
              });
            }
          },
          child: TextFormField(
            validator: widget.validator,
            controller: _controller,
            key: widget.fieldKey,
            enabled: false,
            style: TextStyle(
              fontSize: AppDimensions.kFontSize14,
              fontWeight: FontWeight.w600,
              color: widget.selectedTextColor ?? AppColors.matteBlack,
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
              suffixIconConstraints: BoxConstraints(minHeight: 28.h),
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 28.h,
                  color: AppColors.lightGrey,
                ),
              ),
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
      ],
    );
  }
}
