import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:messenger/model/Availability.dart';
import 'package:messenger/model/Keys.dart';
import 'package:messenger/model/User.dart';
import 'package:messenger/model/UserWrapper.dart';

class UserController {
  static var userRef =
      FirebaseDatabase.instance.reference().child('_debug').child('users');

  ///This method will return the user object from the firebase
  ///If there is no user found with this [userEntityId] it will return null
  static Future<User?> getUserIfPresent(String userEntityId) async {
    final completer = Completer<User?>();
    userRef.child(userEntityId).once().then((value) {
      if (value.value == null) {
        completer.complete(null);
      } else {
        User mUser = User.rawMap(Map<String, dynamic>.from(value.value));
        completer.complete(mUser);
      }
    });

    return completer.future;
  }

  static StreamSubscription<Event> getUserIfPresentLive(
      String userEntityId, void onData(User user)) {
    StreamSubscription<Event> subscription =
        userRef.child(userEntityId).onValue.listen((event) {
      onData(
        User.rawMap(
          Map<String, dynamic>.from(event.snapshot.value),
        ),
      );
    });
    return subscription;
  }

  ///This will create the user on firebase
  ///Use [UserWrapper.toServerObject(name: name, phone: phone, userType: userType)]
  ///To provide details, which has the logic to convert that information into pushable map
  ///by pushable map i mean the data is stitched into the appropriate data structure
  ///return [true] in case of success and you guess it right it will return false on failure
  static Future<bool> createUser(UserWrapper user) async {
    Completer<bool> completer = Completer<bool>();

    userRef
        .child(user.entityId)
        .set(getPushableMap(user, setOnline: true))
        .then((value) {
      completer.complete(true);
    }).catchError((onError) {
      completer.complete(false);
    });

    return completer.future;
  }

  ///This method will update the details of the existing user object
  ///It will take 2 params [entityId] and [UserWrapper.fromUser(user)] object
  static Future<bool> updateUser(String entityId, UserWrapper user) async {
    Completer<bool> completer = Completer<bool>();
    userRef
        .child(entityId)
        .update(getPushableMap(user, includeThreadNode: false))
        .then((value) => completer.complete(true))
        .catchError((onError) {
      completer.complete(false);
    });
    return completer.future;
  }

  ///Set the [Online] value to true
  static Future<void> setUserOnline(String entityId) async {
    if (entityId.isEmpty) return;

    Completer<void> completer = Completer<void>();

    userRef
        .child(entityId + '/online')
        .set(true)
        .then((value) => completer.complete(true))
        .catchError((onError) {
      completer.complete(false);
    });

    return completer.future;
  }

  ///Its same as the above online function, it just remove the online key
  ///and update the last online value
  static Future<void> setUserOffline(String entityId,
      {bool removeFcm = false}) async {
    if (entityId.isEmpty) return;

    Completer<void> completer = Completer<void>();

    userRef.child(entityId + '/online').remove();
    userRef
        .child(entityId)
        .child(Keys.LastOnline)
        .set(ServerValue.timestamp)
        .then((value) => completer.complete());

    if (removeFcm) {
      userRef.child(entityId + '/meta/fcm').remove();
    }
    return completer.future;
  }

  static Map<String, dynamic> getPushableMap(UserWrapper user,
      {bool setOnline = false, bool includeThreadNode = true}) {
    Map<String, dynamic> metaValues = {
      Keys.Availability: user.availability ?? Availability.Available,
      Keys.Name: user.name,
      Keys.NameLowercase: user.lowerCaseName,
      Keys.Phone: user.phone,
      Keys.Email: user.email,
      Keys.AvatarURL: user.pictureURL,
      Keys.UserType: user.userType,
      'fcm': user.fcm,
    };

    Map<String?, Map<String, String?>> threadsMap = new Map();
    if (user.threads != null && user.threads!.length > 0) {
      user.threads!.forEach((element) {
        {
          threadsMap[element.key] = {
            Keys.InvitedBy: element.invitedBy,
          };
        }
      });
    }

    Map<String, dynamic> pushableMap = {
      Keys.LastOnline:
          user.lastOnline == null ? user.lastOnlineDouble : user.lastOnline,
      Keys.Meta: metaValues,

      /// if Threads map is empty, then firebase RTDB will not create node for it
      /// so if there is no node then we cannot observe it in case if user doesn't have any thread
      /// and he is in the app meanwhile some other user creates a thread with this user, then this user will not be able
      /// to see the new thread unless this user restarts his app. So to fix this on sign up i am creating a dummy thread
      /// so this way thread node will not be empty and then we can observe this node and then whenever someone will create thread
      /// we will be notified instantly
      ///
      ///
      /// Yea I know its a dirty fix but its what it is
      if (includeThreadNode)
        Keys.Threads: threadsMap.isEmpty
            ? {
                '${DateTime.now().microsecondsSinceEpoch.toString()}${user.name}':
                    {'invitedBy': 'none'}
              }
            : threadsMap,
      // Keys.Threads: threadsMap,
      if (setOnline) Keys.Online: setOnline,
    };

    return pushableMap;
  }

  static Future<void> authenticateUser(UserWrapper userWrapper) async {
    Completer<void> completer = Completer<void>();

    getUserIfPresent(userWrapper.entityId).then((value) async {
      //user is not present that means a new user is singing up
      if (value == null) {
        createUser(userWrapper).then((value) => completer.complete());
      } else {
        await UserController.updateUser(userWrapper.entityId, userWrapper);
        completer.complete();
      }
    });

    return completer.future;
  }
}
