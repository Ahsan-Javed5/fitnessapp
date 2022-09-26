import 'package:fitnessapp/models/user/user.dart';
import 'package:fitnessapp/screens/guest/filters_controller.dart';
import 'package:fitnessapp/screens/guest/main_workout_controller.dart';
import 'package:fitnessapp/screens/sideMenu/main_menu_controller.dart';
import 'package:fitnessapp/screens/subscriptions/subscription_controller.dart';
import 'package:fitnessapp/widgets/actionBars/my_searchbar_v4.dart';
import 'package:fitnessapp/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'coach_list_item.dart';
import 'coach_list_item_rect.dart';
import 'config/space_values.dart';
import 'config/text_styles.dart';
import 'constants/color_constants.dart';
import 'constants/font_constants.dart';
import 'constants/getx_controller_tag.dart';
import 'constants/routes.dart';
import 'data/local/my_hive.dart';
import 'widgets/gradient_background.dart';

class UserHomeScreen extends StatelessWidget {
  final VoidCallback? callback;

  UserHomeScreen({Key? key, this.callback}) : super(key: key);

  final mainWorkOutController = Get.put(MainWorkOutController(),
      tag: GetXControllerTag.coachesDefaultList);
  final subscriptionController = Get.put(SubscriptionController());
  final mainMenuController = Get.find<MainMenuController>();
  final FiltersController filtersController =
      Get.put(FiltersController(), tag: GetXControllerTag.coachesDefaultFilter);

  Future _refreshData() async {
    User? user = MyHive.getUser();
    mainWorkOutController.getUserInfo();
    mainWorkOutController.fetchUserCoaches(user!.gender!);
    subscriptionController.getSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    User user = MyHive.getUser()!;
    double _crossAxisSpacing = 6;
    double _mainAxisSpacing = 4;
    int _crossAxisCount = 2;
    double screenWidth = MediaQuery.of(context).size.width;

    var width = (screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var height = width / 260;

    return RefreshIndicator(
      onRefresh: () => _refreshData(),
      child: GradientBackground(
        includePadding: false,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Spaces.y1,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.all(0),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'assets/svgs/ic_menu.svg',
                          allowDrawingOutsideViewBox: true,
                          matchTextDirection: true,
                        ),
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          callback!();
                        },
                      ),
                    ),
                    MySearchbarV4(
                      onChange: (searchText) {
                        mainWorkOutController.onSearchChanged(searchText);
                      },
                      clearBtListener: () => mainWorkOutController
                          .fetchUserCoaches(mainWorkOutController.forGender),
                    ),
                    IconButton(
                        icon: SvgPicture.asset('assets/svgs/ic_filter.svg'),
                        onPressed: () {
                          Get.put(FiltersController(),
                              tag: GetXControllerTag.coachesFilterToggle);
                          Get.toNamed(Routes.filterScreen);
                        }),
                    Obx(
                      () => Stack(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: SvgPicture.asset('assets/svgs/ic_chat.svg'),
                            onPressed: () => Get.toNamed(Routes.chatMainScreen),
                          ),
                          mainMenuController.unreadThreads.isNotEmpty
                              ? PositionedDirectional(
                                  top: 0,
                                  end: 5,
                                  child: Container(
                                    height: 2.0.h,
                                    width: 2.0.h,
                                    margin: EdgeInsets.only(top: 1.h),
                                    child: Center(
                                      child: Text(
                                        mainMenuController.unreadThreads.length
                                            .toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8.0.sp,
                                        ),
                                      ),
                                    ),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorConstants.redButtonBackground,
                                    ),
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                  ],
                ),
                Spaces.y3,
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsDirectional.only(start: 2.h, end: 3.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'welcome'.tr,
                                      style: TextStyles.mainScreenHeading
                                          .copyWith(
                                              color: ColorConstants.appBlack),
                                    ),
                                    Text(
                                      user.getFullName(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyles.subHeadingBlackMedium
                                          .copyWith(fontSize: 16.sp),
                                    ),
                                  ],
                                ),
                              ),
                              GetBuilder<MainMenuController>(
                                  id: 'profileUpdateHome',
                                  builder: (c) {
                                    return ClipOval(
                                      child: user.imageUrl != null
                                          ? SizedBox(
                                              height: 9.h,
                                              width: 9.h,
                                              child: CustomNetworkImage(
                                                key: UniqueKey(),
                                                placeholderUrl:
                                                    'assets/images/profile_ph.png',
                                                fit: BoxFit.cover,
                                                imageUrl: MyHive.getUser()
                                                        ?.imageUrl ??
                                                    '',
                                              ),
                                            )
                                          : SvgPicture.asset(
                                              'assets/svgs/profile_ph.svg',
                                              fit: BoxFit.cover,
                                              height: 9.h,
                                              width: 9.h,
                                            ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                        Spaces.y3,
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 2.h),
                          child: Text(
                            'active_subscriptions'.tr,
                            style: TextStyles.normalBlackBodyText.copyWith(
                              fontSize: 11.sp,
                              fontFamily: FontConstants.montserratMedium,
                            ),
                          ),
                        ),
                        Spaces.y2,
                        SizedBox(
                            height: 8.5.h,
                            child: GetBuilder<SubscriptionController>(
                                id: subscriptionController.getActiveSubs,
                                builder: (controller) {
                                  return controller.availSub == 1
                                      ? ListView.separated(
                                          physics:
                                              const ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              controller.tempActiveSubs.length,
                                          padding: EdgeInsetsDirectional.only(
                                              start: 1.5.h, end: 1.5.h),
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              CoachListItemRect(
                                                  subscription: controller
                                                      .tempActiveSubs[index],
                                                  onPressed: () {
                                                    Routes.to(
                                                        Routes.coachProfile,
                                                        arguments: {
                                                          'data': controller
                                                              .tempActiveSubs[
                                                                  index]
                                                              .user
                                                        });
                                                  }),
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return Spaces.x1;
                                          },
                                        )
                                      : Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: Spaces.normX(4),
                                              vertical: Spaces.normX(1)),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                Spaces.normX(2)),
                                            color: ColorConstants
                                                .veryVeryLightGray,
                                            border: Border.all(
                                                color: ColorConstants
                                                    .dividerColor),
                                          ),
                                          width: double.infinity,
                                          child: Center(
                                            child: Text(
                                              'no_active_subscription'.tr,
                                              textAlign: TextAlign.center,
                                              style: TextStyles
                                                  .normalBlueBodyText
                                                  .copyWith(
                                                      fontSize:
                                                          Spaces.normSP(10)),
                                            ),
                                          ),
                                        );
                                })),
                        Spaces.y2,
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 2.h),
                          child: Text(
                            'available_coaches'.tr,
                            style: TextStyles.normalBlackBodyText.copyWith(
                              fontSize: 11.sp,
                              fontFamily: FontConstants.montserratMedium,
                            ),
                          ),
                        ),
                        Spaces.y1_0,
                        GetBuilder<MainWorkOutController>(
                            id: 'workout_for',
                            tag: GetXControllerTag.coachesDefaultList,
                            builder: (controller) {
                              return GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: _crossAxisCount,
                                  crossAxisSpacing: _crossAxisSpacing,
                                  mainAxisSpacing: _mainAxisSpacing,
                                  childAspectRatio: height,
                                ),
                                padding: EdgeInsetsDirectional.only(
                                    start: 3.w, end: 3.w),
                                itemCount:
                                    mainWorkOutController.workoutForList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return CoachListItem(
                                    coach: mainWorkOutController
                                        .workoutForList[index],
                                    onPressed: () {
                                      Routes.to(Routes.coachProfile,
                                          arguments: {
                                            'data': mainWorkOutController
                                                .workoutForList[index]
                                          });
                                    },
                                  );
                                },
                              );
                            }),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
