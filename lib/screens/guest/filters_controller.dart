import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/models/country.dart';
import 'package:fitnessapp/models/gender.dart';
import 'package:fitnessapp/models/workout_program_type.dart';
import 'package:get/get.dart';

class FiltersController extends BaseController {
  final countriesList = <Country>[].obs;
  var countryObj = Country().obs;

  //bool isResetFilter = false;

  final workoutTypesList = <WorkoutProgramType>[].obs;

  List<Gender> genderList = <Gender>[].obs;

  void setGender() {
    genderList.clear();
    genderList.add(Gender('male', false, 'Male'));
    genderList.add(Gender('female', false, 'Female'));
  }

  String getGender() {
    String gender = '';
    for (int i = 0; i < genderList.length; i++) {
      if (genderList[i].isChecked) {
        gender = genderList[i].name;
      }
    }
    return gender;
  }

  List<int> getWT() {
    List<int> list = [];
    for (int i = 0; i < workoutTypesList.length; i++) {
      var wpType = workoutTypesList[i];
      if (wpType.isSelected) {
        list.add(wpType.id!);
      }
    }
    return list;
  }

  bool isRest() {
    bool reset = false;
    if (getWT().isNotEmpty) {
      reset = true;
    }
    if (getGender().isNotEmpty) {
      reset = true;
    }
    return reset;
  }

  void resetData() {
    countryObj.value = Country();
    setGender();
    if (workoutTypesList.isNotEmpty) {
      for (int i = 0; i < workoutTypesList.length; i++) {
        var wpType = workoutTypesList[i];
        if (wpType.isSelected) {
          wpType.isSelected = false;
          workoutTypesList[i] = wpType;
        }
      }
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    setGender();

    //isResetFilter = false;
    //setWPTypeData();

    getAllCountries();
    getWorkoutTypes();
    super.onInit();
  }

  void getAllCountries() async {
    await Future.delayed(1.milliseconds, () async {
      final result = await getReq(
          getCountriesEndPoint, (json) => Country.fromJson(json),
          showLoadingDialog: false);
      if (result.data != null) {
        List<Country> list = result.data!.cast<Country>();
        countriesList.addAll(list);
      }
    });
  }

  void getWorkoutTypes() async {
    await Future.delayed(1.milliseconds, () async {
      final result = await getReq(
          getWorkoutTypesEndPoint, (json) => WorkoutProgramType.fromJson(json),
          showLoadingDialog: false);
      if (result.data != null) {
        List<WorkoutProgramType> list = result.data!.cast<WorkoutProgramType>();
        workoutTypesList.addAll(list);
      }
    });
  }
}
