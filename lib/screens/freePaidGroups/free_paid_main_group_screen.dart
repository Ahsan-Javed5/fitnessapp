import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/models/main_group.dart';
import 'package:fitnessapp/screens/coachProfile/group_list_item.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:fitnessapp/widgets/empty_view.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:fitnessapp/widgets/loading_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'free_and_paid_groups_controller.dart';

class FreePaidMainGroupScreen extends StatelessWidget {
  FreePaidMainGroupScreen({Key? key}) : super(key: key);
  final FreeAndPaidGroupController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final mainGroup = Get.arguments as MainGroup?;
    controller.fetchSubGroups(mainGroup?.id.toString() ?? '-1');

    return CustomScreen(
      titleTopMargin: 3,
      screenTitleTranslated: mainGroup?.title ?? 'main_group'.tr,
      titleBottomMargin: 1,
      hasRightButton: true,
      hasSearchBar: controller.selectedGroups.isEmpty,
      onSearchbarClearText: () => controller.searchInSubGroups(''),
      onSearchBarTextChange: (s) =>
          controller.searchInSubGroups(s.toLowerCase()),
      rightButton: const HomeButton(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.addGroupPage,
            arguments: {'groupType': 1, 'data': mainGroup?.id}),
        child: SvgPicture.asset('assets/svgs/ic_add_large.svg'),
        mini: false,
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spaces.y1_0,
          Text(
            mainGroup?.description ?? '',
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
                mainGroup?.formattedUpOrCreatedAtTime ?? '',
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
                          controller
                              .savePaidSubGroupOrder(controller.tempSubgroups);
                        },
                        child: Text('save'.tr))
                    : const SizedBox();
              }),
            ],
          ),

          Spaces.y3,
          Expanded(
            child: GetBuilder<FreeAndPaidGroupController>(
              id: controller.fetchSubgroupsEP,
              builder: (controller) => LoadingErrorWidget(
                isLoading: controller.apiLoading,
                errorMessage: controller.latestResponse.message,
                isError: controller.latestResponse.error,
                refreshCallback: () =>
                    controller.fetchSubGroups(mainGroup?.id.toString() ?? '-1'),
                child: (controller.subgroups.isEmpty && !controller.apiLoading)
                    ? const EmptyView()
                    : GetBuilder<FreeAndPaidGroupController>(
                        id: 'sub_group_selection',
                        builder: (c) {
                          return ReorderableListView.builder(
                            onReorder: (int oldIndex, int newIndex) {
                              if (controller.tempSubgroups.length !=
                                  controller.subgroups.length) {
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
                                    controller.tempSubgroups.removeAt(oldIndex);
                                controller.tempSubgroups
                                    .insert(newIndex, items);
                                controller.isReorderVideo.value = true;
                              }
                            },
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.tempSubgroups.length,
                            itemBuilder: (context, index) {
                              final item = controller.tempSubgroups[index];
                              return GroupListItem(
                                index: index,
                                key: ValueKey(index),
                                translatedTitle: item.title,
                                tag1Text: item.formattedTime,
                                imageUrl: item.groupThumbnail ?? '',
                                description: item.description,
                                showNotifyButton: !(controller
                                        .tempSubgroups[index]
                                        .notifySubscribers ??
                                    true),
                                onNotifyPressed: () async {
                                  var res = await controller.notifySubscriber(
                                      item.id ?? 0,
                                      'SUB_GROUP',
                                      context,
                                      false);
                                  if (res) {
                                    controller.tempSubgroups[index]
                                        .notifySubscribers = true;
                                    controller.update(['sub_group_selection']);
                                  }
                                },
                                isSelected:
                                    controller.selectedSubGroups.contains(item),
                                // onLongPress: () => {
                                //   controller.updateSelectedSubGroups(item),
                                // },
                                onPressed: () {
                                  if (controller.videoEditEnabled.value) {
                                    controller.updateSelectedSubGroups(item);
                                  } else {
                                    controller.userSelectedSubGroup = item;
                                    controller.clearSelection();
                                    Get.toNamed(Routes.freePaidSubGroupScreen);
                                  }
                                },
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
    );
  }

  void _showPopupMenu(Offset offset, BuildContext context) async {
    final isRtl = Get.locale?.languageCode == 'ar';
    double left = !isRtl ? offset.dx : 0;
    double top = offset.dy;
    double right = isRtl ? offset.dx : 0;
    int length = controller.selectedSubGroups.length;
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
            Get.toNamed(Routes.editSubGroupPage,
                arguments: controller.selectedSubGroups[0]);
          } else if (value == 2) {
            showDialog(
              context: context,
              useRootNavigator: true,
              useSafeArea: false,
              builder: (context) {
                return DeleteConfirmationDialog(
                  deleteListener: () => controller.deleteSelectedSubGroups(),
                  cancelListener: deleteDialogButtonHandler,
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

  deleteDialogButtonHandler() {
    controller.clearSelection();
    Get.back();
  }
}
