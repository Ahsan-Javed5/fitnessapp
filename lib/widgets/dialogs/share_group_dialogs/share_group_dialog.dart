import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/widgets/dialogs/share_group_dialogs/share_group_controller.dart';
import 'package:fitnessapp/widgets/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ShareGroupDialog extends StatelessWidget {
  final String selectedVideosIds;

  ShareGroupDialog({Key? key, required this.selectedVideosIds})
      : super(key: key);

  final controller = ShareGroupController();

  @override
  Widget build(BuildContext context) {
    controller.selectedVideosIds = selectedVideosIds;
    controller.fetchFreeAndPaidGroups();

    return Scaffold(
      backgroundColor: ColorConstants.buttonGradientStartColor,
      body: Padding(
        padding: EdgeInsetsDirectional.only(start: 3.h, end: 3.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Spaces.normX(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 60.h,
                decoration: const BoxDecoration(
                  color: ColorConstants.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.all(3.h),
                        child: SizedBox(
                          height: Spaces.normY(3),
                          width: Spaces.normY(3),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => cancelListener(),
                            icon: SvgPicture.asset('assets/svgs/ic_cross.svg'),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          controller.isShare.value ? 'Share'.tr : 'move_to'.tr,
                          style: TextStyles.heading6AppBlackSemiBold.copyWith(
                            fontSize: Spaces.normSP(15),
                            fontFamily: FontConstants.montserratExtraBold,
                          ),
                        ),
                      ),

                      Visibility(
                        visible: controller.isShare.value,
                        child: Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              start: 3.h,
                              end: 3.h,
                              top: 2.h,
                            ),
                            child: DefaultTabController(
                              length: 2,
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: SizedBox(
                                            height: 1,
                                            child: Container(
                                              color: ColorConstants
                                                  .unSelectedWidgetColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                        child: TabBar(
                                          indicatorWeight: 2,
                                          indicator:
                                              const UnderlineTabIndicator(
                                            borderSide: BorderSide(
                                              width: 1.0,
                                              color: ColorConstants.appBlue,
                                            ),
                                          ),
                                          indicatorColor: ColorConstants
                                              .unSelectedWidgetColor,
                                          unselectedLabelColor: ColorConstants
                                              .unSelectedWidgetColor,
                                          labelColor:
                                              ColorConstants.accentColor,
                                          labelStyle: TextStyles
                                              .subHeadingWhiteMedium
                                              .copyWith(fontSize: 13.sp),
                                          unselectedLabelStyle: TextStyles
                                              .subHeadingWhiteMedium
                                              .copyWith(fontSize: 13.sp),
                                          tabs: [
                                            Tab(text: 'Free groups'.tr),
                                            Tab(text: 'Paid groups'.tr),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: 1.h,
                                        bottom: 1.h,
                                      ),
                                      child: TabBarView(
                                        children: [
                                          controller.allFreeGroups.isEmpty
                                              ? const EmptyView(
                                                  showFullMessage: false)
                                              : ListView.builder(
                                                  itemBuilder: (c, i) {
                                                    return GestureDetector(
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Spaces.y5,
                                                          SizedBox(
                                                            height: 6.w,
                                                            width: 6.w,
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/svgs/ic_folder.svg',
                                                              matchTextDirection:
                                                                  false,
                                                            ),
                                                          ),
                                                          Spaces.x5,
                                                          Text(
                                                              controller
                                                                  .allFreeGroups[
                                                                      i]
                                                                  .title,
                                                              style: TextStyles
                                                                  .heading6AppBlackRegular
                                                                  .copyWith(
                                                                      color: ColorConstants
                                                                          .appBlack,
                                                                      fontSize:
                                                                          13.sp)),
                                                        ],
                                                      ),
                                                      onTap: () async {
                                                        controller
                                                                .selectedGroup =
                                                            controller
                                                                .allFreeGroups[i];
                                                        await controller
                                                            .fetchSubGroups();
                                                        controller.isShare
                                                            .value = false;
                                                      },
                                                    );
                                                  },
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  shrinkWrap: true,
                                                  itemCount: controller
                                                      .allFreeGroups.length,
                                                ),
                                          controller.allPaidGroups.isEmpty
                                              ? const EmptyView(
                                                  showFullMessage: false)
                                              : ListView.builder(
                                                  itemBuilder: (c, i) {
                                                    return GestureDetector(
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Spaces.y5,
                                                          SizedBox(
                                                            height: 6.w,
                                                            width: 6.w,
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/svgs/ic_folder.svg',
                                                              matchTextDirection:
                                                                  false,
                                                            ),
                                                          ),
                                                          Spaces.x5,
                                                          Text(
                                                              controller
                                                                  .allPaidGroups[
                                                                      i]
                                                                  .title,
                                                              style: TextStyles
                                                                  .heading6AppBlackRegular
                                                                  .copyWith(
                                                                      color: ColorConstants
                                                                          .appBlack,
                                                                      fontSize:
                                                                          13.sp)),
                                                        ],
                                                      ),
                                                      onTap: () async {
                                                        controller
                                                                .selectedGroup =
                                                            controller
                                                                .allPaidGroups[i];
                                                        await controller
                                                            .fetchSubGroups();
                                                        controller.isShare
                                                            .value = false;
                                                      },
                                                    );
                                                  },
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  shrinkWrap: true,
                                                  itemCount: controller
                                                      .allPaidGroups.length,
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Sub groups
                      Visibility(
                        visible: !controller.isShare.value,
                        child: Expanded(
                          child: GestureDetector(
                            onTap: () => controller.isShare.value = true,
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(
                                  start: 3.h, end: 3.h, top: 2.h, bottom: 3.h),
                              child: Column(
                                children: [
                                  SizedBox(
                                      height: 4.h,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Spaces.y4,
                                          Spaces.x2,
                                          SizedBox(
                                            height: 4.w,
                                            width: 4.w,
                                            child: SvgPicture.asset(
                                              'assets/svgs/ic_folder.svg',
                                              matchTextDirection: false,
                                              color:
                                                  ColorConstants.bodyTextColor,
                                            ),
                                          ),
                                          Spaces.x2,

                                          /// Navigation pane view
                                          Expanded(
                                              child: ListView.separated(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                controller.navPaneLength.value,
                                            itemBuilder: (BuildContext context,
                                                    int index) =>
                                                Row(
                                              children: [
                                                Spaces.x2,
                                                Opacity(
                                                  opacity: 0.5,
                                                  child: SizedBox(
                                                    height: 1.5.w,
                                                    width: 1.5.w,
                                                    child: SvgPicture.asset(
                                                      'assets/svgs/ic_chevron_right.svg',
                                                      matchTextDirection: true,
                                                      color: ColorConstants
                                                          .bodyTextColor,
                                                    ),
                                                  ),
                                                ),
                                                Spaces.x3,
                                                Text(
                                                    index == 0
                                                        ? controller
                                                                .selectedGroup
                                                                ?.title ??
                                                            ''
                                                        : controller
                                                            .selectedSubGroup
                                                            ?.title,
                                                    style: TextStyles
                                                        .normalGrayBodyText
                                                        .copyWith(
                                                      fontSize: 8.sp,
                                                      color: ColorConstants
                                                          .bodyTextColor,
                                                    )),
                                              ],
                                            ),
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return Spaces.x1;
                                            },
                                          ))
                                        ],
                                      )),
                                  SizedBox(height: 1.h),
                                  SizedBox(
                                    height: 1,
                                    child: Container(
                                      color:
                                          ColorConstants.unSelectedWidgetColor,
                                    ),
                                  ),

                                  /// Sub group list view
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 1.h, bottom: 1.h),
                                      child: controller
                                              .subGroupsOfAGroup.isEmpty
                                          ? const EmptyView(
                                              showFullMessage: false,
                                            )
                                          : controller.navPaneLength.value > 2
                                              ? const Center(
                                                  child: Text('Move here'))
                                              : Visibility(
                                                  visible: controller
                                                          .navPaneLength.value <
                                                      2,
                                                  child: ListView.builder(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    itemBuilder: (c, i) {
                                                      return GestureDetector(
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Spaces.y5,
                                                            SizedBox(
                                                              height: 6.w,
                                                              width: 6.w,
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/svgs/ic_folder.svg',
                                                                matchTextDirection:
                                                                    false,
                                                              ),
                                                            ),
                                                            Spaces.x4,
                                                            Text(
                                                                controller
                                                                    .subGroupsOfAGroup[
                                                                        i]
                                                                    .title,
                                                                style: TextStyles
                                                                    .heading6AppBlackRegular
                                                                    .copyWith(
                                                                        color: ColorConstants
                                                                            .appBlack,
                                                                        fontSize:
                                                                            12.sp)),
                                                          ],
                                                        ),
                                                        onTap: () {
                                                          controller
                                                                  .selectedSubGroup =
                                                              controller
                                                                  .subGroupsOfAGroup[i];
                                                          controller
                                                              .navPaneLength
                                                              .value = 2;
                                                        },
                                                      );
                                                    },
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    shrinkWrap: true,
                                                    itemCount: controller
                                                        .subGroupsOfAGroup
                                                        .length,
                                                  ),
                                                ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: cancelListener,
                                          child: Text('cancel'.tr),
                                          style: OutlinedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: Spaces.normX(5),
                                              vertical: Spaces.normY(1.5),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spaces.x3,
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () => controller
                                              .moveVideosToTheSubGroup(),
                                          child:
                                              FittedBox(child: Text('move'.tr)),
                                          style: ElevatedButton.styleFrom(
                                            primary: ColorConstants.appBlue,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: Spaces.normX(5),
                                              vertical: Spaces.normY(1.5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteListener() {
    controller.isShare.value = true;
    Get.back();
  }

  void cancelListener() {
    controller.isShare.value = true;
    Get.back();
  }
}
