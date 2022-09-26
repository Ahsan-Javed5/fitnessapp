import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/custom_label_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

/// Edit text field designed according to app requirement
/// Use this class in a Form when you want a user to input something in it

class FormInputBuilder extends StatelessWidget {
  const FormInputBuilder({
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
    required this.attribute,
    this.margin,
    this.contentPadding,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue = '',
    this.onChanged,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.words,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
    this.maxLength = 30,
    this.suffixText = '',
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
  final String attribute;
  final EdgeInsets? margin;
  final EdgeInsets? contentPadding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? initialValue;
  final bool enabled;
  final Function(String?)? onChanged;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final int maxLength;
  final String suffixText;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 3.0.h),
        CustomLabelField(labelText: labelText!.toUpperCase()),
        FormBuilderTextField(
          cursorColor: ColorConstants.appBlack,
          focusNode: FocusNode(),
          controller: controller,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          name: attribute,
          enabled: enabled,
          validator: validator,
          onChanged: onChanged,
          obscureText: obscureText,
          initialValue: initialValue,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          autocorrect: false,
          style: Get.textTheme.bodyText1!.copyWith(
            fontWeight: FontWeight.w500,
            fontFamily: FontConstants.montserratMedium,
            color: enabled
                ? ColorConstants.appBlack
                : ColorConstants.bodyTextColor.withOpacity(0.9),
            height: 1.4,
          ),
          decoration: InputDecoration(
            filled: filled,
            isDense: false,
            counterText: '',
            suffixText: suffixText,
            suffixStyle: TextStyles.normalBlackBodyText,
            focusColor: ColorConstants.appBlack,
            fillColor: fillColor,
            hoverColor: ColorConstants.appBlack,
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: ColorConstants.appBlack,
              ),
            ),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: ColorConstants.appBlack,
              ),
            ),
            disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: ColorConstants.appBlack,
              ),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: ColorConstants.appBlack,
              ),
            ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            hintText: hintText ?? '${'enter'.tr.capitalizeFirst} $labelText',
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
