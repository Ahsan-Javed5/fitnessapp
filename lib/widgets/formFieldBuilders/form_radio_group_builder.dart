import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/config/theme_data.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import 'custom_label_field.dart';

class FormRadioGroupBuilder extends StatelessWidget {
  final List<String> options;
  final String label;
  final String attribute;
  final WrapCrossAlignment wrapCrossAlignment;
  final WrapAlignment wrapAlignment;
  final String? initialValue;

  const FormRadioGroupBuilder({
    Key? key,
    required this.options,
    required this.label,
    required this.attribute,
    this.wrapCrossAlignment = WrapCrossAlignment.start,
    this.wrapAlignment = WrapAlignment.spaceBetween,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Spaces.normY(3)),
        CustomLabelField(
          labelText: label.toUpperCase(),
        ),
        Spaces.y1,
        Theme(
          data: getAppThemeData()
              .copyWith(unselectedWidgetColor: ColorConstants.dividerColor),
          child: FormBuilderRadioGroup(
            name: attribute,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            initialValue:
                initialValue?.capitalizeFirst ?? options[0].capitalizeFirst,
            wrapCrossAxisAlignment: wrapCrossAlignment,
            wrapAlignment: wrapAlignment,
            decoration: const InputDecoration(
              fillColor: Colors.transparent,
              border: InputBorder.none,
              focusColor: ColorConstants.appBlack,
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            options: options
                .map(
                  (option) => FormBuilderFieldOption(
                    value: option.capitalizeFirst,
                    child: Text(
                      option.tr,
                      textAlign: TextAlign.start,
                      style: TextStyles.normalBlackBodyText,
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}
