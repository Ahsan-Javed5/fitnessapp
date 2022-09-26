import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LinkTextWidget extends StatelessWidget {
  final String message;
  final bool isMe;
  const LinkTextWidget({Key? key, required this.message, required this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: ColorConstants.appBlue,
      highlightColor: ColorConstants.appBlue,
      onTap: () {
        Utils.openURL(message);
      },
      child: Text(
        message,
        style: TextStyle(
          color: isMe ? ColorConstants.appBlue : ColorConstants.whiteColor,
          fontSize: 12.0.sp,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
