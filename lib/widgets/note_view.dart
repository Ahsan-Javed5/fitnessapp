import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:flutter/material.dart';

class NoteView extends StatelessWidget {
  final String? text;
  final double? textSize;
  final Color? backgroundColor;
  final double? verticalPadding;
  final Widget? child;
  final Color textColor;
  final VoidCallback? onPress;
  final bool hasBorder;

  const NoteView({
    Key? key,
    this.text = '',
    this.textSize,
    this.backgroundColor,
    this.verticalPadding,
    this.child,
    this.onPress,
    this.hasBorder = false,
    this.textColor = ColorConstants.appBlack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Spaces.normX(2),
            vertical: verticalPadding ?? Spaces.normY(1.4)),
        decoration: BoxDecoration(
          color:
              backgroundColor ?? ColorConstants.grayVeryLight.withOpacity(0.8),
          border: Border.all(
              color: hasBorder
                  ? ColorConstants.veryLightBlue
                  : Colors.transparent),
          borderRadius: BorderRadius.circular(Spaces.normX(1)),
        ),
        child: child ??
            Text(
              text!,
              textAlign: TextAlign.center,
              style: TextStyles.normalBlackBodyText.copyWith(
                  fontSize: textSize ?? Spaces.normSP(9.3), color: textColor),
            ),
      ),
    );
  }
}
