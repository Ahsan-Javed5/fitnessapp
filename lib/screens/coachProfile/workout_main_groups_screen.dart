import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/models/main_group.dart';
import 'package:fitnessapp/screens/coachProfile/group_controller.dart';
import 'package:fitnessapp/screens/coachProfile/video_list_controller.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'group_list_item.dart';

////////////////////////////////////////////////
//                                            //
//        Heading: Main Group                 //
//        Items:   Sub Groups                 //
//                                            //
////////////////////////////////////////////////

class WorkoutMainGroupsScreen extends StatelessWidget {
  const WorkoutMainGroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //bool isFree = false;
    MainGroup? group;

    // if (Get.arguments != null) {
    //   isFree = Get.arguments['isFree'];
    // }

    if (Get.arguments != null) {
      group = Get.arguments['group_data'];
    }

    var groupController = Get.find<GroupController>();
    groupController.setSubGroupParam(
        group!.groupPlain.toString(), '', group.id!);
    groupController.subGroups.clear();

    return CustomScreen(
      hasBackButton: true,
      hasSearchBar: false,
      hasRightButton: true,
      rightButton: const HomeButton(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: DefaultTabController(
          length: 4,
          initialIndex: 0,
          child: GetBuilder<GroupController>(
              id: 'api/coach_group/sub_groups',
              builder: (controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Main title
                    Spaces.y2_0,
                    Text(
                      group?.title ?? '',
                      style: Get.textTheme.headline1,
                    ),

                    /// Desc View
                    Spaces.y1_0,
                    Text(
                      group?.description ?? '',
                      style: TextStyles.normalGrayBodyText.copyWith(
                          fontSize: 9.5.sp,
                          fontFamily: FontConstants.montserratRegular),
                      maxLines: 4,
                      textAlign: TextAlign.justify,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),

                    /// Date
                    Spaces.y1_0,
                    Spaces.y0,
                    Text(
                      'created_at'.tr.toUpperCase(),
                      style: Get.textTheme.bodyText2!.copyWith(
                        fontSize: 9.0.sp,
                      ),
                    ),
                    Spaces.y0,
                    Text(
                      group?.formattedCreatedAtTime,
                      style: TextStyles.subHeadingWhiteMedium
                          .copyWith(color: ColorConstants.appBlack),
                    ),

                    /// Subgroups List
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: groupController.subGroups.length,
                        itemBuilder: (context, index) {
                          final item = groupController.subGroups[index];
                          return GroupListItem(
                            index: index,
                            translatedTitle: item.title,
                            description: item.description,
                            showReportIcon: false,
                            imageUrl: item.groupThumbnail ?? '',
                            tag2Text: item.formattedTime,
                            onPressed: () {
                              final c = Get.find<VideoListController>();
                              c.navigationString =
                                  '${c.navigationString} > ${item.title ?? 'SG'}';

                              Get.toNamed(Routes.workoutSubGroupScreen,
                                  arguments: {'video_data': item});
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
