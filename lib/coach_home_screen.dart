import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/constants/getx_controller_tag.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/screens/guest/filters_controller.dart';
import 'package:fitnessapp/screens/guest/main_workout_controller.dart';
import 'package:fitnessapp/widgets/actionBars/my_searchbar_v4.dart';
import 'package:fitnessapp/widgets/custom_network_image.dart';
import 'package:fitnessapp/widgets/gradient_background.dart';
import 'package:fitnessapp/widgets/loading_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'constants/color_constants.dart';
import 'screens/sideMenu/main_menu_controller.dart';

class CoachHomeScreen extends StatelessWidget {
  final VoidCallback? callback;

  CoachHomeScreen({
    Key? key,
    required this.callback,
  }) : super(key: key);

  final controller = Get.put(MainWorkOutController(),
      tag: GetXControllerTag.coachesDefaultList);
  final mainMenuController = Get.find<MainMenuController>();

  final FiltersController filtersController = Get.put(
    FiltersController(),
    tag: GetXControllerTag.coachesDefaultFilter,
  );

  @override
  Widget build(BuildContext context) {
    controller.getUserInfo();
    final coach = MyHive.getUser();
    double _crossAxisSpacing = 1;
    double _mainAxisSpacing = 0.5;
    int _crossAxisCount = 3;
    double screenWidth = MediaQuery.of(context).size.width;

    var width = (screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var height = width / 160;

    return RefreshIndicator(
      onRefresh: () async {
        await controller.getCoachStats();
        return controller.setAPICall();
      },
      child: GradientBackground(
        includePadding: false,
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Spaces.y0,
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
                        onChange: (searchText) =>
                            controller.onSearchChanged(searchText),
                        clearBtListener: () => controller.fetchUserCoaches(''),
                      ),
                      IconButton(
                          icon: SvgPicture.asset('assets/svgs/ic_filter.svg'),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            GetXControllerTag.coachesListToggle =
                                GetXControllerTag.coachesDefaultList;
                            GetXControllerTag.coachesFilterToggle =
                                GetXControllerTag.coachesDefaultFilter;
                            Get.toNamed(Routes.filterScreen);
                          }),
                      Obx(
                        () => Stack(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              icon: SvgPicture.asset('assets/svgs/ic_chat.svg'),
                              onPressed: () =>
                                  Get.toNamed(Routes.chatMainScreen),
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
                                          mainMenuController
                                              .unreadThreads.length
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
                                        color:
                                            ColorConstants.redButtonBackground,
                                      ),
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spaces.y2,
                  Column(
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
                                  Spaces.y0,
                                  Text(
                                    coach?.getFullName() ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyles.subHeadingBlackMedium
                                        .copyWith(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                            ),
                            GetBuilder<MainMenuController>(
                                id: 'profileUpdateHome',
                                builder: (context) {
                                  return ClipOval(
                                    child: SizedBox(
                                      height: 9.h,
                                      width: 9.h,
                                      child: CustomNetworkImage(
                                        key: UniqueKey(),
                                        imageUrl:
                                            MyHive.getUser()?.imageUrl ?? '',
                                        placeholderUrl:
                                            'assets/images/profile_ph.png',
                                      ),
                                    ),
                                  );
                                })
                          ],
                        ),
                      ),
                      Spaces.y1_0,
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                            start: 1.5.h, end: 1.5.h),
                        child: GetBuilder<MainWorkOutController>(
                          id: controller.getCoachStatsEndPoint,
                          tag: GetXControllerTag.coachesDefaultList,
                          builder: (c) {
                            return LoadingErrorWidget(
                              isLoading: controller.isStatApiLoading,
                              errorMessage:
                                  controller.coachStatsResponse?.message ?? '',
                              isError:
                                  controller.coachStatsResponse?.error ?? true,
                              refreshCallback: () async {
                                controller.getCoachStats();
                                controller.getUserInfo();
                              },
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: _crossAxisCount,
                                  crossAxisSpacing: _crossAxisSpacing,
                                  mainAxisSpacing: _mainAxisSpacing,
                                  childAspectRatio: height,
                                ),
                                padding: EdgeInsets.only(bottom: 0.5.h),
                                itemCount: controller.coachStatItems.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var item = controller.coachStatItems[index];
                                  return GestureDetector(
                                    onTap: () => Get.toNamed(item.routeName,
                                        arguments: {
                                          'pageIndex': item.pageIndex,
                                          'data': item.data
                                        }),
                                    child: Card(
                                      color: ColorConstants.veryVeryLightGray,
                                      shadowColor:
                                          ColorConstants.veryVeryLightGray,
                                      elevation: 0.5,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Spaces.y1,
                                          SvgPicture.asset(controller
                                              .coachStatItems[index].image),
                                          Spaces.y1_0,
                                          Text(
                                            controller
                                                .coachStatItems[index].count
                                                .toString(),
                                            style: TextStyles.mainScreenHeading
                                                .copyWith(
                                              color: Colors.black,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                          Spaces.y1,
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Spaces.normX(2)),
                                            child: SizedBox(
                                              height: 5.0.h,
                                              child: Text(
                                                controller.coachStatItems[index]
                                                    .name.tr,
                                                textAlign: TextAlign.center,
                                                style: TextStyles
                                                    .normalBlackBodyText
                                                    .copyWith(
                                                  fontSize: 8.5.sp,
                                                  color:
                                                      ColorConstants.appBlack,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Spaces.y1_0,
                      Padding(
                        padding: Spaces.getHoriPadding(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'coaches'.tr,
                              style: TextStyles.heading6AppBlackSemiBold
                                  .copyWith(fontSize: Spaces.normSP(15)),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.seeMoreCoaches);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'see_more'.tr,
                                    style: TextStyles.heading6AppBlackSemiBold
                                        .copyWith(
                                      fontFamily:
                                          FontConstants.montserratRegular,
                                      color: ColorConstants.appBlue
                                          .withOpacity(0.8),
                                      fontSize: Spaces.normSP(13),
                                    ),
                                  ),
                                  Spaces.x2,
                                  SizedBox(
                                    height: 3.w,
                                    width: 3.w,
                                    child: SvgPicture.asset(
                                      'assets/svgs/ic_arrow_end.svg',
                                      color: ColorConstants.appBlue,
                                      matchTextDirection: true,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Spaces.y2,
                      SizedBox(
                        height: 35.h,
                        child: GetBuilder<MainWorkOutController>(
                          id: 'workout_for',
                          tag: GetXControllerTag.coachesDefaultList,
                          builder: (c) {
                            return LoadingErrorWidget(
                              isLoading: controller.isCoachApiLoading,
                              errorMessage: controller.coachListErrorMsg,
                              isError: controller.isCoachListError,
                              refreshCallback: () => controller.setAPICall(),
                              child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: controller.workoutForList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final item = controller.workoutForList[index];
                                  return GestureDetector(
                                    onTap: () => Get.toNamed(
                                        Routes.coachProfile,
                                        arguments: {'data': item}),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 1.5.h, horizontal: 3.w),
                                      margin: EdgeInsets.only(
                                          top: 1.5.h, left: 3.w, right: 3.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(1.w),
                                        border: Border.all(
                                            color: ColorConstants.grayLevel5),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        children: [
                                          ClipOval(
                                            child: SizedBox(
                                              height: 9.h,
                                              width: 9.h,
                                              child: CustomNetworkImage(
                                                imageUrl: item.imageUrl,
                                              ),
                                            ),
                                          ),
                                          Spaces.x4,
                                          Text(
                                            item.getFullName(),
                                            style:
                                                TextStyles.normalBlackBodyText,
                                            maxLines: 1,
                                          ),
                                          const Spacer(),
                                          SizedBox(
                                            height: 3.w,
                                            width: 3.w,
                                            child: SvgPicture.asset(
                                              'assets/svgs/ic_arrow_end.svg',
                                              color: ColorConstants.grayLevel5,
                                              matchTextDirection: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Spaces.x2;
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
