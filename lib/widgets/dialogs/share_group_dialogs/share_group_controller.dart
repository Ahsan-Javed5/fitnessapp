import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/models/main_group.dart';
import 'package:fitnessapp/models/sub_group.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:get/get.dart';

class ShareGroupController extends BaseController {
  String selectedVideosIds = '';

  final allFreeGroups = <MainGroup>[].obs;
  final allPaidGroups = <MainGroup>[].obs;
  final subGroupsOfAGroup = <SubGroup>[].obs;

  MainGroup? selectedGroup;
  SubGroup? selectedSubGroup;
  final String fetchSubgroupsEP = 'api/coach_group/sub_groups';

  RxBool isShare = true.obs;
  RxInt navPaneLength = 1.obs;

  fetchFreeAndPaidGroups() async {
    Future.delayed(1.milliseconds, () async {
      final paidGroupResponse = await getReq(
          'api/coach_group/main_groups?group_plain=Paid&limit=200',
          (json) => MainGroup.fromJson(json));
      if (!paidGroupResponse.error) {
        allPaidGroups.clear();
        allPaidGroups.addAll([...?paidGroupResponse.data]);
      }
    });

    Future.delayed(1.milliseconds, () async {
      final freeGroupResponse = await getReq(
          'api/coach_group/main_groups?group_plain=Free&limit=200',
          (json) => MainGroup.fromJson(json));
      if (!freeGroupResponse.error) {
        allFreeGroups.clear();
        allFreeGroups.addAll([...?freeGroupResponse.data]);
      }
    });
  }

  fetchSubGroups() async {
    subGroupsOfAGroup.clear();
    Future.delayed(1.milliseconds, () async {
      final result = await getReq(
        fetchSubgroupsEP,
        (p0) => SubGroup.fromJson(p0),
        query: {'main_group_id': selectedGroup?.id.toString()},
      );

      if (!result.error) {
        subGroupsOfAGroup.addAll([...?result.data]);
        update([fetchSubgroupsEP]);
      }
    });
  }

  moveVideosToTheSubGroup() async {
    final result = await postReq(
        'api/coach_group/add_videos',
        {
          'id': selectedSubGroup?.id.toString(),
          'videos_ids': selectedVideosIds
        },
        (json) => null);

    if (!result.error) {
      Get.back();
      Utils.showSnack('success'.tr, 'Videos moved successfully');
    }
  }
}
