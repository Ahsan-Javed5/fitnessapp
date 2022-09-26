import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

ThemeData getAppThemeData() {
  return ThemeData(
    primaryColor: ColorConstants.primaryColor,
    accentColor: ColorConstants.accentColor,
    unselectedWidgetColor: ColorConstants.unSelectedWidgetColor,
    primaryColorDark: ColorConstants.primaryColor,
    primarySwatch: const MaterialColor(0xFF213FB9, {
      50: ColorConstants.grayVeryLight,
      100: ColorConstants.grayLight,
      200: ColorConstants.gray,
      300: ColorConstants.grayLevel2,
      400: ColorConstants.grayDark,
      500: ColorConstants.whiteGrayButtonBackground,
      600: ColorConstants.unSelectedWidgetColor,
      700: ColorConstants.dividerColor,
      800: ColorConstants.primaryDarkColor,
      900: ColorConstants.appBlack
    }),

    bottomAppBarColor: ColorConstants.appBlack,
    fontFamily: FontConstants.montserratRegular,
    shadowColor: ColorConstants.shadowColor,
    focusColor: ColorConstants.appBlack,
    highlightColor: ColorConstants.whiteGrayButtonBackground,
    hintColor: ColorConstants.bodyTextColor,
    splashColor: ColorConstants.grayVeryLight,

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        color: ColorConstants.bodyTextColor,
        fontSize: 11.5.sp,
        fontFamily: FontConstants.montserratRegular,
      ),
      hintStyle: TextStyle(
        color: ColorConstants.bodyTextColor,
        fontSize: 12.5.sp,
      ),
      focusColor: ColorConstants.appBlack,
      filled: true,
      fillColor: ColorConstants.appBlack,
    ),

    tabBarTheme: TabBarTheme(
      unselectedLabelColor: ColorConstants.unSelectedWidgetColor,
      labelColor: ColorConstants.appBlue,
      indicatorSize: TabBarIndicatorSize.tab,
      labelPadding: EdgeInsets.only(bottom: 1.0.w, left: 3.5.w, right: 3.5.w),
      indicator:
          BoxDecoration(border: Border(bottom: BorderSide(width: 0.8.w,color: ColorConstants.appBlue))),
      unselectedLabelStyle: TextStyle(
        fontSize: 14.5.sp,
        fontFamily: FontConstants.montserratMedium,
      ),
      labelStyle: TextStyle(
        fontSize: 14.5.sp,
        color: ColorConstants.appBlue,
        fontFamily: FontConstants.montserratMedium,
      ),
    ),

    /// Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: ColorConstants.appBlue, width: 1.3),
        primary: ColorConstants.appBlue,
      ),
    ),

    /// Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
      ),
    ),

    /// Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: ColorConstants.appBlue,
        padding: EdgeInsets.zero,
        textStyle: TextStyle(
          fontSize: 11.0.sp,
          fontFamily: FontConstants.montserratRegular,
        ),
      ),
    ),

    /// Icon Button Theme
    iconTheme: const IconThemeData(
      color: ColorConstants.appBlack,
    ),

    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 23.0.sp,
        letterSpacing: -0.5,
        fontFamily: FontConstants.montserratBold,
        color: ColorConstants.appBlack,
      ),
      headline4: TextStyle(
          fontSize: 13.0.sp,
          fontFamily: FontConstants.montserratBold,
          color: ColorConstants.appBlack),
      headline5: TextStyle(
          fontSize: 13.5.sp,
          fontFamily: FontConstants.montserratMedium,
          color: ColorConstants.appBlack),

      /// This style automatically applies on all the [Text]
      bodyText2: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w300,
        fontFamily: FontConstants.montserratRegular,
        color: ColorConstants.grayLevel2,
      ),

      /// Using this style for radio button text and other place with 16.0.sp and #0d1111 color
      bodyText1: TextStyle(
        fontSize: 13.0.sp,
        fontFamily: FontConstants.montserratRegular,
        color: ColorConstants.appBlack,
      ),

      /// This style automatically applies on the text of [ElevatedButton, OutlinedButton]
      /// also we can define different text style for these button in there respective
      /// theme data above
      button: TextStyle(
          fontSize: 13.0.sp,
          fontFamily: FontConstants.montserratSemiBold,
          color: Colors.white),

      //text size semiBold black
      headline6: TextStyle(
          fontSize: 13.sp,
          fontFamily: FontConstants.montserratSemiBold,
          color: ColorConstants.appBlack),
    ),
  );
}
