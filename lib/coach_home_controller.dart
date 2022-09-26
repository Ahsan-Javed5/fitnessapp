/*
import 'dart:async';
import 'dart:core';

import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/models/base_response.dart';
import 'package:fitnessapp/models/coach_collection.dart';
import 'package:fitnessapp/models/coach_stats.dart';
import 'package:fitnessapp/models/user/user.dart';
import 'package:fitnessapp/models/workout_for.dart';
import 'package:get/get.dart';

class CoachHomeScreenController extends BaseController {
  /// Stats for coach on home screen
  bool isStatApiLoading = false;
  CoachStats? coachStats;
  BaseResponse? coachStatsResponse;
  final String getCoachStatsEndPoint =
      'api/user/get_coaches_dashboard_statistics';

  /// Coaches for home screen
  bool isCoachApiLoading = false;
  BaseResponse? coachesResponse;
  final String getCoachesOnHomeEndPoint = 'api/user/get_coaches_on_dashboard';

  List<CoachCollection> coachStatItems = <CoachCollection>[].obs;
  List<WorkoutFor> availableCoachesList = <WorkoutFor>[].obs;


  /// Screens which have tabs will receive the whole stat object
  /// so that we can populate all of the pages other screens will only receive
  /// relevant data object
  void setCoachCollectionList() {
    coachStatItems.add(
      CoachCollection(
        'active_subscriptions',
        'assets/svgs/ic_active_subs.svg',
        coachStats?.activeSubscribers?.length ?? 0,
        Routes.subscription,
        0,
        coachStats,
      ),
    );
    coachStatItems.add(
      CoachCollection(
        'expired_subscriptions',
        'assets/svgs/ic_active_subs.svg',
        coachStats?.expiredSubscribers?.length ?? 0,
        Routes.subscription,
        1,
        coachStats,
      ),
    );
    coachStatItems.add(
      CoachCollection(
        'my_video_library',
        'assets/svgs/ic_vid_library.svg',
        coachStats?.videoLibrary?.length ?? 0,
        Routes.privateVideoLibrary,
        0,
        coachStats?.videoLibrary,
      ),
    );
    coachStatItems.add(
      CoachCollection(
        'free_group',
        'assets/svgs/ic_free_group.svg',
        coachStats?.freeGroups?.length ?? 0,
        Routes.freeAndPaidGroupsScreen,
        0,
        coachStats,
      ),
    );
    coachStatItems.add(
      CoachCollection(
        'paid_group',
        'assets/svgs/ic_paid_group.svg',
        coachStats?.paidGroups?.length ?? 0,
        Routes.freeAndPaidGroupsScreen,
        1,
        coachStats,
      ),
    );
    coachStatItems.add(
      CoachCollection(
        'monthly_statements',
        'assets/svgs/ic_monthly_statement.svg',
        coachStats?.monthlyStatements?.length ?? 0,
        Routes.monthlyStatementsScreen,
        0,
        coachStats?.monthlyStatements,
      ),
    );
  }

  Future<void> getCoachStats() async {
    isStatApiLoading = true;

    await Future.delayed(1.milliseconds, () async {
      update([getCoachStatsEndPoint]);

      final res = await getReq(
        getCoachStatsEndPoint,
        (json) => CoachStats.fromJson(json),
        showLoadingDialog: false,
        singleObjectData: true,
      );
      coachStatsResponse = res;
      coachStats = res.singleObjectData;
    });

    coachStatItems.clear();
    setCoachCollectionList();
    isStatApiLoading = false;
    update([getCoachStatsEndPoint]);
  }

  Future<void> getCoachesForHome() async {
    isCoachApiLoading = true;
    update([getCoachesOnHomeEndPoint]);

    await Future.delayed(1.milliseconds, () async {
      final res = await getReq(
          getCoachesOnHomeEndPoint, (json) => User.fromJson(json),
          showLoadingDialog: false);
      coachesResponse = res;
    });

    isCoachApiLoading = false;
    update([getCoachesOnHomeEndPoint]);
  }

  Future<void> getDashboardData() async {
    await getCoachStats();
    await getCoachesForHome();
  }
}
*/
