import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class FormPhoneBuilder extends StatelessWidget {
  const FormPhoneBuilder({
    Key? key,
    this.minLines,
    this.controller,
    this.maxLines,
    this.textAlign,
    this.textColor,
    this.filled = false,
    this.fillColor,
    required this.labelText,
    this.hintText,
    this.obscureText = false,
    this.margin,
    this.contentPadding,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue = '',
    this.onChanged,
    this.keyboardType,
    required this.name,
    this.validator,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  final int? minLines;
  final TextEditingController? controller;
  final int? maxLines;
  final TextAlign? textAlign;
  final Color? textColor;
  final bool? filled;
  final Color? fillColor;
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final String name;
  final EdgeInsets? margin;
  final EdgeInsets? contentPadding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? initialValue;
  final Function(String?)? onChanged;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 3.0.h),
        Text(
          labelText!.toUpperCase(),
          style: Get.textTheme.bodyText2!.copyWith(
            fontSize: 9.5.sp,
          ),
        ),
        FormBuilderPhoneField(
          cursorColor: ColorConstants.appBlack,
          focusNode: FocusNode(),
          controller: controller,
          textAlign: textAlign ?? TextAlign.left,
          minLines: minLines ?? 1,
          name: name,
          validator: validator,
          onChanged: onChanged,
          obscureText: obscureText,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          style: Get.textTheme.bodyText1!.copyWith(
            fontWeight: FontWeight.w500,
            fontFamily: FontConstants.montserratMedium,
            height: 1.4,
          ),
          decoration: InputDecoration(
            filled: filled,
            focusColor: ColorConstants.whiteColor,
            fillColor: fillColor,
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
              color: ColorConstants.whiteColor,
            )),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            hintText: '${'enter'.tr.capitalizeFirst} ${hintText ?? labelText}',
            hintStyle: Get.textTheme.bodyText2!.copyWith(
              fontFamily: FontConstants.montserratRegular,
              fontWeight: FontWeight.w300,
              color: ColorConstants.bodyTextColor.withOpacity(0.6),
              fontSize: 11.0.sp,
            ),
          ),
        ),
      ],
    );
  }
}
