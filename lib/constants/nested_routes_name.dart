import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/user_type.dart';

class NestedRoutesName {
  static const String userHomePage = '/UserHomePage';
  static const String coachHomePage = '/CoachHomePage';
  static const String guestHome = '/guestHome';
  static const String loginScreen = '/loginScreen';
  static const String signUpUser = '/signUpUser';
  static const String signUpCoach = '/signUpCoach';

  static getInitialRoute() {
    return initRoutName();
  }

  static String initRoutName() {
    UserType type = MyHive.getUserType();
    String name = guestHome;
    switch (type) {
      case UserType.guest:
        name = guestHome;
        break;
      case UserType.user:
        name = userHomePage;
        break;
      case UserType.coach:
        name = coachHomePage;
        break;

      case UserType.noUser:
        break;
    }
    return name;
  }
}
