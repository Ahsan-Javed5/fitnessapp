import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/locale_type.dart';
import 'package:fitnessapp/screens/drawer/flutter_zoom_drawer.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'signup_coach_side_menu_home_screen.dart';

class SignUpCoachMenuScreen extends StatefulWidget {
  final List<MenuItem> mainMenu;
  final Function(int)? callback;
  final int? current;

  const SignUpCoachMenuScreen(
    this.mainMenu, {
    Key? key,
    this.callback,
    this.current,
  });

  @override
  _SignUpCoachMenuScreenState createState() => _SignUpCoachMenuScreenState();
}

class _SignUpCoachMenuScreenState extends State<SignUpCoachMenuScreen> {
  final widthBox = const SizedBox(
    width: 16.0,
  );

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(start: 4.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Spaces.y2,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'language'.tr,
                                      style: TextStyles.subHeadingBlackMedium
                                          .copyWith(
                                              color: ColorConstants.whiteColor,
                                              fontSize: 11.sp),
                                    ),
                                    Spaces.y0,
                                    Row(
                                      children: [
                                        Text(
                                          'english'.tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyles
                                              .subHeadingBlackMedium
                                              .copyWith(
                                                  color: !Utils.isRTL()
                                                      ? ColorConstants
                                                          .whiteColor
                                                      : ColorConstants
                                                          .bodyTextColor,
                                                  fontSize: 10.sp),
                                        ),
                                        Spaces.x2,
                                        FlutterSwitch(
                                            height: 3.3.h,
                                            width: 6.2.h,
                                            toggleColor: ColorConstants.appBlue,
                                            activeColor: Colors.white,
                                            inactiveColor: Colors.white,
                                            padding: 2.0,
                                            value: false,
                                            onToggle: (val) {
                                              if (Utils.isRTL()) {
                                                updateLocale(LocaleType.en);
                                              } else {
                                                updateLocale(LocaleType.ar);
                                              }
                                            }),
                                        Spaces.x2,
                                        Text(
                                          'arabic'.tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyles
                                              .subHeadingBlackMedium
                                              .copyWith(
                                                  color: Utils.isRTL()
                                                      ? ColorConstants
                                                          .whiteColor
                                                      : ColorConstants
                                                          .bodyTextColor,
                                                  fontSize: 10.sp),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  child: Padding(
                                    padding:
                                        EdgeInsetsDirectional.only(end: 4.w),
                                    child: Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    ZoomDrawer.of(context)!.close();
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                        Spaces.y5,
                        Text(
                          'welcome'.tr,
                          style: TextStyles.mainScreenHeading
                              .copyWith(color: ColorConstants.whiteColor),
                        ),
                      ],
                    ),
                    Spaces.y4,
                    Expanded(
                      child: Selector<SignUpCoachMenuProvider, int>(
                        selector: (_, provider) => provider.currentPage,
                        builder: (_, index, __) => ListView(
                          shrinkWrap: true,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ...widget.mainMenu
                                    .map((item) => MenuItemWidget(
                                          key: Key(item.index.toString()),
                                          item: item,
                                          callback: widget.callback,
                                          widthBox: widthBox,
                                          style: style,
                                          selected: index == item.index,
                                        ))
                                    .toList()
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 5.w,
                              width: 5.w,
                              child: SvgPicture.asset(
                                'assets/svgs/ic_copy_right.svg',
                                matchTextDirection: false,
                              ),
                            ),
                            Spaces.x3,
                            Text('fit_and_more'.tr,
                                style: TextStyles.subHeadingWhiteMedium
                                    .copyWith(
                                        color: ColorConstants.whiteColor,
                                        fontSize: 11.sp)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateLocale(LocaleType type) {
    MyHive.setLocaleType(type);
    Get.updateLocale(Utils.getLocaleFromLocaleType(type));
  }
}

class MenuItemWidget extends StatelessWidget {
  final MenuItem? item;
  final Widget? widthBox;
  final TextStyle? style;
  final Function? callback;
  final bool? selected;
  final white = Colors.white;

  const MenuItemWidget({
    Key? key,
    this.item,
    this.widthBox,
    this.style,
    this.callback,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => callback!(item!.index),
      style: TextButton.styleFrom(
        primary: selected! ? const Color(0x44000000) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Icon(
          //   item!.icon,
          //   color: white,
          //   size: 24,
          // ),
          SizedBox(
            height: 5.w,
            width: 5.w,
            child: SvgPicture.asset(
              item!.path,
              color: white,
            ),
          ),
          widthBox!,
          Expanded(
            child: Text(
              item!.title.tr,
              style: style,
            ),
          )
        ],
      ),
    );
  }
}

class MenuItem {
  final String title;
  final String path;
  final int index;

  MenuItem(this.title, this.path, this.index);
}
