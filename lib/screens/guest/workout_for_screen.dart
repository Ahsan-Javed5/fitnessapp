import 'package:fitnessapp/coach_list_item.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/getx_controller_tag.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/screens/guest/filters_controller.dart';
import 'package:fitnessapp/screens/guest/main_workout_controller.dart';
import 'package:fitnessapp/widgets/actionBars/my_searchbar_v4.dart';
import 'package:fitnessapp/widgets/gradient_background.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class WorkoutForScreen extends StatelessWidget {
  WorkoutForScreen({Key? key}) : super(key: key);

  final _controller = Get.put(MainWorkOutController(),
      tag: GetXControllerTag.coachesDefaultList);
  final FiltersController filtersController =
      Get.put(FiltersController(), tag: GetXControllerTag.coachesDefaultFilter);

  @override
  Widget build(BuildContext context) {
    double _crossAxisSpacing = 6;
    double _mainAxisSpacing = 4;
    int _crossAxisCount = 2;
    double screenWidth = MediaQuery.of(context).size.width;

    /*if (Get.arguments != null) {
      if (Get.arguments['usertype'] != null) {
        final title = Get.arguments['usertype'];
        _controller.fetchCoaches(title);
      }
    }*/

    var width = (screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var height = width / 240;

    return GradientBackground(
      includePadding: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/svgs/ic_arrow.svg',
                        allowDrawingOutsideViewBox: true,
                        matchTextDirection: true,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  MySearchbarV4(
                    onChange: (searchText) {
                      _controller.onSearchChanged(searchText);
                    },
                    clearBtListener: () =>
                        _controller.fetchUserCoaches(_controller.genderType),
                  ),
                  IconButton(
                    icon: SvgPicture.asset('assets/svgs/ic_filter.svg'),
                    onPressed: () => Get.toNamed(Routes.filterScreen),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 2.w),
                    child: const HomeButton(),
                  )
                ],
              ),
              Obx(
                () => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 5.w,
                      right: 5.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          _controller.title.value,
                          style: TextStyles.mainScreenHeading,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Expanded(
                          child: GetBuilder<MainWorkOutController>(
                            id: 'workout_for',
                            tag: GetXControllerTag.coachesDefaultList,
                            builder: (c) => GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: _crossAxisCount,
                                      crossAxisSpacing: _crossAxisSpacing,
                                      mainAxisSpacing: _mainAxisSpacing,
                                      childAspectRatio: height),
                              padding: EdgeInsets.only(bottom: 2.h),
                              itemCount: c.workoutForList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CoachListItem(
                                  coach: _controller.workoutForList[index],
                                  onPressed: () => Routes.to(
                                      Routes.coachProfile,
                                      arguments: {
                                        'data':
                                            _controller.workoutForList[index]
                                      }),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
