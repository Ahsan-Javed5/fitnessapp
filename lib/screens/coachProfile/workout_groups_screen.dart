import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/models/user/coach_groups_count_list.dart';
import 'package:fitnessapp/screens/coachProfile/group_controller.dart';
import 'package:fitnessapp/screens/coachProfile/group_list_item.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'video_list_controller.dart';

////////////////////////////////////////////////
//                                            //
//        Heading: Free/Paid                  //
//        Items:   Main Groups                //
//                                            //
////////////////////////////////////////////////
class WorkoutGroupsScreen extends StatelessWidget {
  const WorkoutGroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GroupController());
    CoachGroupCount? group;
    if (Get.arguments != null) {
      group = Get.arguments['mainGroup'];
    }

    controller.setMainGroupParam(group!.type!, '', group.coachId);
    //bool isFree = group!.isFree;
    //c.getSubGroups(group.id ?? -1);

    bool isFree = group.type == 'Free' ? true : false;

    return CustomScreen(
      hasBackButton: true,
      hasSearchBar: false,
      hasRightButton: true,
      rightButton: const HomeButton(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Main title
            Spaces.y2_0,
            Text(
              isFree ? 'free_group'.tr : 'paid_group'.tr,
              style: Get.textTheme.headline1,
            ),

            GetBuilder<GroupController>(
              id: 'api/coach_group/main_groups',
              builder: (controller) {
                return (controller.mainGroups.isEmpty)
                    ? Expanded(
                        child: Center(
                          child: Text(isFree
                              ? 'main_group_list_is_empty'.tr
                              : 'subgroup_list_is_empty'.tr),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.mainGroups.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final item = controller.mainGroups[index];
                            return GroupListItem(
                              index: index,
                              translatedTitle: item.title ?? '',
                              description: item.description ?? '',
                              tag2Text: item.formattedCreatedAtTime ?? '',
                              imageUrl: item.groupThumbnail ?? '',
                              onPressed: () {
                                final c = Get.put(VideoListController());
                                c.navigationString = item.title ?? 'MG';
                                if (item.isFree) {
                                  Get.toNamed(Routes.workoutFreeMainGroupScreen,
                                      arguments: {'group_data': item});
                                } else {
                                  Get.toNamed(Routes.workoutMainGroupScreen,
                                      arguments: {'group_data': item});
                                }
                              },
                            );
                          },
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
