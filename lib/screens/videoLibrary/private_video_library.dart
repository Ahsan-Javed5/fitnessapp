import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/models/private_group.dart';
import 'package:fitnessapp/screens/coachProfile/group_list_item.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:fitnessapp/widgets/empty_view.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../chat/controllers/chat_api_controller.dart';
import 'video_library_controller.dart';

class PrivateVideoLibrary extends StatelessWidget {
  PrivateVideoLibrary({Key? key}) : super(key: key);
  final controller = Get.put(VideoLibraryController());

  @override
  Widget build(BuildContext context) {
    controller.getAllPrivateGroups();

    /// If this is true then that means that we are using this screen to select a video
    /// to share that video in the free Main group or Paid sub group
    final bool isShareVideoMode = Get.arguments?['shareVideoMode'] ?? false;
    final chatController = Get.isRegistered<ChatApiController>()
        ? Get.find<ChatApiController>()
        : Get.put(ChatApiController());
    chatController.videoNavString.value =
        '${chatController.videoNavString.value}>${Get.currentRoute}';
    return CustomScreen(
      hasRightButton: true,
      hasSearchBar: true,
      onSearchbarClearText: () => controller.searchPrivateGroups(''),
      onSearchBarTextChange: (s) =>
          controller.searchPrivateGroups(s.toLowerCase()),
      rightButton: const HomeButton(),
      floatingActionButton: isShareVideoMode
          ? null
          : FloatingActionButton(
              onPressed: () => Get.toNamed(Routes.addPrivateGroupScreen),
              child: SvgPicture.asset('assets/svgs/ic_add_large.svg'),
              mini: false,
              materialTapTargetSize: MaterialTapTargetSize.padded,
            ),
      child: Obx(() {
        bool selectionEnabled = controller.isPrivateGroupSelectionEnabled();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spaces.y2_0,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('private'.tr,
                    softWrap: true, style: TextStyles.mainScreenHeading),
                if (selectionEnabled)
                  IconButton(
                    onPressed: () {},
                    icon: GestureDetector(
                      onTapDown: (d) =>
                          _showPopupMenu(d.globalPosition, context),
                      child: Icon(
                        Icons.more_vert,
                        color: ColorConstants.appBlack,
                        size: Spaces.normX(10),
                      ),
                    ),
                  )
              ],
            ),

            /// Second part of the title
            Text('video_library'.tr, style: TextStyles.mainScreenHeading),

            Spaces.y3,
            Expanded(
              child: Obx(
                () => controller.allPrivateGroups.isEmpty
                    ? const Center(child: EmptyView())
                    : ListView.builder(
                        itemCount: controller.tempGroups.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = controller.tempGroups[index];
                          return GroupListItem(
                            index: index,
                            translatedTitle: item.title ?? '',
                            tag1Text: item.formattedCreatedAtTime ?? '',
                            hasDesc: false,
                            imageUrl: item.imageUrl ?? '',
                            imagePaddingSpace: Spaces.x5,
                            isSelected:
                                controller.selectedPrivateGroups.contains(item),
                            onLongPress: () {
                              if (!isShareVideoMode) {
                                controller.updateSelectedPrivateGroup(item);
                              }
                            },
                            onPressed: () {
                              if (controller.isPrivateGroupSelectionEnabled()) {
                                controller.updateSelectedPrivateGroup(item);
                              } else {
                                if ((Get.isDialogOpen ?? false) ||
                                    (Get.isSnackbarOpen)) {
                                  Get.back();
                                }
                                controller.userSelectedPrivateGroup = item;
                                Get.toNamed(Routes.privateGroupVideoView,
                                    arguments: {
                                      'shareVideoMode': isShareVideoMode
                                    });
                              }
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showPopupMenu(Offset offset, BuildContext context) async {
    final isRtl = Get.locale?.languageCode == 'ar';
    double left = !isRtl ? offset.dx : 0;
    double top = offset.dy;
    double right = isRtl ? offset.dx : 0;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, right, 0),
      color: ColorConstants.whiteColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: ColorConstants.containerBorderColor)),
      items: [
        PopupMenuItem(
          padding: EdgeInsets.zero,
          value: 0,
          enabled: controller.selectedPrivateGroups.length < 2,
          textStyle: Get.textTheme.bodyText1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(start: Spaces.normX(3)),
                child: Text('edit'.tr),
              ),
              const Divider(),
            ],
          ),
        ),
        PopupMenuItem(
          padding: EdgeInsets.zero,
          value: 1,
          height: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(start: Spaces.normX(3)),
                child: Text('delete'.tr),
              ),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then(
      (value) {
        if (value != null) {
          if (value == 0) {
            var selectedItems = controller.selectedPrivateGroups;
            if (selectedItems.isNotEmpty) {
              Get.toNamed(Routes.addPrivateGroupScreen,
                  arguments: {'isEditable': true, 'group': selectedItems[0]});
            }
          } else if (value == 1) {
            showDialog(
              context: context,
              useRootNavigator: true,
              useSafeArea: false,
              builder: (context) {
                return DeleteConfirmationDialog(
                  deleteListener: () => deleteGroups(),
                  cancelListener: () => Get.back(),
                );
              },
            );
          }
          // else if (value == 2) {
          //   Get.toNamed(Routes.sendVideoToActiveUsers,
          //       arguments: {'videosToSend': selectedItems[0]});
          // }
        }
      },
    );
  }

  deleteGroups() async {
    Get.back();
    var selectedItems = controller.selectedPrivateGroups;
    var groupsIds = <int>[];
    for (PrivateGroup group in selectedItems) {
      var id = group.id;
      groupsIds.add(id!);
    }
    controller.deleteSelectedGroups(groupsIds).then((value) {
      if (value == true) {
        for (PrivateGroup v in selectedItems) {
          controller.tempGroups.remove(v);
          controller.allPrivateGroups.remove(v);
        }
      }
      controller.clearGroupSelection();
    });
  }
}
