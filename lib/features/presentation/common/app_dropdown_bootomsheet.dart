import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resume_radar/features/domain/entities/common/drop_down_item.dart';
import 'package:resume_radar/features/presentation/common/app_button.dart';
import 'package:resume_radar/utils/enums.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../utils/app_images.dart';

class AppDropdownBottomSheet extends StatefulWidget {
  final List<DropDownItem> list;
  final void Function(List<DropDownItem>) onSelect;
  final String searchHint;
  final String? buttonText;
  final bool isEnable;
  final bool isGroup;
  final String? title;
  final bool showSearch;
  final bool showSelectAll;
  final bool isMultiSelect;
  final bool? isAscending;
  final bool showInitialsIcon;
  final List<DropDownItem>? selectedValues;

  const AppDropdownBottomSheet({
    required this.list,
    required this.onSelect,
    required this.searchHint,
    this.buttonText,
    required this.isEnable,
    this.selectedValues,
    this.isAscending,
    this.title,
    this.showSearch = false,
    this.isGroup = false,
    this.showInitialsIcon = false,
    this.showSelectAll = false,
    required this.isMultiSelect,
  });

  @override
  State<AppDropdownBottomSheet> createState() => _AppDropdownBottomSheetState();
}

class _AppDropdownBottomSheetState extends State<AppDropdownBottomSheet> {
  List<DropDownItem> itemList = [];
  List<DropDownItem> selectedItems = [];
  @override
  void initState() {
    super.initState();
    itemList.clear();
    itemList.addAll(widget.list);
    selectedItems.clear();
    selectedItems.addAll(widget.selectedValues ?? []);
    setState(() {
      if (widget.isAscending != null) {
        if (widget.isAscending!) {
          itemList.sort((a, b) => a.fieldText.compareTo(b.fieldText));
        } else {
          itemList.sort((a, b) => b.fieldText.compareTo(a.fieldText));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
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
        constraints: BoxConstraints(
          maxHeight: 400.h,
        ),
        child: RawScrollbar(
          thumbVisibility: true,
          thumbColor: AppColors.primaryGreen,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 20),
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
                    if (widget.title != null)
                      Column(
                        children: [
                          SizedBox(height: 24.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.w),
                            child: Text(
                              widget.title ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: AppDimensions.kFontSize14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (widget.showSearch)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            SizedBox(height: 24.h),
                            TextField(
                              textInputAction: TextInputAction.search,
                              maxLength: 50,
                              style: TextStyle(
                                fontSize: AppDimensions.kFontSize14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.matteBlack,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 13.w, top: 13.h, bottom: 13.h),
                                isDense: true,
                                counterText: "",
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.r),
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.lightGrey,
                                    width: 0.75.w,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.r),
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.lightGrey,
                                    width: 0.75.w,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.r),
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.lightGrey,
                                    width: 0.75.w,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.r),
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.lightGrey,
                                    width: 0.75.w,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.r),
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.errorRed,
                                    width: 0.75.w,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.r),
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.errorRed,
                                    width: 0.75.w,
                                  ),
                                ),
                                prefixIconConstraints: BoxConstraints(
                                    minWidth: 18.w, maxHeight: 18.h),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(
                                    left: 13.w,
                                    right: 6.w,
                                  ),
                                  child: Image.asset(
                                    AppImages.icSearch,
                                    color: AppColors.lightGrey,
                                  ),
                                ),
                                filled: true,
                                hintText: 'Search',
                                errorMaxLines: 2,
                                errorStyle: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: AppDimensions.kFontSize10,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.errorRed,
                                ),
                                hintStyle: TextStyle(
                                    color: AppColors.lightGrey,
                                    fontSize: AppDimensions.kFontSize14,
                                    fontWeight: FontWeight.w400),
                                fillColor: AppColors.colorWhite,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  itemList.clear();
                                  if (value != '') {
                                    widget.list.forEach((element) {
                                      if (element.fieldText
                                          .trim()
                                          .toLowerCase()
                                          .contains(
                                              value.trim().toLowerCase())) {
                                        itemList.add(element);
                                      }
                                    });
                                  } else {
                                    itemList.addAll(widget.list);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 28.h),
                  ],
                ),
                if (widget.showSelectAll && widget.list.isNotEmpty)
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.isEnable) {
                            if (widget.list.length == selectedItems.length) {
                              setState(() {
                                selectedItems.clear();
                              });
                            } else {
                              setState(() {
                                selectedItems.clear();
                                selectedItems.addAll(widget.list);
                              });
                            }
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.isGroup
                                      ? 'Select Group (${widget.list.length.toString().padLeft(2, '0')} Users)'
                                      : 'Select all',
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: AppColors.matteBlack,
                                      fontSize: AppDimensions.kFontSize14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              SizedBox(
                                height: 25.h,
                                width: 25.h,
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor:
                                        AppColors.checkBoxBorder,
                                  ),
                                  child: Checkbox(
                                    value: widget.list.length ==
                                        selectedItems.length,
                                    activeColor: AppColors.primaryGreen,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    side: BorderSide(
                                      color: AppColors.checkBoxBorder,
                                      width: 0.75.w,
                                    ),
                                    onChanged: (value) {
                                      if (widget.isEnable) {
                                        if (widget.list.length ==
                                            selectedItems.length) {
                                          setState(() {
                                            selectedItems.clear();
                                          });
                                        } else {
                                          setState(() {
                                            selectedItems.clear();
                                            selectedItems.addAll(widget.list);
                                          });
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 25.h),
                    ],
                  ),
                ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: itemList.length,
                  itemBuilder: (context, index) {
                    bool isSelected = checkIfSelected(itemList[index].id);
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (widget.isEnable && !widget.isGroup) {
                              if (!widget.isMultiSelect) {
                                widget.onSelect([itemList[index]]);
                                Navigator.pop(context);
                              } else {
                                if (isSelected) {
                                  setState(() {
                                    selectedItems.removeWhere((element) =>
                                        element.id == itemList[index].id);
                                  });
                                } else {
                                  setState(() {
                                    selectedItems.add(itemList[index]);
                                  });
                                }
                              }
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (widget.showInitialsIcon)
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 25.w,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            itemList[index].iconColor,
                                        child: Center(
                                          child: Text(
                                            getFirstCharacters(
                                                itemList[index].fieldText),
                                            style: TextStyle(
                                              color: AppColors.colorWhite,
                                              fontSize:
                                                  AppDimensions.kFontSize12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                  ],
                                ),
                              Expanded(
                                child: Text(
                                  itemList[index].fieldText,
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: AppColors.matteBlack,
                                      fontSize: AppDimensions.kFontSize14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              if (widget.isEnable && !widget.isGroup)
                                SizedBox(
                                  height: 25.h,
                                  width: 25.h,
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      unselectedWidgetColor:
                                          AppColors.checkBoxBorder,
                                    ),
                                    child: Checkbox(
                                      value: isSelected,
                                      activeColor: AppColors.primaryGreen,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                      ),
                                      side: BorderSide(
                                        color: AppColors.checkBoxBorder,
                                        width: 0.75.w,
                                      ),
                                      onChanged: (value) {
                                        if (widget.isEnable &&
                                            !widget.isGroup) {
                                          if (!widget.isMultiSelect) {
                                            widget.onSelect([itemList[index]]);
                                            Navigator.pop(context);
                                          } else {
                                            if (isSelected) {
                                              setState(() {
                                                selectedItems.removeWhere(
                                                    (element) =>
                                                        element.id ==
                                                        itemList[index].id);
                                              });
                                            } else {
                                              setState(() {
                                                selectedItems
                                                    .add(itemList[index]);
                                              });
                                            }
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        widget.showInitialsIcon
                            ? SizedBox(height: 15.h)
                            : SizedBox(height: 25.h),
                      ],
                    );
                  },
                ),
                widget.showInitialsIcon
                    ? SizedBox(height: 15.h)
                    : SizedBox(height: 5.h),
                if (widget.isMultiSelect || !widget.isEnable)
                  Column(
                    children: [
                      AppButton(
                        width: 295.w,
                        buttonType:
                            (selectedItems.isNotEmpty || !widget.isEnable) &&
                                    (widget.isMultiSelect || !widget.isEnable)
                                ? ButtonType.ENABLED
                                : ButtonType.DISABLED,
                        buttonText: widget.buttonText ??
                            (widget.isEnable ? 'Save' : 'Back'),
                        onTapButton: () {
                          if (widget.isMultiSelect || widget.isEnable) {
                            widget.onSelect(selectedItems);
                          }
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool checkIfSelected(String id) {
    for (var element in selectedItems) {
      if (element.id == id) {
        return true;
      }
    }
    return false;
  }

  String getFirstCharacters(String input) {
    List<String> words = input.split(" ");
    if (words.length >= 2 && words[1].isNotEmpty) {
      String firstWord = words[0];
      String secondWord = words[1];
      String firstCharacters =
          "${firstWord[0].toUpperCase()}${secondWord[0].toUpperCase()}";
      return firstCharacters;
    } else {
      return words[0][0] + words[0][1];
    }
  }
}
