import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/data.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/constants/view_as_type.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/main_group.dart';
import 'package:fitnessapp/screens/coachProfile/group_list_item.dart';
import 'package:fitnessapp/screens/coachProfile/video_list_controller.dart';
import 'package:fitnessapp/screens/freePaidGroups/free_and_paid_groups_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:fitnessapp/widgets/empty_view.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class FreePaidSubGroupScreen extends StatelessWidget {
  FreePaidSubGroupScreen({Key? key}) : super(key: key);
  final controller = Get.find<FreeAndPaidGroupController>();

  @override
  Widget build(BuildContext context) {
    /// if this is not null that means user was in free main group screen
    /// and according to the requirement free main group can't have sub groups
    /// that's why we are directly showing video screen
    final mainGroup = Get.arguments as MainGroup?;
    bool isFreeMainGroup = mainGroup != null;

    String title = '';
    String description = '';
    String formattedDateTime = '';

    if (isFreeMainGroup) {
      title = controller.userSelectedMainGroup?.title ?? '';
      description = controller.userSelectedMainGroup?.description ?? '';
      formattedDateTime =
          controller.userSelectedMainGroup?.formattedCreatedAtTime ?? '';
    } else {
      title = controller.userSelectedSubGroup?.title ?? '';
      description = controller.userSelectedSubGroup?.description ?? '';
      formattedDateTime = controller.userSelectedSubGroup?.formattedTime ?? '';
    }

    controller.videos.clear();
    controller.fetchVideos(isMainGroup: isFreeMainGroup);
    controller.isReorderVideo.value = false;
    controller.videoEditEnabled.value = false;
    return CustomScreen(
      titleTopMargin: 3,
      hasRightButton: true,
      hasSearchBar: true,
      rightButton: const HomeButton(),
      onSearchbarClearText: () => controller.searchInVideos(''),
      onSearchBarTextChange: (s) => controller.searchInVideos(s.toLowerCase()),
      screenTitleTranslated: title,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var results = await Get.toNamed(Routes.addVideoPage);
          if (DataUtils.errorMessage.isNotEmpty) {
            Future.delayed(const Duration(milliseconds: 500), () {
              Get.defaultDialog(
                title: 'info'.tr,
                middleText: DataUtils.errorMessage,
                titleStyle: const TextStyle(color: ColorConstants.appBlack),
                middleTextStyle:
                    const TextStyle(color: ColorConstants.appBlack),
              );
              DataUtils.errorMessage = '';
            });
          }
        },
        child: SvgPicture.asset('assets/svgs/ic_add_large.svg'),
        mini: false,
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
      titleBottomMargin: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spaces.y1_0,
          Text(
            description,
            style: TextStyles.normalGrayBodyText.copyWith(
                fontSize: 9.5.sp, fontFamily: FontConstants.montserratRegular),
            maxLines: 4,
            textAlign: TextAlign.justify,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),

          /// Date
          Spaces.y2,
          Spaces.y0,
          Text(
            'created_at'.tr.toUpperCase(),
            style: Get.textTheme.bodyText2!.copyWith(
              fontSize: 9.0.sp,
            ),
          ),
          Spaces.y0,
          Row(
            children: [
              Text(
                formattedDateTime,
                style: TextStyles.subHeadingWhiteMedium
                    .copyWith(color: ColorConstants.appBlack),
              ),
              const Spacer(),
              Obx(() {
                return controller.isReorderVideo.value
                    ? const SizedBox()
                    : AnimatedSwitcher(
                        duration: const Duration(microseconds: 300),
                        child: controller.videoEditEnabled.value
                            ? GestureDetector(
                                key: UniqueKey(),
                                onTapDown: (details) {
                                  _showPopupMenu(
                                      details.globalPosition, context);
                                },
                                child: const Icon(
                                  Icons.more_vert,
                                  color: ColorConstants.appBlack,
                                ),
                              )
                            : GestureDetector(
                                key: UniqueKey(),
                                onTapDown: (details) {
                                  controller.videoEditEnabled.value = true;
                                },
                                child:
                                    SvgPicture.asset('assets/svgs/ic_edit.svg'),
                              ),
                      );
              }),
              Obx(() {
                return controller.isReorderVideo.value &&
                        !controller.videoEditEnabled.value
                    ? TextButton(
                        onPressed: () {
                          controller.saveVideoOrder();
                        },
                        child: Text('save'.tr))
                    : const SizedBox();
              }),
            ],
          ),

          Spaces.y3,
          Expanded(
            child: Obx(() => controller.videos.isEmpty
                ? const EmptyView()
                : GetBuilder<FreeAndPaidGroupController>(
                    id: 'video_selection_builder',
                    builder: (cont) {
                      return ReorderableListView.builder(
                        onReorder: (int oldIndex, int newIndex) {
                          if (controller.tempVideos.length !=
                              controller.videos.length) {
                            /// user is searching so don't let use change the position
                            /// when searching because all items are not present
                            Utils.showSnack('alert'.tr,
                                'You cannot change position while searching');
                          } else if (controller.videoEditEnabled.value) {
                            Utils.showSnack('alert'.tr,
                                'You cannot change position while editing is enabled');
                          } else {
                            if (newIndex > oldIndex) {
                              newIndex -= 1;
                            }
                            final items =
                                controller.tempVideos.removeAt(oldIndex);
                            controller.tempVideos.insert(newIndex, items);
                            controller.isReorderVideo.value = true;
                          }
                        },
                        itemCount: controller.tempVideos.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = controller.tempVideos[index];
                          return GroupListItem(
                            index: index,
                            key: ValueKey(item.hashCode),
                            translatedTitle: item.title,
                            tag1Text: item.duration,
                            imageUrl: item.videoUrl ?? '',
                            isVideo: true,
                            videoImageThumbnail: item.thumbnail,
                            isSelected:
                                controller.selectedMultiVideos.contains(item),
                            showNotifyButton: controller
                                        .userSelectedMainGroup?.groupPlain
                                        ?.toLowerCase() ==
                                    'paid' &&
                                !(controller
                                        .tempVideos[index].notifySubscriber ??
                                    true),
                            description: item.description,
                            onNotifyPressed: () async {
                              var res = await controller.notifySubscriber(
                                  item.id ?? 0, 'SUB_GROUP', context, true);
                              if (res) {
                                controller.tempVideos[index].notifySubscriber =
                                    true;
                                controller.update(['video_selection_builder']);
                              }
                            },
                            onPressed: () {
                              if (controller.videoEditEnabled.value) {
                                controller.updatedSelectedVideos(item);
                                return;
                              } else {
                                final c = Get.put(VideoListController());
                                c.videoList.clear();
                                c.videoList.addAll(controller.tempVideos);
                                if (isFreeMainGroup) {
                                  c.navigationString =
                                      '${controller.userSelectedMainGroup?.title ?? ''}';
                                } else {
                                  c.navigationString =
                                      '${controller.userSelectedMainGroup?.title ?? ''} > ${controller.userSelectedSubGroup?.title ?? ''}';
                                }

                                c.workoutProgramTypeString = MyHive.getUser()
                                        ?.userWorkoutProgramTypesToString() ??
                                    '';
                                c.setVideoDetailData(index);
                                Get.toNamed(Routes.videoDetailScreen,
                                    arguments: {'viewAs': ViewAsType.self});
                              }
                            },
                          );
                        },
                      );
                    },
                  )),
          ),
        ],
      ),
    );
  }

  void _showPopupMenu(Offset offset, BuildContext context) async {
    final isRtl = Get.locale?.languageCode == 'ar';
    double left = !isRtl ? offset.dx : 0;
    double top = offset.dy;
    double right = isRtl ? offset.dx : 0;
    int length = controller.selectedMultiVideos.length;
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
          value: 1,
          enabled: length == 1,
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
          value: 2,
          height: 1,
          enabled: length > 0,
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
          value: 3,
          height: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(start: Spaces.normX(3)),
                child: Text('cancel'.tr),
              ),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then(
      (value) {
        if (value != null) {
          if (value == 1) {
            Get.toNamed(Routes.addVideoPage, arguments: {
              'isEditable': true,
              'video': controller.selectedMultiVideos[0],
            });
          } else if (value == 2) {
            showDialog(
              context: context,
              useRootNavigator: true,
              useSafeArea: false,
              builder: (context) {
                return DeleteConfirmationDialog(
                  deleteListener: () => controller.deleteSelectedVideo(),
                  cancelListener: () {
                    controller.clearSelection();
                    Get.back();
                  },
                );
              },
            );
          } else if (value == 3) {
            controller.clearSelection();
            controller.videoEditEnabled.value = false;
          }
        }
      },
    );
  }
}
