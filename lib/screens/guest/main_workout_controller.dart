import 'dart:async';

import 'package:fitnessapp/constants/data.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/base_response.dart';
import 'package:fitnessapp/models/coach_collection.dart';
import 'package:fitnessapp/models/coach_stats.dart';
import 'package:fitnessapp/models/user/user.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:get/get.dart';
import 'package:messenger/controllers/user_controller.dart';
import 'package:messenger/model/UserWrapper.dart';

class MainWorkOutController extends BaseController {
  /// Stats for coach on home screen
  bool isStatApiLoading = false;
  CoachStats? coachStats;
  BaseResponse? coachStatsResponse;
  final String getCoachStatsEndPoint =
      'api/user/get_coaches_dashboard_statistics';

  List<User> workoutForList = [];

  var title = ''.obs;
  var genderType = '';

  Timer? _debounce;

  var searchText = '';
  var forGender = '';
  var gender = '';
  var defaultGender = '';
  String userType = '';
  var workoutProgramTypeIds = [];
  var countryId = -1;
  int limit = 100;
  int offset = 0;

  bool isCoachApiLoading = false;
  bool isCoachListError = false;
  String coachListErrorMsg = '';

  bool isSubUsersAddedUser = false;

  var endPoint = getEndPoint();

  List<CoachCollection> coachStatItems = <CoachCollection>[].obs;

  void onSearchChanged(String text) {
    if (_debounce != null) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 2000), () {
      if ((text.isEmpty && searchText.isNotEmpty) ||
          (text != searchText && text.isNotEmpty && text.length > 2)) {
        searchText = text;
        if (searchText.isNotEmpty) {
          setAPICall();
        }
      }
    });
  }

  void getUserInfo() async {
    if (MyHive.getUser() != null) {
      final response = await getReq(
        ''
        'api/user/getUserById/${MyHive.getUser()!.id}',
        (p0) => User.fromJson(p0),
        singleObjectData: true,
        showLoadingDialog: false,
      );

      if (!response.error && response.singleObjectData != null) {
        User user = response.singleObjectData;
        MyHive.saveUser(user);
        authenticateUserWithMessenger(user);
      }
      setLoading(false);
    }
  }

  authenticateUserWithMessenger(User user) async {
    final userWrapper = UserWrapper.toServerObject(
      name: user.getFullName(),
      phone: user.phoneNumber,
      userType: user.userType,
      pictureURL: user.imageUrl,
      email: user.email,

      /// if user is archived or not verified then status should be disabled
      availability: Utils.getUserAvailabilityStatus(user),
    );
    userWrapper.entityId = user.firebaseKey!;
    userWrapper.fcm = MyHive.getFcm();
    await UserController.authenticateUser(userWrapper);
    await UserController.setUserOnline(MyHive.getUser()?.firebaseKey ?? '');
  }

  static String getEndPoint() {
    String apiName = 'api/user/get_preffered_workout';
    if (Utils.isUser()) {
      apiName = 'api/user/available_coaches';
    } else if (Utils.isCoach()) {
      apiName = 'api/user/get_coaches_on_dashboard';
    }
    return apiName;
  }

  Future<void> setAPICall({bool isSubUsersAdded = true}) async {
    var query = <String, dynamic>{};

    //01
    //mandatory param gender type
    // if (forGender.isNotEmpty) {
    //   query['for_gender'] = forGender;
    // }

    //same value has two different keys for the same tyoe of request
    // if (forGender.isEmpty) {
    //   if (genderType.isNotEmpty) {
    //     query['gender'] = genderType;
    //   }
    // }

    if (gender.isNotEmpty) {
      query['gender'] = gender;
    }

    //02
    if (countryId != -1) {
      query['country_id'] = countryId.toString();
    }
    //03
    if (workoutProgramTypeIds.isNotEmpty) {
      query['workout_program_type_ids'] = workoutProgramTypeIds.toString();
    }
    //05
    query['limit'] = limit.toString();

    //06
    query['offset'] = offset.toString();

    //07
    if (searchText.isNotEmpty) {
      query['text'] = searchText;
    }

    getCoaches(query, isSubUsersAdded);
  }

  void resetFilterParams() {
    //forGender = '';
    //gender = '';

    //For guest we have need to get the value from default in case of filter reset
    // if (Utils.isGuest() || Utils.isUser()) {
    //   forGender = defaultGender;
    // }
    workoutProgramTypeIds = [];
    countryId = (-1);
    //change
    setAPICall();
  }

  void fetchCoaches(String title) {
    //genderType = title;
    switch (title) {
      case 'Men':
        this.title.value = 'workout_for_men'.tr;
        gender = 'Male';
        break;
      case 'Women':
        this.title.value = 'workout_for_women'.tr;
        gender = 'Female';
        break;
      case 'Both':
        this.title.value = 'workout_for_both'.tr;
        gender = 'Both';
        break;
    }

    searchText = '';
    setAPICall();
  }

  void fetchUserCoaches(String gender) {
    if (_debounce != null) {
      _debounce?.cancel();
    }
    searchText = '';
    //change
    //genderType = title;
    if (gender.isNotEmpty) {
      gender = gender;
    }
    setAPICall(isSubUsersAdded: false);
  }

  void fetchFilterCoaches(String genderType, List<int> wpList, int countryID) {
    //01
    //mandatory param gender type

    // if (gender.isNotEmpty) {
    //   forGender = gender;
    // }

    // if (genderType.isNotEmpty) {
    //   gender = genderType;
    // }

    //02
    if (countryID != -1) {
      countryId = countryID;
    }

    if (wpList.isNotEmpty) {
      workoutProgramTypeIds.clear();
      workoutProgramTypeIds.addAll(wpList);
    }

    limit = 100;
    offset = 0;

    setAPICall();
  }

  Future<void> getCoaches(
      Map<String, dynamic> map, bool isSubUsersAdded) async {
    isCoachApiLoading = true;
    await Future.delayed(1.milliseconds, () async {
      final data = await getReq(endPoint, (c) => User.fromJson(c),
          query: map,
          showLoadingDialog: DataUtils.videoID.isNotEmpty ? false : true);

      if (!data.error) {
        workoutForList = [...?data.data];
        if (isSubUsersAddedUser) {
          workoutForList.removeWhere((element) => element.isSubscribed!);
        }

        ///this will remove all subscribed users from the list
      }
      isCoachListError = data.error;
      coachListErrorMsg = data.message;
      isCoachApiLoading = false;
      update(['workout_for']);
    });
    setLoading(false);
  }

  void refreshCoachList() {
    workoutForList.clear();
    update(['workout_for']);
    if (Utils.isUser()) {
      isSubUsersAddedUser = true;
      //User? user = MyHive.getUser();
      fetchUserCoaches('');
    } else if (Utils.isCoach()) {
      isSubUsersAddedUser = true;
      getCoachStats();
      setAPICall(isSubUsersAdded: true);
    } else if (Utils.isGuest()) {
      isSubUsersAddedUser = false;
      fetchCoaches(DataUtils.userType);
    }
    setLoading(false);
  }

  @override
  void onInit() {
    super.onInit();
    //getActiveSubscriptions();
    if (Utils.isUser()) {
      workoutForList.clear();
      isSubUsersAddedUser = true;
      getUserInfo();
      //User? user = MyHive.getUser();
      fetchUserCoaches('');
    } else if (Utils.isCoach()) {
      isSubUsersAddedUser = true;
      getCoachStats();
      setAPICall(isSubUsersAdded: true);
    } else if (Utils.isGuest()) {
      isSubUsersAddedUser = false;
      fetchCoaches(DataUtils.userType);
    }
    if (DataUtils.videoID.isNotEmpty) {
      //Move to the videoDetailScreen
      Future.delayed(const Duration(seconds: 2), () {
        Map<String, dynamic> arg = {};
        arg['videoID'] = DataUtils.videoID;
        Routes.to(Routes.videoDetailScreenDeepLinking, arguments: arg);
        DataUtils.videoID = ''; //empty video id after moving
      });
    }
  }

  Future<void> getCoachStats() async {
    isStatApiLoading = true;
    update([getCoachStatsEndPoint]);

    await Future.delayed(1.milliseconds, () async {
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
    setLoading(false);
    update([getCoachStatsEndPoint]);
  }

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
}
