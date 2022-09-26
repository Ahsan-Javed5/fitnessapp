import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextStyles {
  /// Normal style this is automatically applied
  static TextStyle normalGrayBodyText = Get.textTheme.bodyText2!;

  /// Same style as above but with black fonts not automatic
  static TextStyle normalBlackBodyText =
      normalGrayBodyText.copyWith(color: ColorConstants.appBlack);

  /// Same style as above but with black fonts not automatic
  static TextStyle normalWhiteBodyText =
      normalGrayBodyText.copyWith(color: ColorConstants.whiteColor);

  /// Style for Extra bold headings at the top of screen
  static TextStyle mainScreenHeading = Get.textTheme.headline1!;

  /// Semi_bold style for sub headings with black color
  static TextStyle subHeadingSemiBold = Get.textTheme.headline4!;
  static TextStyle normalBlueBodyText =
  normalGrayBodyText.copyWith(color: ColorConstants.appBlue);
  static TextStyle subHeadingWhiteMedium =
      Get.textTheme.headline5!.copyWith(color: ColorConstants.whiteLevel2);
  static TextStyle subHeadingBlackMedium =
  Get.textTheme.headline5!.copyWith(color: ColorConstants.appBlack);

  static TextStyle subHeadingGrayMedium =
  Get.textTheme.headline5!.copyWith(color: ColorConstants.bodyTextColor);

  static TextStyle textFieldLabelStyleSmallGray = normalGrayBodyText.copyWith(
    fontSize: Spaces.normSP(9),
  );
  static TextStyle heading6AppBlackSemiBold = Get.textTheme.headline6!;
  static TextStyle heading6AppBlackRegular= Get.textTheme.bodyText1!;

  static TextStyle headingAppBlackBold= Get.textTheme.headline6!.copyWith(fontFamily: FontConstants.montserratBold);
}
