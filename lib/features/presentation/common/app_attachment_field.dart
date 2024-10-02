import 'dart:io';
import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:resume_radar/utils/app_images.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_dimensions.dart';
import '../../../utils/enums.dart';

class AppAttachmentField extends StatefulWidget {
  final String? hint;
  final String? helpText;
  final String? Function(String?)? validator;
  final bool isEnable;
  final bool? isRequired;
  final String? label;
  final String? answer;
  final String? keyData;
  final Function(File?, String?)? onChange;
  final GlobalKey<FormFieldState<String>>? fieldKey;
  final VoidCallback? onAttachmentTap;
  final Color? iconColor;
  final Color? bgColor;

  const AppAttachmentField({
    this.hint,
    this.helpText,
    this.isEnable = true,
    this.isRequired = false,
    this.label,
    this.validator,
    this.onChange,
    this.fieldKey,
    this.answer,
    this.keyData,
    this.onAttachmentTap,
    this.iconColor,
    this.bgColor,
  });

  @override
  State<AppAttachmentField> createState() => _AppAttachmentFieldState();
}

class _AppAttachmentFieldState extends State<AppAttachmentField> {
  File? selectedFile;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.answer != null && widget.answer != "null") {
        controller.text = widget.answer!;
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
            InkWell(
              onTap: () async {
                if (widget.isEnable) {
                  _pickFiles();
                } else {
                  if (widget.answer != null) {
                    if (widget.onAttachmentTap != null) {
                      widget.onAttachmentTap!();
                    }
                  }
                }
              },
              child: TextFormField(
                validator: widget.validator,
                key: widget.fieldKey,
                controller: controller,
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
                  suffixIconConstraints: BoxConstraints(minHeight: 22.h),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 10.w, left: 10.w),
                    child: SizedBox(
                      height: 22.h,
                      width: 20.w,
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
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 45.h,
                width: 40.w,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10.w,
                    right: 10.w,
                  ),
                  child: widget.isEnable &&
                          selectedFile != null &&
                          controller.text.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              selectedFile = null;
                              controller.text = '';
                            });
                            if (widget.onChange != null) {
                              widget.onChange!(null, null);
                            }
                          },
                          child: Icon(
                            Icons.close,
                            size: 20.h,
                            color: AppColors.lightGrey,
                          ),
                        )
                      : Image.asset(
                          AppImages.icAttachment,
                          height: 20.h,
                          color: AppColors.lightGrey,
                        ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Future<void> _pickFiles() async {
    List<PlatformFile>? _files;
    List<String> allowedExtensions = [
      'pdf',
      'doc',
      'docx',
      'txt',
    ];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: allowedExtensions,
    );
    if (result != null) {
      setState(() {
        _files = result.files;
      });
      for (PlatformFile file in _files!) {
        File pickedFile = File(file.path!);
        int size = await pickedFile.length();
        if (size < 10485760) {
          setState(() {
            selectedFile = pickedFile;
            controller.text = pickedFile.path.split('/').last;
          });
          if (widget.onChange != null) {
            widget.onChange!(selectedFile, controller.text);
          }
        } else {
          showSnackBar('Maximum upload size is 10MB.', AlertType.FAIL);
        }
      }
    } else {
      if (selectedFile == null &&
          controller.text.isEmpty &&
          widget.onChange != null) {
        widget.onChange!(null, null);
      }
    }
  }

  showProgressBar() {
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
                          child: const SpinKitFadingFour(
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

  showSnackBar(String message, AlertType alertType) {
    Flushbar flushBar = Flushbar(
      duration: const Duration(seconds: 2),
      message: message,
      messageColor: AppColors.colorWhite,
      icon: alertType == AlertType.FAIL
          ? Image.asset(
              AppImages.icErrorRounded,
              height: 24.h,
            )
          : alertType == AlertType.SUCCESS
              ? Image.asset(
                  AppImages.icSuccessRounded,
                  height: 24.h,
                )
              : Image.asset(
                  AppImages.icWarningRounded,
                  height: 24.h,
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
