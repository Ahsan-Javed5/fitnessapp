import 'dart:core';

import 'package:fitnessapp/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'custom_label_field.dart';

class FormDatePickerBuilder extends StatelessWidget {
  const FormDatePickerBuilder({
    Key? key,
    this.minLines,
    this.controller,
    this.maxLines,
    this.textAlign,
    this.textColor,
    this.filled = false,
    this.fillColor,
    this.labelText,
    this.hintText,
    required this.attribute,
    this.margin,
    this.contentPadding,
    this.onChanged,
    this.allowClear = false,
    this.validators,
    this.itemsAreCheckable = false,
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
  final String attribute;
  final EdgeInsets? margin;
  final EdgeInsets? contentPadding;
  final bool allowClear;
  final validators;
  final bool itemsAreCheckable;
  final Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 3.0.h),
        CustomLabelField(
          labelText: labelText!.toUpperCase(),
        ),
        FormBuilderDateTimePicker(
          focusNode: FocusNode(),
          name: attribute,
          onChanged: (obj) {},
          validator: validators,
          timePickerInitialEntryMode: TimePickerEntryMode.input,
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDatePickerMode: DatePickerMode.year,
          initialDate: DateTime.now(),
          initialValue: DateTime.now(),
          inputType: InputType.date,
          cursorColor: ColorConstants.appBlack,
          format: DateFormat('dd-MM-yyyy'),
          decoration: InputDecoration(
            filled: true,
            focusColor: Colors.transparent,
            contentPadding: const EdgeInsets.only(right: 10),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.appBlack)),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.appBlack)),
            fillColor: Colors.transparent,
            hintText: labelText,
          ),
        ),
      ],
    );
  }
}
