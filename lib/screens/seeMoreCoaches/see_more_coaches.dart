import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/config/theme_size.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/constants/getx_controller_tag.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/screens/guest/filters_controller.dart';
import 'package:fitnessapp/screens/guest/main_workout_controller.dart';
import 'package:fitnessapp/widgets/actionBars/my_searchbar_v4.dart';
import 'package:fitnessapp/widgets/buttons/single_line_text_tag.dart';
import 'package:fitnessapp/widgets/country_flag_name.dart';
import 'package:fitnessapp/widgets/custom_network_image.dart';
import 'package:fitnessapp/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SeeMoreCoaches extends StatelessWidget {
  const SeeMoreCoaches({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FiltersController filtersController =
        Get.put(FiltersController(), tag: GetXControllerTag.coachesMoreFilter);
    final MainWorkOutController _controller = Get.put(MainWorkOutController(),
        tag: GetXControllerTag.coachesMoreList);
    //final controller = Get.put(SeeMoreController());
    // controller.getCoaches();

    return GradientBackground(
      includePadding: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      onPressed: () {
                        //Here I assign the Controller tag values for see more screen
                        GetXControllerTag.coachesListToggle =
                            GetXControllerTag.coachesMoreList;
                        GetXControllerTag.coachesFilterToggle =
                            GetXControllerTag.coachesMoreFilter;
                        Get.toNamed(Routes.filterScreen);
                      }),
                ],
              ),
              Spaces.y3,
              Padding(
                padding: EdgeInsets.only(left: 4.w, right: 4.w),
                child: Text(
                  'Coaches'.tr,
                  style: TextStyles.mainScreenHeading,
                ),
              ),
              Spaces.y2,
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.w, right: 4.w),
                    child: GetBuilder<MainWorkOutController>(
                      id: 'workout_for',
                      tag: GetXControllerTag.coachesMoreList,
                      builder: (c) {
                        return ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          itemCount: c.workoutForList.length,
                          itemBuilder: (context, index) {
                            final item = c.workoutForList[index];
                            return SeeMoreCoachListItem(
                              index: index,
                              name: item.getFullName(),
                              imageUrl: item.imageUrl ?? '',
                              countryInitials: item.country?.iso ?? 'pk',
                              gender: '${item.gender?.toLowerCase()}'.tr,
                              workOutType:
                                  item.userWorkoutProgramTypesToString(),
                              onPressed: () => Routes.to(Routes.coachProfile,
                                  arguments: {'data': item}),
                            );
                          },
                        );
                      },
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

class SeeMoreCoachListItem extends StatelessWidget {
  final int index;
  final String countryInitials;
  final String gender;
  final String workOutType;
  final String imageUrl;
  final String name;
  final VoidCallback onPressed;

  const SeeMoreCoachListItem(
      {Key? key,
      required this.index,
      required this.countryInitials,
      required this.gender,
      required this.workOutType,
      required this.imageUrl,
      required this.name,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: Spaces.normY(1.5), horizontal: Spaces.normX(3)),
            margin: EdgeInsets.only(bottom: Spaces.normY(1.8)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Spaces.normX(1)),
                border: Border.all(color: ColorConstants.grayLevel5)),
            child: Row(
              children: [
                ///Image
                SizedBox(
                  height: Spaces.normY(9),
                  width: Spaces.normY(9),
                  child: ClipOval(
                    child: CustomNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: imageUrl,
                    ),
                  ),
                ),

                Spaces.x4,
                SizedBox(
                  width: Spaces.normX(57),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title
                      Text(
                        name,
                        style: TextStyles.subHeadingSemiBold.copyWith(
                            fontFamily: FontConstants.montserratMedium),
                      ),

                      /// Gender and Country
                      Spaces.y1,
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// Country
                          CountryFlagAndName(countryInitials: countryInitials),

                          const Spacer(),

                          /// Gender
                          SvgPicture.asset(
                            'assets/svgs/ic_gender.svg',
                            height: Spaces.normY(2),
                            matchTextDirection: true,
                            fit: BoxFit.scaleDown,
                          ),
                          SizedBox(
                            width: Spaces.normX(1.5),
                          ),

                          Text(
                            gender,
                            style: TextStyles.normalBlackBodyText
                                .copyWith(fontSize: Spaces.normSP(10)),
                          ),
                        ],
                      ),

                      /// Tags
                      Spaces.y1,
                      Row(
                        children: [
                          SingleLineTextTag(
                            text: workOutType,
                            theme: ThemeSize.small,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
