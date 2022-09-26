import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/data.dart';
import 'package:fitnessapp/constants/getx_controller_tag.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/screens/guest/guest_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'main_workout_controller.dart';

class GuestHomeScreen extends StatelessWidget {
  final VoidCallback? callback;

  GuestHomeScreen({Key? key, this.callback}) : super(key: key);

  //final _workOutController = Get.put(MainWorkOutController(), tag: GetXcontrollerTag.coachesDefaultList);

  final _controller = Get.put(GuestHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
              padding: EdgeInsets.only(
                left: 5.w,
                right: 5.w,
              ),
              child: RefreshIndicator(
                  onRefresh: _refreshData,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spaces.y2,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.all(0),
                            child: GestureDetector(
                              child: SvgPicture.asset(
                                'assets/svgs/ic_menu.svg',
                                allowDrawingOutsideViewBox: true,
                                matchTextDirection: true,
                              ),
                              onTap: (){
                                callback!();
                              },
                            )
                          ),
                        ],
                      ),
                      Spaces.y5,
                      Text('guest'.tr, style: TextStyles.mainScreenHeading,),
                      Spaces.y2,
                      Text('select_your_preferred'.tr, style: TextStyles.subHeadingGrayMedium,),
                      Spaces.y3,
                      Expanded(
                        child: Obx(
                          () => ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (c, i) => GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 2.h),
                                  child: SizedBox(
                                    height: 20.h,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(3.w),
                                          child: Image.asset(
                                            _controller
                                                .workoutList[i].image,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.only(start: 4.w, end: 4.w),
                                              child: Text(
                                                  _controller.workoutList[i]
                                                      .workTypeDes.tr,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyles
                                                      .headingAppBlackBold.copyWith(color: ColorConstants.whiteColor, fontSize: 15.sp)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () => {
                                      //move to sub categories level
                                      DataUtils.userType = _controller.workoutList[i].workType,
                                      Get.toNamed(Routes.workoutFor)
                                    }),
                            padding: EdgeInsets.only(bottom: 2.h),
                            shrinkWrap: true,
                            itemCount: _controller.workoutList.length,
                          ),
                        ),
                      ),
                    ],
                  ))),
        ));
  }

  Future<void> _refreshData() async {
  }
}
