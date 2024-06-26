import 'package:country_codes/country_codes.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:resume_radar/utils/app_images.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';

class AppMobileNumberField extends StatefulWidget {
  String? initialCountryCode;
  String? hint;
  String? titleImage;
  Function(PhoneNumber) onChange;
  Function(String) onCountryChange;
  FocusNode? focusNode;
  bool? isRequired;
  bool isDisabled;
  final String? Function(String?)? validator;
  TextEditingController controller;

  AppMobileNumberField({
    this.initialCountryCode,
    required this.onChange,
    required this.onCountryChange,
    this.focusNode,
    this.hint,
    this.titleImage,
    this.isRequired = false,
    this.isDisabled = false,
    required this.controller,
    this.validator,
  });

  @override
  State<AppMobileNumberField> createState() => _AppMobileNumberFieldState();
}

class _AppMobileNumberFieldState extends State<AppMobileNumberField> {
  var _countryCode = const CountryCode(name: 'AU', code: 'AU', dialCode: '+61');
  FocusNode? focusNode;
  bool hasFocus = false;

  final countryPickerWithParams = FlCountryCodePicker(
    localize: true,
    showDialCode: true,
    showSearchBar: true,
    countryTextStyle: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: AppDimensions.kFontSize12,
      color: AppColors.matteBlack,
    ),
    dialCodeTextStyle: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: AppDimensions.kFontSize12,
      color: AppColors.matteBlack,
    ),
    searchBarTextStyle: TextStyle(
      fontSize: AppDimensions.kFontSize14,
      fontWeight: FontWeight.w600,
      color: AppColors.matteBlack,
    ),
    title: Column(
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
        Column(
          children: [
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Text(
                'Select country code',
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
        SizedBox(height: 24.h),
      ],
    ),
    searchBarDecoration: InputDecoration(
      contentPadding: EdgeInsets.only(
        top: 11.5.h,
        bottom: 11.5.h,
        left: 11.w,
      ),
      isDense: true,
      counterText: "",
      hintText: 'Search',
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(6.r),
        ),
        borderSide: BorderSide(
          color: AppColors.lightGrey,
          width: 0.75.w,
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
      prefixIconConstraints: BoxConstraints(
        minWidth: 55.w,
      ),
      suffixIconConstraints: BoxConstraints(minWidth: 24.w, maxHeight: 24.h),
      suffixIcon: Padding(
        padding: EdgeInsets.only(
          right: 11.w,
        ),
        child: Image.asset(
          AppImages.icSearch,
          color: AppColors.darkStrokeGrey,
        ),
      ),
      filled: true,
      hintStyle: TextStyle(
          color: AppColors.darkStrokeGrey,
          fontSize: AppDimensions.kFontSize12,
          fontWeight: FontWeight.w400),
      fillColor: AppColors.colorWhite,
    ),
  );

  Future<String> setDialCode() async {
    String dialCode;
    try {
      await CountryCodes.init();

      final CountryDetails details = CountryCodes.detailsForLocale();
      dialCode = details.dialCode!;
    } on Exception catch (e) {
      dialCode = '61';
    }
    return dialCode;
  }

  getDialCode(String? countryCode) async {
    Country? country;
    for (var element in countries) {
      if (element.dialCode == countryCode) {
        country = element;
        break;
      }
    }
    if (country == null) {
      String dialCode = await setDialCode();
      for (var element in countries) {
        if (element.dialCode == dialCode.replaceFirst('+', '')) {
          country = element;
          break;
        }
      }
    }
    setState(() {
      _countryCode = CountryCode(
        name: country!.name,
        dialCode: country.dialCode,
        code: country.code,
      );
    });
  }

  @override
  void initState() {
    getDialCode(widget.initialCountryCode);
    focusNode = widget.focusNode ?? FocusNode();
    focusNode!.addListener(() {
      if (focusNode!.hasFocus) {
        setState(() {
          hasFocus = true;
        });
      } else {
        setState(() {
          hasFocus = false;
        });
      }
    });
    super.initState();
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
                child: Row(
                  children: [
                    Text(
                      'Phone number',
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
                        widget.isRequired! ? ' \u2217' : '',
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
            ],
          ),
        ),
        TextFormField(
          onChanged: (number) {
            widget.onChange(
              PhoneNumber(
                countryISOCode: _countryCode.code,
                countryCode: '+${_countryCode.dialCode.replaceAll('+', '')}',
                number: widget.controller.text,
              ),
            );
          },
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          validator: widget.validator,
          enabled: !widget.isDisabled,
          focusNode: focusNode,
          maxLength: 15,
          controller: widget.controller,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          textInputAction: TextInputAction.done,
          style: TextStyle(
            fontSize: AppDimensions.kFontSize14,
            fontWeight: FontWeight.w600,
            color: AppColors.matteBlack,
          ),
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(left: 11.w, top: 5.5.h, bottom: 5.5.h),
            isDense: true,
            counterText: "",
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(6.r),
              ),
              borderSide: BorderSide(
                color: AppColors.lightGrey,
                width: 0.75.w,
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
              fontSize: AppDimensions.kFontSize12,
              fontWeight: FontWeight.w400,
              color: AppColors.errorRed,
            ),
            prefixText: widget.controller.text.isNotEmpty || hasFocus
                ? ' +${_countryCode.dialCode.replaceAll('+', '')} '
                : null,
            prefixStyle: TextStyle(
              color: AppColors.matteBlack,
              fontSize: AppDimensions.kFontSize14,
              fontWeight: FontWeight.w600,
            ),
            prefixIconConstraints: BoxConstraints(maxHeight: 48.h),
            prefixIcon: InkResponse(
              onTap: () async {
                final code = await countryPickerWithParams.showPicker(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  backgroundColor: AppColors.colorWhite,
                  pickerMaxHeight: 650.h,
                  scrollToDeviceLocale: true,
                );
                if (code != null) {
                  setState(() {
                    _countryCode = code;
                    widget.onCountryChange(
                        '+${_countryCode.dialCode.replaceAll('+', '')}');
                    widget.onChange(
                      PhoneNumber(
                        countryISOCode: _countryCode.code,
                        countryCode:
                            '+${_countryCode.dialCode.replaceAll('+', '')}',
                        number: widget.controller.text,
                      ),
                    );
                  });
                }
              },
              child: Padding(
                padding: EdgeInsets.only(
                  left: 11.w,
                  top: 6.h,
                  bottom: 6.h,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      _countryCode.flagUri,
                      height: 17.h,
                      package: _countryCode.flagImagePackage,
                    ),
                    SizedBox(width: 3.w),
                    const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: AppColors.lightGrey,
                    ),
                    SizedBox(width: 3.w),
                    SizedBox(
                      height: 29.h,
                      child: VerticalDivider(
                        width: 1.w,
                        thickness: 1.w,
                        color: AppColors.lightGrey,
                      ),
                    )
                  ],
                ),
              ),
            ),
            filled: true,
            hintText: (widget.controller.text.isEmpty ? '  ' : '') +
                (widget.hint ?? ''),
            hintStyle: TextStyle(
                color: AppColors.darkStrokeGrey,
                fontSize: AppDimensions.kFontSize12,
                fontWeight: FontWeight.w400),
            fillColor: AppColors.colorWhite,
          ),
        )
      ],
    );
  }
}
