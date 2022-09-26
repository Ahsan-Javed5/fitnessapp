import 'package:fitnessapp/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomElevatedButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final TextStyle? textStyle;
  final VoidCallback onPressed;
  final bool enabled;

  const CustomElevatedButton({
    Key? key,
    this.width = double.infinity,
    this.height = -1,
    required this.text,
    required this.onPressed,
    this.textStyle,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height == -1 ? 6.8.h : height,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(1.0.w),
          image: const DecorationImage(
              image: AssetImage('assets/images/buttons_bg.png'),
              fit: BoxFit.cover),
          /*gradient: const LinearGradient(
            colors: [
              ColorConstants.appBlue,
              ColorConstants.appBlue,
            ],
          ),*/
          boxShadow: [
            if (enabled)
              BoxShadow(
                color: ColorConstants.appBlue.withOpacity(0.39),
                offset: const Offset(5, 5),
                blurRadius: 10.5,
              ),
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          splashColor: ColorConstants.unSelectedWidgetColor.withOpacity(0.2),
          highlightColor: Colors.transparent,
          child: Center(
            child: Text(
              text,
              softWrap: true,
              maxLines: 1,
              style: textStyle ?? Theme.of(context).textTheme.button,
            ),
          ),
        ),
      ),
    );
  }
}
