import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/custom_label_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class MultiLineTextTag extends StatelessWidget {
  final bool isBackgroundWhite;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;

  const MultiLineTextTag(
      {Key? key,
      this.isBackgroundWhite = true,
      required this.text,
      this.backgroundColor,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Default Configuration for Large Theme
    double? fontSize = 10.0.sp;
    double? paddingValue = 3.0.w;

    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(paddingValue + 1.0.w,
          paddingValue, paddingValue + 1.0.w, paddingValue),
      decoration: BoxDecoration(
          color: backgroundColor ??
              (isBackgroundWhite
                  ? ColorConstants.veryVeryLightGray
                  : ColorConstants.redButtonBackground),
          borderRadius: BorderRadius.circular(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomLabelField(labelText: 'groups'.tr),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyles.normalBlackBodyText.copyWith(fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}
