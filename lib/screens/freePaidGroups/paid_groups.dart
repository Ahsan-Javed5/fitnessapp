part of 'package:fitnessapp/screens/freePaidGroups/free_and_paid_groups.dart';

class PaidGroups extends StatelessWidget {
  const PaidGroups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.find<FreeAndPaidGroupController>();
    c.initialPageIndex = 1;
    return Obx(
      () => c.paidGroups.isEmpty
          ? const EmptyView()
          : GetBuilder<FreeAndPaidGroupController>(
              id: 'main_group_selection',
              builder: (controller) {
                return ReorderableListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.tempPaidGroups.length,
                  itemBuilder: (context, index) {
                    final item = controller.tempPaidGroups[index];
                    return GroupListItem(
                      key: ValueKey(index),
                      index: index,
                      translatedTitle: item.title ?? 'main_group'.tr,
                      description: item.description ??
                          'No description is provided for this group',
                      tag1Text:
                          MyHive.getUser()?.userWorkoutProgramTypesToString(),
                      tag2Text: item.formattedUpOrCreatedAtTime,
                      isSelected: controller.selectedGroups.contains(item),
                      imageUrl: item.groupThumbnail ?? '',
                      showNotifyButton: !(controller
                              .tempPaidGroups[index].notifySubscribers ??
                          true),
                      onNotifyPressed: () async {
                        var result = await controller.notifySubscriber(
                            item.id ?? 0, 'MAIN_GROUP', context, false);
                        if (result) {
                          controller.tempPaidGroups[index].notifySubscribers =
                              true;
                          controller.update(['main_group_selection']);
                        }
                      },
                      // onLongPress: () => controller.updateSelectedGroups(item),
                      onPressed: () {
                        if (controller.videoEditEnabled.value) {
                          controller.updateSelectedGroups(item);
                        } else {
                          controller.clearSelection();
                          controller.userSelectedMainGroup = item;
                          Get.toNamed(Routes.freePaidMainGroupScreen,
                              arguments: item);
                        }
                      },
                    );
                  },
                  onReorder: (int oldIndex, int newIndex) {
                    if (controller.tempPaidGroups.length !=
                        controller.paidGroups.length) {
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
                          controller.tempPaidGroups.removeAt(oldIndex);
                      controller.tempPaidGroups.insert(newIndex, items);
                      controller.isReorderVideo.value = true;
                    }
                  },
                );
              },
            ),
    );
  }
}
