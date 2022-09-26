import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/constants/getx_controller_tag.dart';
import 'package:fitnessapp/models/country.dart';
import 'package:fitnessapp/screens/guest/main_workout_controller.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'filters_controller.dart';

class FilterScreen extends StatelessWidget {
  FilterScreen({Key? key}) : super(key: key);

  final FiltersController filtersController =
      Get.find(tag: GetXControllerTag.coachesFilterToggle);

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      includePadding: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 1.w),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/svgs/ic_cross.svg',
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                //Expanded(child: Container(color: Colors.blueGrey, height: 6.h,)),
                Padding(
                    padding: EdgeInsetsDirectional.only(end: 4.w),
                    child: GestureDetector(
                      onTap: () {
                        filtersController.resetData();

                        //User filters cleared
                        //if(Utils.isUser())
                        // {
                        final MainWorkOutController mainWorkOutController =
                            Get.find(tag: GetXControllerTag.coachesListToggle);
                        mainWorkOutController.resetFilterParams();
                        // }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svgs/ic_reset.svg',
                            matchTextDirection: true,
                          ),
                          Spaces.x2,
                          Text('reset'.tr,
                              style: TextStyles.subHeadingWhiteMedium
                                  .copyWith(color: ColorConstants.appBlack)),
                        ],
                      ),
                    ))
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(start: 5.w),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    padding: EdgeInsetsDirectional.only(bottom: 5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spaces.y4,
                        Text('filters'.tr, style: TextStyles.mainScreenHeading),
                        Spaces.y3,
                        Text('gender'.tr,
                            style: TextStyles.heading6AppBlackSemiBold
                                .copyWith(fontSize: 15.sp)),
                        Spaces.y2,
                        Obx(
                          () => ListView.builder(
                            itemBuilder: (c, i) {
                              return GestureDetector(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Spaces.y5,
                                    SizedBox(
                                      height: 4.w,
                                      width: 4.w,
                                      child: SvgPicture.asset(
                                        filtersController
                                                .genderList[i].isChecked
                                            ? 'assets/svgs/ic_checked_radio.svg'
                                            : 'assets/svgs/ic_uncheck_radio.svg',
                                        matchTextDirection: false,
                                      ),
                                    ),
                                    Spaces.x3,
                                    Text(
                                        filtersController
                                            .genderList[i].genderType.tr,
                                        style: TextStyles.subHeadingWhiteMedium
                                            .copyWith(
                                                color: ColorConstants.appBlack,
                                                fontSize: 13.sp)),
                                  ],
                                ),
                                onTap: () {
                                  filtersController.setGender();
                                  var gender = filtersController.genderList[i];
                                  if (gender.isChecked) {
                                    gender.isChecked = false;
                                    filtersController.genderList[i] = gender;
                                  } else {
                                    gender.isChecked = true;
                                    filtersController.genderList[i] = gender;
                                  }
                                },
                              );
                            },
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            itemCount: filtersController.genderList.length,
                          ),
                        ),
                        Spaces.y4,
                        Text('workout_program_type'.tr,
                            style: TextStyles.heading6AppBlackSemiBold
                                .copyWith(fontSize: 15.sp)),
                        Spaces.y3,
                        Obx(
                          () => ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (c, i) {
                              return GestureDetector(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Spaces.y5,
                                    SizedBox(
                                      height: 4.w,
                                      width: 4.w,
                                      child: SvgPicture.asset(
                                        filtersController
                                                .workoutTypesList[i].isSelected
                                            ? 'assets/svgs/ic_checked_box.svg'
                                            : 'assets/svgs/ic_uncheck_box.svg',
                                        matchTextDirection: false,
                                      ),
                                    ),
                                    Spaces.x3,
                                    Text(
                                        filtersController
                                            .workoutTypesList[i].name!,
                                        style: TextStyles.subHeadingWhiteMedium
                                            .copyWith(
                                                color: ColorConstants.appBlack,
                                                fontSize: 13.sp)),
                                  ],
                                ),
                                onTap: () {
                                  var wpType =
                                      filtersController.workoutTypesList[i];
                                  if (wpType.isSelected) {
                                    wpType.isSelected = false;
                                    filtersController.workoutTypesList[i] =
                                        wpType;
                                  } else {
                                    wpType.isSelected = true;
                                    filtersController.workoutTypesList[i] =
                                        wpType;
                                  }
                                },
                              );
                            },
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            itemCount:
                                filtersController.workoutTypesList.length,
                          ),
                        ),
                        Spaces.y5,
                        Text('country'.tr,
                            style: TextStyles.heading6AppBlackSemiBold
                                .copyWith(fontSize: 15.sp)),
                        Spaces.y2,
                        Obx(() => Padding(
                            padding: EdgeInsetsDirectional.only(end: 5.w),
                            child: SizedBox(
                              height: 6.h,
                              child: DropdownButton<Country>(
                                isExpanded: true,
                                hint: Text(
                                  'select'.tr,
                                  style: Get.textTheme.bodyText1!.copyWith(
                                    fontFamily: FontConstants.montserratRegular,
                                    fontWeight: FontWeight.w300,
                                    color: ColorConstants.bodyTextColor
                                        .withOpacity(0.6),
                                    fontSize: 14.0.sp,
                                  ),
                                ),
                                isDense: true,
                                value:
                                    filtersController.countryObj.value.name ==
                                            null
                                        ? null
                                        : filtersController.countryObj.value,
                                iconSize: Spaces.normX(10),
                                iconEnabledColor: ColorConstants.appBlack,
                                underline: const Divider(
                                  thickness: 1,
                                  color: ColorConstants.appBlack,
                                ),
                                items: filtersController.countriesList
                                    .map((Country country) {
                                  return DropdownMenuItem<Country>(
                                    value: country,
                                    child: Text(country.name!,
                                        style: TextStyles.subHeadingWhiteMedium
                                            .copyWith(
                                                color: ColorConstants.appBlack,
                                                fontSize: 13.sp)),
                                  );
                                }).toList(),
                                onChanged: (country) {
                                  filtersController.countryObj.value = country!;
                                },
                              ),
                            )))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                  start: 5.w, end: 5.w, bottom: 5.h, top: 2.h),
              child: CustomElevatedButton(
                  text: 'apply'.tr,
                  onPressed: () {
                    Get.back();
                    /*if(!filtersController.isRest())
                      {
                        SearchCoachesController userController = Get.find();
                        userController.resetReqParams();
                        userController.setAPICall();
                      }
                    else{
                      SearchCoachesController userController = Get.find();
                      userController.fetchFilterCoaches(filtersController.getGender(), filtersController.getWT(), filtersController.countryObj.value.id!);
                    }*/

                    //if(Utils.isUser()){
                    final MainWorkOutController mainWorkOutController =
                        Get.find(tag: GetXControllerTag.coachesListToggle);
                    mainWorkOutController.fetchFilterCoaches(
                        filtersController.getGender(),
                        filtersController.getWT(),
                        filtersController.countryObj.value.id!);
                    // }
                  }),
            )
          ],
        )),
      ),
    );
  }
}
