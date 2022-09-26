import 'dart:developer';

import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/models/video.dart';
import 'package:fitnessapp/screens/chat/controllers/chat_api_controller.dart';
import 'package:fitnessapp/screens/coachProfile/group_list_item.dart';
import 'package:fitnessapp/screens/freePaidGroups/free_and_paid_groups_controller.dart';
import 'package:fitnessapp/screens/videoLibrary/video_library_controller.dart';
import 'package:fitnessapp/screens/video_player_screen.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:fitnessapp/widgets/empty_view.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PrivateGroupVideoView extends StatelessWidget {
  PrivateGroupVideoView({Key? key}) : super(key: key);
  final controller = Get.find<VideoLibraryController>();

  @override
  Widget build(BuildContext context) {
    controller.clearVideoSelection();
    controller.videosOfPrivateGroup.clear();
    controller.tempVideosOfPrivateGroup.clear();
    controller.getVideosOfPrivateGroup();

    /// If this is true then that means that we are using this screen to select a video
    /// to share that video in the free Main group or Paid sub group
    final bool isShareVideoMode = Get.arguments?['shareVideoMode'] ?? false;
    final chatController = Get.isRegistered<ChatApiController>()
        ? Get.find<ChatApiController>()
        : Get.put(ChatApiController());
    chatController.videoNavString.value =
        '${chatController.videoNavString.value}>${Get.currentRoute}';
    return GetBuilder<VideoLibraryController>(
      id: controller.getVideosOfPrivateGroupEP,
      builder: (ctr) {
        bool selectionMode = ctr.isVideoSelectionEnabled();
        return CustomScreen(
          hasRightButton: !selectionMode,
          titleTopMargin: 1,
          titleBottomMargin: 1,
          backButtonIconPath: selectionMode ? 'assets/svgs/ic_cross.svg' : null,
          hasSearchBar: !selectionMode,
          onSearchbarClearText: () => controller.searchPrivateVideos(''),
          onSearchBarTextChange: (s) =>
              controller.searchPrivateVideos(s.toLowerCase()),
          rightButton: const HomeButton(),
          floatingActionButton: selectionMode || isShareVideoMode
              ? null
              : FloatingActionButton(
                  onPressed: () =>
                      Get.toNamed(Routes.addMultiplePrivateVideosScreen),
                  child: SvgPicture.asset('assets/svgs/ic_add_large.svg'),
                  mini: false,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      controller.userSelectedPrivateGroup?.title ??
                          'No Title Found',
                      style: TextStyles.mainScreenHeading,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (selectionMode)
                    IconButton(
                      onPressed: () {},
                      icon: GestureDetector(
                        onTapDown: (d) {
                          if (controller.isVideoSelectionEnabled()) {
                            _showPopupMenu(d.globalPosition, context);
                          }
                        },
                        child: Icon(
                          Icons.more_vert,
                          color: ColorConstants.appBlack,
                          size: Spaces.normX(10),
                        ),
                      ),
                    )
                ],
              ),
              Spaces.y3,
              Expanded(
                child: controller.videosOfPrivateGroup.isEmpty
                    ? const EmptyView()
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.tempVideosOfPrivateGroup.length,
                        itemBuilder: (context, index) {
                          final item =
                              controller.tempVideosOfPrivateGroup[index];
                          return GroupListItem(
                            key: UniqueKey(),
                            index: index,
                            translatedTitle: item.title,
                            description: item.description,
                            tag1Text: item.duration,
                            imageUrl: item.videoUrl ?? '',
                            isVideo: true,
                            videoImageThumbnail: item.thumbnail,
                            isTitleBold: false,
                            isSelected:
                                ctr.selectedPrivateVideos.contains(item),
                            onLongPress: () {
                              if (!isShareVideoMode) {
                                ctr.updateSelectedVideo(item);
                              }
                            },
                            onPressed: () {
                              if (isShareVideoMode) {
                                /// if share mode is enabled then we need to find the
                                /// free and paid group controller because it has already initialized
                                /// so that we can share the selected video object to this controller
                                /// and from there we can call api and send this data to there
                                final freePaidController =
                                    Get.find<FreeAndPaidGroupController>();

                                freePaidController.videosToBeShared.clear();
                                freePaidController.videosToBeShared.add(item);
                                Get.until((route) =>
                                    Get.currentRoute == Routes.addVideoPage);
                              } else if (ctr.isVideoSelectionEnabled()) {
                                ctr.updateSelectedVideo(item);
                              } else {
                                log('video URl: ${item.videoUrl} \n Streaming URL : ${item.videoStreamUrl}');
                                showDialog(
                                  context: context,
                                  builder: (context) => VideoPlayerScreen(
                                    url: item.videoUrl ?? '',
                                    videoId: item.id ?? -1,
                                    processStatus: item.isProcessed ?? 0,
                                    videoStreamUrl: item.videoStreamUrl ?? '',
                                  ),
                                  useSafeArea: false,
                                );
                              }
                            },
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
          enabled: controller.selectedPrivateVideos.length < 2,
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
              const Divider(),
            ],
          ),
        ),
        PopupMenuItem(
          padding: EdgeInsets.zero,
          value: 2,
          height: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(start: Spaces.normX(3)),
                child: Text('share'.tr),
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
            var selectedItems = controller.selectedPrivateVideos;
            if (selectedItems.isNotEmpty) {
              Get.toNamed(Routes.addPrivateVideoScreen,
                  arguments: {'isEditable': true, 'video': selectedItems[0]});
            }
          } else if (value == 1) {
            showDialog(
              context: context,
              useRootNavigator: true,
              useSafeArea: false,
              builder: (context) {
                return DeleteConfirmationDialog(
                  deleteListener: () => deleteVideos(),
                  cancelListener: buttonHandler,
                );
              },
            );
          } else if (value == 2) {
            Get.toNamed(Routes.sendVideoToActiveUsers, arguments: {
              'videosToSend': controller.selectedPrivateVideos,
            });
            // final ids = <String>[];
            // for (Video v in controller.selectedPrivateVideos) {
            //   ids.add(v.id.toString());
            // }
            // controller.clearVideoSelection();
            // showDialog(
            //   context: context,
            //   useRootNavigator: true,
            //   useSafeArea: false,
            //   builder: (context) {
            //     return ShareGroupDialog(
            //       selectedVideosIds: ids.toString(),
            //     );
            //   },
            // );
          }
        }
      },
    );
  }

  buttonHandler() {
    controller.clearVideoSelection();
    Get.back();
  }

  deleteVideos() async {
    Get.back();
    var selectedItems = controller.selectedPrivateVideos;
    var videoIdsList = <int>[];
    for (Video video in selectedItems) {
      var videoId = video.id;
      videoIdsList.add(videoId!);
    }
    controller.deleteSelectedVideos(videoIdsList).then((value) {
      if (value == true) {
        for (Video v in selectedItems) {
          controller.tempVideosOfPrivateGroup.remove(v);
          controller.videosOfPrivateGroup.remove(v);
        }
      }
      controller.clearVideoSelection();
    });
  }
}
