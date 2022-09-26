import 'dart:async';
import 'dart:developer';

import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:get/get.dart';
import 'package:messenger/controllers/user_controller.dart';
import 'package:messenger/model/Availability.dart';

class AppStateObserver extends SuperController {
  StreamSubscription? _event;

  /// This will be true or false based upon if user/coach is disabled or disapproved
  /// by admin from admin panel
  final isChatEnabled = true.obs;

  /// This will be true or false based upon if coach itself has disabled/enabled chat
  final coachPrivateChatsEnabled = true.obs;

  @override
  void onDetached() {
    showLog('onDetached');
  }

  @override
  void onInactive() {
    showLog('onInactive');
  }

  @override
  void onPaused() {
    showLog('onPaused');
    UserController.setUserOffline(MyHive.getUser()?.firebaseKey ?? '');
  }

  @override
  void onResumed() {
    showLog('onResumed');
    UserController.setUserOnline(MyHive.getUser()?.firebaseKey ?? '');
    listenForUserDataChanges();
  }

  @override
  void onInit() {
    super.onInit();
    listenForUserDataChanges();
  }

  void showLog(String message) {
    log(message);
  }

  /// This will listen for any changes in the user object on the firebase realtime database
  /// I am listening this because we have a requirement which is as soon as user is disabled from
  /// admin panel we need to disable the chats of the user
  listenForUserDataChanges() async {
    if (MyHive.getUser() != null) {
      _event ??= UserController.getUserIfPresentLive(
          MyHive.getUser()?.firebaseKey ?? '', (user) {
        if (user.meta != null) {
          final meta = user.meta;
          isChatEnabled.value =
              (meta?.availability ?? '') == Availability.Available ||
                  (meta?.availability ?? '') == Availability.Away;

          coachPrivateChatsEnabled.value =
              (meta?.availability ?? '') != Availability.Away;

          /// To save this data in hive uncomment the below
          /// code snippet
          // final newMeta = UserFirebaseMeta(
          //   availability: meta?.availability,
          //   email: meta?.email,
          //   fcm: meta?.fcm,
          //   name: meta?.name,
          //   nameLowercase: meta?.nameLowerCase,
          //   phone: meta?.phone,
          //   pictureUrl: meta?.pictureURL,
          //   userType: meta?.userType,
          // );
          //MyHive.saveFirebaseMeta(newMeta);
        }
      });
    }
  }

  unsubscribeUserListener() async {
    await _event?.cancel();
    _event = null;
  }
}
