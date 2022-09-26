import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/data.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/screens/coachProfile/group_list_item.dart';
import 'package:fitnessapp/screens/freePaidGroups/free_and_paid_groups_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:fitnessapp/widgets/empty_view.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

part 'free_groups.dart';
part 'paid_groups.dart';

class FreeAndPaidGroupsScreen extends StatelessWidget {
  FreeAndPaidGroupsScreen({Key? key}) : super(key: key);
  final controller = Get.put(FreeAndPaidGroupController());

  @override
  Widget build(BuildContext context) {
    controller.fetchFreeAndPaidGroups();
    controller.isReorderVideo.value = false;
    controller.videoEditEnabled.value = false;
    controller.initialPageIndex =
        Get.arguments == null ? 0 : Get.arguments['pageIndex'];

    return CustomScreen(
      titleTopMargin: 1,
      titleBottomMargin: 2,
      hasRightButton: true,
      hasSearchBar: controller.selectedGroups.isEmpty,
      onSearchbarClearText: () => controller.searchInGroups(''),
      onSearchBarTextChange: (s) => controller.searchInGroups(s.toLowerCase()),
      rightButton: const HomeButton(),
      backHandler: () {
        controller.selectedGroups.clear();
        Get.back();
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var results = await Get.toNamed(Routes.addGroupPage);
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
      ),
      child: Column(
        children: [
          /// top bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'groups'.tr,
                style: TextStyles.mainScreenHeading,
              ),
              Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(microseconds: 300),
                  child: controller.videoEditEnabled.value
                      ? GestureDetector(
                          key: UniqueKey(),
                          onTapDown: (details) {
                            _showPopupMenu(details.globalPosition, context);
                          },
                          child: const Icon(
                            Icons.more_vert,
                            color: ColorConstants.appBlack,
                          ),
                        )
                      : controller.isReorderVideo.value &&
                              !controller.videoEditEnabled.value
                          ? TextButton(
                              onPressed: () {
                                ///if the current selected
                                ///index = 0 => tempFreeGroups
                                ///index = 1 => tempPaidGroups
                                if (controller.initialPageIndex == 0) {
                                  controller.saveMainGroupOrder(
                                      controller.tempFreeGroups);
                                } else {
                                  controller.saveMainGroupOrder(
                                      controller.tempPaidGroups);
                                }
                              },
                              child: Text('save'.tr),
                            )
                          : GestureDetector(
                              key: UniqueKey(),
                              onTapDown: (details) {
                                controller.videoEditEnabled.value = true;
                              },
                              child: SvgPicture.asset(
                                'assets/svgs/ic_edit.svg',
                              ),
                            ),
                ),
              ),
            ],
          ),

          /// Tabs and Tab children
          Expanded(
            child: DefaultTabController(
              length: 2,
              initialIndex: controller.initialPageIndex,
              child: Column(
                children: [
                  TabBar(
                    indicatorWeight: 2,
                    tabs: [
                      Tab(
                        text: 'free'.tr,
                      ),
                      Tab(
                        text: 'paid'.tr,
                      ),
                    ],
                  ),
                  Spaces.y4,
                  const Expanded(
                    child: TabBarView(
                      children: [
                        FreeGroups(),
                        PaidGroups(),
                      ],
                    ),
                  ),
                ],
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
    int length = controller.selectedGroups.length;
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
            Get.toNamed(
              Routes.editMainGroupScreen,
              arguments: controller.selectedGroups[0],
            );
          } else if (value == 2) {
            showDialog(
              context: context,
              useRootNavigator: true,
              useSafeArea: false,
              builder: (context) {
                return DeleteConfirmationDialog(
                  deleteListener: () => controller.deleteSelectedMainGroups(),
                  cancelListener: buttonHandler,
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

  buttonHandler() {
    controller.clearSelection();
    Get.back();
  }
}
