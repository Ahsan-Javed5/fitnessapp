part of 'package:fitnessapp/screens/freePaidGroups/free_and_paid_groups.dart';

class FreeGroups extends StatelessWidget {
  const FreeGroups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.find<FreeAndPaidGroupController>();
    c.initialPageIndex = 0;
    return Obx(
      () => c.freeGroups.isEmpty
          ? const EmptyView()
          : GetBuilder<FreeAndPaidGroupController>(
              id: 'main_group_selection',
              builder: (controller) => ReorderableListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.tempFreeGroups.length,
                itemBuilder: (context, index) {
                  final item = controller.tempFreeGroups[index];
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
                    showNotifyButton: false,
                    onNotifyPressed: () {
                      controller.notifySubscriber(
                          item.id ?? 0, 'MAIN_GROUP', context, false);
                    },
                    // onLongPress: () => controller.updateSelectedGroups(item),
                    onPressed: () {
                      if (controller.videoEditEnabled.value) {
                        controller.updateSelectedGroups(item);
                      } else {
                        controller.clearSelection();
                        controller.userSelectedMainGroup = item;
                        controller.userSelectedSubGroup = null;
                        Get.toNamed(Routes.freePaidSubGroupScreen,
                            arguments: item);
                      }
                    },
                  );
                },
                onReorder: (int oldIndex, int newIndex) {
                  if (controller.tempFreeGroups.length !=
                      controller.freeGroups.length) {
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
                    final items = controller.tempFreeGroups.removeAt(oldIndex);
                    controller.tempFreeGroups.insert(newIndex, items);
                    controller.isReorderVideo.value = true;
                  }
                },
              ),
            ),
    );
  }
}
