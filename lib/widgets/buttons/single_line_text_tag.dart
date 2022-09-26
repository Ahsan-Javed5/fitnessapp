import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/config/theme_size.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

class SingleLineTextTag extends StatelessWidget {
  final bool isBackgroundWhite;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final ThemeSize theme;
  final double? maxWidth;

  const SingleLineTextTag(
      {Key? key,
      this.isBackgroundWhite = true,
      required this.text,
      this.theme = ThemeSize.medium,
      this.backgroundColor,
      this.textColor,
      this.maxWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Default Configuration for Large Theme
    double? fontSize = 12.0.sp;
    double? paddingValue = 3.0.w;

    /// Configuration for medium theme
    if (theme == ThemeSize.medium) {
      fontSize = 11.0.sp;
      paddingValue = 1.0.w;
    }

    /// Configuration for small theme
    else if (theme == ThemeSize.small) {
      fontSize = 9.0.sp;
      paddingValue = 1.0.w;
    }
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(paddingValue + 1.0.w,
          paddingValue, paddingValue + 1.0.w, paddingValue),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isBackgroundWhite
                ? ColorConstants.veryVeryLightGray
                : ColorConstants.redButtonBackground),
        borderRadius: BorderRadius.circular(6),
      ),
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? 37.w,
        minWidth: 1.w,
      ),
      child: Text(
        text,
        textAlign: TextAlign.start,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: textColor != null
            ? TextStyles.normalWhiteBodyText.copyWith(fontSize: fontSize)
            : (isBackgroundWhite
                ? TextStyles.normalBlueBodyText.copyWith(fontSize: fontSize)
                : TextStyles.normalWhiteBodyText.copyWith(fontSize: fontSize)),
      ),
    );
  }
}
