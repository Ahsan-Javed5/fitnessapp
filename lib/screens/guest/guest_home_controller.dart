import 'package:fitnessapp/models/workout.dart';
import 'package:get/get.dart';

class GuestHomeController extends GetxController {



  List<Workout> workoutList = <Workout>[].obs;


  void addWorkoutData() {
    workoutList.add(Workout('workout_for_men', 'assets/images/bm.png', 'Men'));
    workoutList.add(Workout('workout_for_women', 'assets/images/bw.png', 'Women'));
    workoutList.add(Workout('workout_for_both', 'assets/images/bb.png', 'Both'));
  }

  @override
  void onInit() {
    super.onInit();
    addWorkoutData();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    //_debounce?.cancel();
    super.dispose();
  }
}
