import 'package:firebase_database/firebase_database.dart';
import 'package:messenger/model/ThreadUserLink.dart';
import 'package:messenger/model/User.dart';

///This class will wrap the user information into
///a Map object which will be pushed to firebase
class UserWrapper {
  String? name;
  String? lowerCaseName;
  String? phone;
  String? pictureURL;
  String? email;
  String? userType;
  String? availability;
  Map<String, String>? lastOnline;
  double? lastOnlineDouble;
  List<ThreadUserLink>? threads;

  /// [lastOnline] is a map which will hold a  Server,timeStamp for new users
  /// [lastOnlineDouble] will hold a plain double value for exsiting users
  /// convert this value to map when pushing to the server

  late String entityId;
  String? fcm;

  UserWrapper.toServerObject({
    required String this.name,
    required this.phone,
    this.pictureURL,
    this.email,
    this.availability,
    required this.userType,
  }) {
    this.lowerCaseName = name!.toLowerCase();
    this.lastOnline = ServerValue.timestamp;

    if (pictureURL == null) this.pictureURL = '';
    if (email == null) this.email = '';
  }

  ///Provide a user object
  ///that object will be mapped on to UserWrapper class instance
  ///and use public properties to change the values
  ///and that instance then can be pushed to firebase
  ///use this constructor when you want to update a user
  UserWrapper.fromUser(User user) {
    name = user.meta!.name;
    lowerCaseName = name!.toLowerCase();
    pictureURL = user.meta!.pictureURL;
    phone = user.meta!.phone;
    email = user.meta!.email;
    availability = user.meta!.availability;
    this.threads = user.threads;
    lastOnlineDouble = user.lastOnline;
  }
}
