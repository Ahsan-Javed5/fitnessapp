import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/models/main_group.dart';
import 'package:fitnessapp/models/sub_group.dart';
import 'package:get/get_utils/src/extensions/num_extensions.dart';

class GroupController extends BaseController {
  var mainGroups = <MainGroup>[];
  var subGroups = <SubGroup>[];

  var coachId;

  var mainPlainType;
  var mainDataType;
  int mainLimit = 10;
  int mainOffset = 0;
  var mainQuery = <String, dynamic>{};

  var subPlainType;
  var subDataType;
  int subLimit = 10;
  int subOffset = 0;
  var subQuery = <String, dynamic>{};

  setMainGroupParam(String plainType, String dataType, int? coachId) {
    this.coachId = coachId;
    mainPlainType = plainType;
    mainDataType = dataType;
    mainQuery['group_plain'] = mainPlainType;
    mainQuery['text'] = mainDataType;
    mainQuery['limit'] = mainLimit.toString();
    mainQuery['offset'] = mainOffset.toString();
    mainQuery['coach_id'] = coachId.toString();
    Future.delayed(1.milliseconds, () => getMainGroups(mainQuery));
  }

  setSubGroupParam(String plainType, String dataType, int groupID) {
    subPlainType = plainType;
    subDataType = dataType;
    subQuery['group_plain'] = subPlainType;
    subQuery['text'] = subDataType;
    subQuery['limit'] = subLimit.toString();
    subQuery['offset'] = subOffset.toString();
    subQuery['main_group_id'] = groupID.toString();
    Future.delayed(1.milliseconds, () => getSubGroups(subQuery));
  }

  getMainGroups(Map<String, dynamic> mainQuery) async {
    final response = await getReq(
        'api/coach_group/main_groups', (json) => MainGroup.fromJson(json),
        singleObjectData: false, showLoadingDialog: true, query: mainQuery);

    if (!response.error && response.data != null && response.data!.length > 0) {
      //mainGroups.addAll(response.data ?? []);

      //type caste the origin list into our
      List<MainGroup> list = response.data!.cast<MainGroup>();
      mainGroups.addAll(list);
      update(["api/coach_group/main_groups"]);
    }
  }

  getSubGroups(Map<String, dynamic> mainQuery) async {
    final response = await getReq(
        'api/coach_group/sub_groups', (json) => SubGroup.fromJson(json),
        singleObjectData: false, showLoadingDialog: true, query: mainQuery);

    if (!response.error && response.data != null && response.data!.length > 0) {
      //subGroups.addAll(response.data ?? []);

      List<SubGroup> list = response.data!.cast<SubGroup>();
      subGroups.addAll(list);
      update(["api/coach_group/sub_groups"]);
    }
  }
}
