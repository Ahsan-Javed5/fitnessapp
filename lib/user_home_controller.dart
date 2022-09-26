import 'package:fitnessapp/models/user/user.dart';
import 'package:get/get.dart';

class UserHomeScreenController extends GetxController {
  List<String> activeSubsList = <String>[].obs;

  List<User> availableCoachesList = <User>[].obs;
}
