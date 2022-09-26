import 'dart:async';

import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/models/user/user.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:get/get.dart';

class SearchCoachesController extends BaseController {
  List<User> workoutForList = [];

  var title = ''.obs;
  var genderType = '';

  //Search text debounce
  Timer? _debounce;

  var searchText = '';
  var forGender = '';
  var workoutProgramTypeIds = [];
  var countryId = -1;
  int limit = 100;
  int offset = 0;

  onSearchChanged(String text) {
    if (_debounce != null) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 2000), () {
      if (text != searchText && text.isNotEmpty) {
        searchText = text;
        setAPICall();
      }
    });
  }

  String getEndPointName() {
    String apiName = 'api/user/get_coaches_on_dashboard';
    if (Utils.isUser()) {
      apiName = 'api/user/available_coaches';
    } else if (Utils.isCoach()) {
      apiName = 'api/user/get_coaches_on_dashboard';
    }
    return apiName;
  }

  void setGenderType(String title) {
    switch (title) {
      case 'Men':
        forGender = 'Male';
        break;
      case 'Women':
        forGender = 'Female';
        break;
      case 'Both':
        forGender = 'Both';
        break;
    }
    genderType = forGender;
  }

  void resetReqParams() {
    //genderType = '';
    //forGender = '';
    workoutProgramTypeIds = [];
    countryId = (-1);
  }

  void setAPICall() {
    var query = <String, dynamic>{};

    //01
    //mandatory param gender type
    query['for_gender'] = forGender;

    //same value has two different keys for the same tyoe of request
    query['gender'] = forGender;

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
    //if (!searchText.isEmpty) {
    query['text'] = searchText;
    //}

    getCoaches(query);
  }

  void fetchFilterCoaches(String gender, List<int> wpList, int countryID) {
    //01
    //mandatory param gender type
    if (gender.isNotEmpty) {
      forGender = gender;
    }

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

    //getCoaches(body);
    searchText = '';
    setAPICall();
  }

  void getCoaches(Map<String, dynamic> map) async {
    Future.delayed(1.milliseconds, () async {
      final data =
          await getReq(getEndPointName(), (c) => User.fromJson(c), query: map);

      if (!data.error) {
        workoutForList = [...?data.data];
        update(['user_search_coaches']);
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _debounce?.cancel();
    super.dispose();
  }
}
