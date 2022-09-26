import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitnessapp/config/app_state_observer.dart';
import 'package:fitnessapp/config/fcm_controller.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/subscription_type.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/models/main_group.dart';
import 'package:fitnessapp/models/user/user.dart';
import 'package:fitnessapp/models/user/user_credentials.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:messenger/config/Glob.dart';
import 'package:messenger/controllers/user_controller.dart';
import 'package:messenger/model/UserWrapper.dart';
import 'package:messenger/model/providers/ThreadUserLinksProvider.dart';
import 'package:provider/provider.dart';

class LoginController extends BaseController {
  final LocalAuthentication auth = LocalAuthentication();
  var isBiometricAvailable = false.obs;

  // for face id
  var userName = ''.obs;
  var password = ''.obs;

  login(Map map) async {
    final response = await postReq(
      'api/auth/signIn',
      map,
      (user) => User.fromJson(user),
      singleObjectData: true,
    );

    if (!response.error) {
      setLoading(true);
      User user = response.singleObjectData;
      MyHive.saveUser(user);
      MyHive.setAuthToken(user.token ?? '');
      MyHive.setUserType(Utils.userTypeKey(user.userType));

      ///saving username and password locally for next login with face id, encrypt password
      UserCredentials userCredentials = UserCredentials();
      userCredentials.userName = user.userName ?? '';
      userCredentials.password = map['password'];
      MyHive.setUserCredentials(userCredentials);

      await authenticateUserWithMessenger(user);

      if (user.userType == 'User') {
        if (user.isSubscribed ?? false) {
          MyHive.setSubscriptionType(SubscriptionType.subscribed);
        } else {
          MyHive.setSubscriptionType(SubscriptionType.unSubscribed);
        }
      }
      setLoading(false);

      final p =
          Provider.of<ThreadUserLinksProvider>(Get.context!, listen: false);
      Future.delayed(const Duration(milliseconds: 10)).then((_) {
        p.initProvider(user.firebaseKey!);
      });

      /// If user type is coach and if his bank details are empty then
      /// take the user to the bank details screen instead of the home screen
      if (user.userType == 'Coach' &&
          (user.bankDetails == null ||
              user.bankDetails!.subscriptionPrice == null)) {
        Routes.offAllTo(Routes.profileSetupScreen);
      } else {
        Routes.offAllTo(Routes.home);
        FCMController().updateFCM(MyHive.getFcm());
      }
      setLoading(false);
    } else {
      //setLoading(false);
      Future.delayed(const Duration(milliseconds: 500), () {
        Utils.showSnack('Error', response.message, isError: true);
      });
    }
  }

  sendForgotPasswordRequest(Map body) async {
    log(message: body.toString());
    final result = await postReq(
      'api/user/send_reset_password_link',
      body,
      (json) => MainGroup.fromJson(json),
    );

    if (!result.error) {
      Utils.showSnack('alert'.tr, result.message);
    } else {
      setLoading(false);
      Utils.showSnack('Error', result.message, isError: true);
    }
  }

  sendForgotUserNameRequest(Map body) async {
    log(message: body.toString());
    final result = await postReq(
      'api/user/forgotUsername',
      body,
      (json) => MainGroup.fromJson(json),
    );
    if (!result.error) {
      Utils.showSnack('alert'.tr, 'email_has_been_sent'.tr);
    } else {
      setLoading(false);
      Utils.showSnack('Error', result.message, isError: true);
    }
  }

  authenticateUserWithMessenger(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final u = auth.currentUser;

    final result = await auth.signInWithCustomToken(user.firebaseJWT!);
    log(message: '@@@ result: ${result.user?.uid}');
    if (result.user?.uid != null) {
      updateUserInfoOnFirebase(user);
    } else {
      Utils.showSnack('error', 'Cannot authenticate with messenger',
          isError: true);
    }
  }

  updateUserInfoOnFirebase(User user) async {
    final userWrapper = UserWrapper.toServerObject(
      name: user.getFullName(),
      phone: user.phoneNumber,
      userType: user.userType,
      pictureURL: user.imageUrl,
      email: user.email,
      availability: Utils.getUserAvailabilityStatus(user),
    );
    userWrapper.entityId = user.firebaseKey!;
    userWrapper.fcm = MyHive.getFcm();
    Glob().currentUserKey = user.firebaseKey;
    await UserController.authenticateUser(userWrapper);
    await UserController.setUserOnline(MyHive.getUser()?.firebaseKey ?? '');
    Get.find<AppStateObserver>().listenForUserDataChanges();
  }

  navigateToHome(UserType type) {
    MyHive.setUserType(type);
    switch (type) {
      case UserType.guest:
        MyHive.setUserType(UserType.guest);
        MyHive.setAuthToken(MyHive.guestToken);
        Get.toNamed(Routes.home);
        break;
      case UserType.coach:
        // TODO: Handle this case.
        break;
      case UserType.user:
        // TODO: Handle this case.
        break;
      case UserType.noUser:
        // TODO: Handle this case.
        break;
    }
  }

  updateFCM() async {
    FirebaseMessaging.instance.getToken().then((token) async {
      await postReq('api/user/update/fcm', {'fcm_token': token},
          (p0) => MainGroup.fromJson(p0));
    });
  }

  getAvailableBiometrics() async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    if (canCheckBiometrics) {
      List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();
      if (availableBiometrics.contains(BiometricType.face)) {}
    } else {}

    try {
      await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        biometricOnly: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
      } else if (e.code == auth_error.notEnrolled) {}
    }
  }

  Future<bool?> authenticateWithBiometrics() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        biometricOnly: true,
        stickyAuth: true,
      );
      return authenticated;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        Utils.showSnack('alert'.tr, 'No biometric hardware available');
      } else if (e.code == auth_error.notEnrolled) {
        Utils.showSnack(
            'alert'.tr, 'No biometric is registered. Please register first!');
      } else {
        Utils.showSnack(
            'alert'.tr, 'Something went wrong! Please try again later.');
      }
      return null;
    }
  }

  ///this method will check device is capable of biometric and user logged in once.
  void checkBiometricsAvailableAndWasLoggedIn() async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    if (canCheckBiometrics && MyHive.getUserCredentials() != null) {
      isBiometricAvailable.value = true;
    }
  }
}
