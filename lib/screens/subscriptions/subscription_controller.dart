import 'dart:async';

import 'package:fitnessapp/constants/getx_controller_tag.dart';
import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/models/subscription.dart';
import 'package:fitnessapp/screens/guest/main_workout_controller.dart';
import 'package:fitnessapp/screens/subscriptions/subscription_response.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:get/get.dart';

class SubscriptionController extends BaseController {
  List<Subscription> activeSubsList = [];
  List<Subscription> inActiveSubsList = [];
  List<Subscription> subsHistoryList = [];
  int availSub = -1;

  final tempActiveSubs = <Subscription>[];
  final tempInActiveSubs = <Subscription>[];

  String getActiveSubs = (MyHive.getUserType() == UserType.coach)
      ? 'api/user/coach_subscriptions'
      : 'api/user/active_subscribtions';

  //Get Active Subscriptions
  void getSubscriptions() async {
    tempInActiveSubs.clear();
    tempActiveSubs.clear();
    update([getActiveSubs]);
    Future.delayed(1.milliseconds, () async {
      final data = await getReq(getActiveSubs, (c) => Subscription.fromJson(c),
          showLoadingDialog: false);

      if (!data.error) {
        subsHistoryList = [...?data.data];
        if (subsHistoryList.isNotEmpty) {
          activeSubsList.clear();
          inActiveSubsList.clear();
          for (int i = 0; i < subsHistoryList.length; i++) {
            if (subsHistoryList[i].status == 'Active') {
              //availSub = 1;
              activeSubsList.add(subsHistoryList[i]);
            } else {
              //availSub = 1;
              inActiveSubsList.add(subsHistoryList[i]);
            }
          }
          tempActiveSubs.clear();
          tempInActiveSubs.clear();

          tempActiveSubs.addAll(activeSubsList);
          if (tempActiveSubs.length > 0) {
            availSub = 1;
          } else {
            availSub = -1;
          }
          tempInActiveSubs.addAll(inActiveSubsList);
          update([getActiveSubs]);
        } else {
          availSub = -1;
          update([getActiveSubs]);
        }
        update([getActiveSubs]);
      } else {
        availSub = -1;
        update([getActiveSubs]);
      }
    });
  }

  void addSubs(Map body) async {
    final _result = await postReq(
      'api/subscriber/addSubscriber',
      body,
      (subs) => SubscriptionResp.fromJson(subs),
      singleObjectData: true,
    );

    if (!_result.error) {
      MainWorkOutController controller =
          Get.find(tag: GetXControllerTag.coachesListToggle);
      getSubscriptions();
      controller.refreshCoachList();
      Utils.backUntil();
    } else {
      Utils.showSnack('Error', _result.message, isError: true);
    }

    setLoading(false);
  }

  void searchSubscriptions(String query) {
    searchActiveSubs(query);
    searchInActiveSubs(query);
    update([getActiveSubs]);
  }

  void searchActiveSubs(String query) {
    tempActiveSubs.clear();
    if (query.isEmpty) {
      tempActiveSubs.addAll(activeSubsList);
      return;
    }
    for (Subscription g in activeSubsList) {
      if ((g.user?.userName ?? '').toLowerCase().contains(query)) {
        tempActiveSubs.add(g);
      }
    }
  }

  void searchInActiveSubs(String query) {
    tempInActiveSubs.clear();
    if (query.isEmpty) {
      tempInActiveSubs.addAll(inActiveSubsList);
      return;
    }
    for (Subscription g in inActiveSubsList) {
      if ((g.user?.userName ?? '').toLowerCase().contains(query)) {
        tempInActiveSubs.add(g);
      }
    }
  }

  @override
  void onInit() {
    getSubscriptions();
    super.onInit();
  }
}
