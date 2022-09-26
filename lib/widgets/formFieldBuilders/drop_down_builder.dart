import 'dart:core';

import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'custom_label_field.dart';

class DropdownBuilder extends StatelessWidget {
  const DropdownBuilder({
    Key? key,
    this.textColor,
    this.filled = false,
    this.fillColor,
    required this.labelText,
    this.hintText,
    required this.attribute,
    this.margin,
    this.contentPadding,
    this.onChanged,
    required this.items,
    this.itemsAreCheckable = false,
    this.initialValue,
  }) : super(key: key);

  final Color? textColor;
  final bool? filled;
  final Color? fillColor;
  final String labelText;
  final String? hintText;
  final String attribute;
  final EdgeInsets? margin;
  final dynamic initialValue;
  final EdgeInsets? contentPadding;
  final List items;
  final bool itemsAreCheckable;
  final Function(dynamic)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 3.0.h),
        CustomLabelField(
          labelText: labelText.toUpperCase(),
        ),
        FormBuilderDropdown(
          focusNode: FocusNode(),
          name: attribute,
          onChanged: onChanged ?? (v) {},
          validator: FormBuilderValidators.required(context,
              errorText: 'please_select_from_this_list'.tr),
          hint: Text(
            'select'.tr,
            style: Get.textTheme.bodyText1!.copyWith(
              fontFamily: FontConstants.montserratRegular,
              fontWeight: FontWeight.w300,
              color: ColorConstants.bodyTextColor.withOpacity(0.6),
              fontSize: 12.0.sp,
            ),
          ),
          isExpanded: false,
          isDense: true,
          decoration: const InputDecoration(
            filled: false,
            contentPadding: EdgeInsets.only(right: 10),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.appBlack)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.appBlack)),
            fillColor: Colors.transparent,
          ),
          icon: SvgPicture.asset(
            'assets/svgs/ic_chevron_down.svg',
            fit: BoxFit.scaleDown,
            width: 4.0.w,
          ),
          items: items
              .map(
                (gender) => DropdownMenuItem(
                  value: gender,
                  child: Row(
                    children: [
                      Text(
                        '$gender'.tr,
                        style: Get.textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontFamily: FontConstants.montserratMedium,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
