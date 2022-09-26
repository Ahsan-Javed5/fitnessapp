import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/screens/coachProfile/group_list_item.dart';
import 'package:fitnessapp/screens/freePaidGroups/free_and_paid_groups_controller.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// This screen will be used to add videos when coach is going to edit subgroup
class SelectVideoScreen extends StatelessWidget {
  const SelectVideoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FreeAndPaidGroupController>(
      builder: (ctr) {
        return CustomScreen(
          hasSearchBar: false,
          titleTopMargin: 1,
          titleBottomMargin: 1,
          hasRightButton: true,
          rightButton: TextButton(
            child: Text('clear'.tr),
            onPressed: () => ctr.clearSubGroupVideoList(),
          ),
          backButtonIconPath: 'assets/svgs/ic_cross.svg',
          backHandler: () => Routes.back(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'select'.tr,
                    style: TextStyles.mainScreenHeading,
                  ),
                  SizedBox(
                    width: Spaces.normX(20),
                    height: Spaces.normY(5),
                    child: CustomElevatedButton(
                      onPressed: () => Routes.back(),
                      text: 'add'.tr,
                    ),
                  )
                ],
              ),
              Spaces.y3,
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return GroupListItem(
                      index: index,
                      translatedTitle: 'video_title'.tr,
                      tag1Text: '01:43',
                      imageUrl: 'assets/images/dummy_video_detail.png',
                      isSelected: ctr.editSubGroupVideos.contains(index),
                      onPressed: () => ctr.updateSubGroupVideoList(index),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
