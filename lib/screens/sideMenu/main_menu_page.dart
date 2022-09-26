import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/locale_type.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/screens/drawer/flutter_zoom_drawer.dart';
import 'package:fitnessapp/screens/home/main_home_screen.dart';
import 'package:fitnessapp/screens/sideMenu/main_menu_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:messenger/model/providers/ThreadUserLinksProvider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MainMenuScreen extends StatefulWidget {
  final List<MenuItem> mainMenu;
  final Function(int)? callback;
  final int? current;

  const MainMenuScreen(
    this.mainMenu, {
    Key? key,
    this.callback,
    this.current,
  }) : super(key: key);

  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final widthBox = const SizedBox(
    width: 16.0,
  );

  final controller = Get.put(MainMenuController(), permanent: true);

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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.all(0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        ZoomDrawer.of(context)!.close();
                      },
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Spaces.y1,
                  Visibility(
                    visible:
                        MyHive.getUserType() != UserType.guest ? true : false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.h),
                          child: SizedBox(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                    style: TextStyles.subHeadingBlackMedium
                                        .copyWith(
                                            color: !Utils.isRTL()
                                                ? ColorConstants.whiteColor
                                                : ColorConstants.bodyTextColor,
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
                                    style: TextStyles.subHeadingBlackMedium
                                        .copyWith(
                                            color: Utils.isRTL()
                                                ? ColorConstants.whiteColor
                                                : ColorConstants.bodyTextColor,
                                            fontSize: 10.sp),
                                  )
                                ],
                              ),
                            ],
                          )),
                        ),
                        Spaces.y2,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Spaces.x4,
                            GetBuilder<MainMenuController>(
                                id: 'profileUpdate',
                                builder: (c) {
                                  return ClipOval(
                                    child: SizedBox(
                                        height: 9.h,
                                        width: 9.h,
                                        child: MyHive.getUser()?.imageUrl !=
                                                null
                                            ? CustomNetworkImage(
                                                placeholderUrl:
                                                    'assets/images/profile_ph.png',
                                                imageUrl:
                                                    MyHive.getUser()!.imageUrl!,
                                                fit: BoxFit.cover,
                                              )
                                            : SvgPicture.asset(
                                                'assets/svgs/profile_ph.svg',
                                                fit: BoxFit.cover,
                                                height: 9.h,
                                                width: 9.h,
                                              )),
                                  );
                                }),
                            Spaces.x4,
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          'welcome'.tr,
                                          style: TextStyles.mainScreenHeading
                                              .copyWith(
                                                  color:
                                                      ColorConstants.whiteColor,
                                                  fontSize: 19.sp),
                                        ),
                                      ),
                                      Text(
                                        MyHive.getUser()?.getFullName() ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyles.subHeadingBlackMedium
                                            .copyWith(
                                                color:
                                                    ColorConstants.whiteColor,
                                                fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                ),
                                Spaces.x4,
                              ],
                            ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible:
                        MyHive.getUserType() == UserType.guest ? true : false,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(start: 2.h, end: 2.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                    style: TextStyles.subHeadingBlackMedium
                                        .copyWith(
                                            color: !Utils.isRTL()
                                                ? ColorConstants.whiteColor
                                                : ColorConstants.bodyTextColor,
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
                                    style: TextStyles.subHeadingBlackMedium
                                        .copyWith(
                                            color: Utils.isRTL()
                                                ? ColorConstants.whiteColor
                                                : ColorConstants.bodyTextColor,
                                            fontSize: 10.sp),
                                  )
                                ],
                              ),
                            ],
                          )),
                          Spaces.y3,
                          SvgPicture.asset(
                            'assets/svgs/logo.svg',
                            height: 10.h,
                            width: 10.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spaces.y4,
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(start: 1.h),
                      child: Selector<MenuProviderUser, int>(
                        selector: (_, provider) => provider.currentPage,
                        builder: (_, index, __) => ListView(
                          shrinkWrap: true,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ...widget.mainMenu
                                    .map(
                                      (item) => (item.title.toString() ==
                                              'chat')
                                          ? Consumer<ThreadUserLinksProvider>(
                                              builder: (context, value, child) {
                                                controller
                                                    .updateThreadsListeners(
                                                        value);
                                                return Obx(
                                                  () => Stack(
                                                    children: [
                                                      MenuItemWidget(
                                                        key: Key(item.index
                                                            .toString()),
                                                        item: item,
                                                        callback:
                                                            widget.callback,
                                                        widthBox: widthBox,
                                                        style: style,
                                                        selected:
                                                            index == item.index,
                                                      ),
                                                      controller.unreadThreads
                                                              .isEmpty
                                                          ? const SizedBox()
                                                          : Container(
                                                              height: 2.0.h,
                                                              width: 2.0.h,
                                                              margin:
                                                                  EdgeInsetsDirectional
                                                                      .only(
                                                                top: 1.h,
                                                                start: 1.h,
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  controller
                                                                      .unreadThreads
                                                                      .length
                                                                      .toString(),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        6.0.sp,
                                                                  ),
                                                                ),
                                                              ),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: ColorConstants
                                                                    .redButtonBackground,
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          : MenuItemWidget(
                                              key: Key(item.index.toString()),
                                              item: item,
                                              callback: widget.callback,
                                              widthBox: widthBox,
                                              style: style,
                                              selected: index == item.index,
                                            ),
                                    )
                                    .toList()
                              ],
                            ),
                          ],
                        ),
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
                          Text(
                            'fit_and_more'.tr,
                            style: TextStyles.subHeadingWhiteMedium.copyWith(
                              color: ColorConstants.whiteColor,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
          SizedBox(
            height: 6.w,
            width: 6.w,
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
          ),
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
