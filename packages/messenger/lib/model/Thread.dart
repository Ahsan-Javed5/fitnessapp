import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:messenger/controllers/json_controller.dart';
import 'package:messenger/controllers/user_controller.dart';
import 'package:messenger/model/Availability.dart';
import 'package:messenger/model/ThreadType.dart';
import 'package:messenger/utils/time_utils.dart';

import './ThreadMetaValue.dart';
import 'Message.dart';
import 'MessageType.dart';
import 'ReadType.dart';
import 'UserThreadLink.dart';

part 'Thread.g.dart';

@JsonSerializable()
class Thread extends ChangeNotifier {
  @JsonKey(name: 'meta')
  ThreadMetaValue? meta;
  @JsonKey(name: 'users')
  List<UserThreadLink>? users;
  @JsonKey(name: 'messages')
  List<Message>? messages;
  @JsonKey(name: 'details')
  ThreadMetaValue? threadDetails;
  String? entityId;

  /// response attributes
  bool isError = false;
  String message = '';

  ///These parameters will have value at runtime
  ///based on the current user and the thread he is requesting
  ///these parameter will calculate the name, picture, last message, unreadCount, online status
  String? displayName = '';
  String? displayUserFcm;
  String? displayPictureUrl = 'https://via.placeholder.com/68x60?text=!';
  String? prettyTime = '';
  String? lastMessage = 'no message yet';
  int unreadCount = 0;
  bool? onlineIndicator;
  double? lastOnline;
  double? latestActivityTime = 0;
  List<String?> unreadMessages = <String?>[];
  StreamSubscription<Event>? _event;

  /// if the receiver is disabled by admin or their availability status is [Availability.Disabled]
  /// then it will be true and we will not show the input layout
  bool isThreadDisabled = false;

  /// If the receiver has disabled their chat and their availability status is [Availability.Away]
  /// then it will be true and we will not show the input layout
  bool isUserAway = false;

  /// The firebase identifier of the receiver
  String? receiverUserId;

  Thread(this.meta);

  Thread.fromError(this.isError, this.message);

  Thread.defaultValues() {
    meta = ThreadMetaValue('', -1, '', 0.0, 'active');
  }

  factory Thread.fromJson(Map<String, dynamic>? json) =>
      _$ThreadFromJson(JsonController.convertToJson(json));

  Map<String, dynamic> toJson() => _$ThreadToJson(this);

  ///These type of constructors are special constructor
  ///these are not auto generated
  ///i created these, in simple fromJson constructor we only get the details we dont get the id
  ///because id is used as key in Map<String, dynamic> and fromJson only parse the values
  Thread.rawMapWithId(
      {required Map<dynamic, dynamic> map,
      String? currentUserId,
      String? entityId}) {
    this.entityId = entityId;
    var meta = (map['meta']);
    var messageMap = map['messages'];
    var userMap = map['users'];

    List<UserThreadLink> usersList = <UserThreadLink>[];
    ThreadMetaValue? metaValue;

    if (meta != null) {
      metaValue =
          ThreadMetaValue.fromJson(Map<String, dynamic>.from(map['meta']));
      threadDetails = metaValue;
      this.meta = metaValue;
    }

    ///get deletedTimeStamp for the current user
    double? deletedTimeStamp;

    if (userMap != null) {
      userMap.forEach((key, value) async {
        ///If [currentUserId] is not null and [thread] is [private1to1] then thread name will be empty
        ///because its private thread only group have names, so in this case the current user will see the other
        ///user's name and picture as thread display info
        ///currentUserId is null that means the requesting class don't need display info
        if (currentUserId != null &&
            currentUserId != key &&
            metaValue!.type == ThreadType.Private1to1) {
          getThreadDisplayInfo(key, currentUserId);
        }

        var userThreadLink = UserThreadLink.fromJsonWithId(
            Map<String, dynamic>.from(value), key);

        if (userThreadLink.entityID == currentUserId) {
          deletedTimeStamp = userThreadLink.deleted;
        }
        usersList.add(userThreadLink);
      });

      this.users = usersList;
    }

    sortAndListMessagesAsync(
        messageMap, currentUserId, metaValue!.creationDate, deletedTimeStamp);
  }

  void getThreadDisplayInfo(
    String receiverUserId,
    String currentUserId,
  ) async {
    this.receiverUserId = receiverUserId;
    _event = UserController.getUserIfPresentLive(receiverUserId, (user) {
      if (user != null) {
        bool shouldNotify = false;

        bool threadStatus = user.meta!.availability == Availability.Disabled;
        bool awayStatus = user.meta!.availability == Availability.Away;

        if (receiverUserId == 'admin' || currentUserId == 'admin') {
          threadStatus = false;
          awayStatus = false;
        }

        ///only notify if the display detail is changed otherwise no need
        if (displayName != user.meta!.name ||
            displayPictureUrl != user.meta!.pictureURL ||
            onlineIndicator != user.online ||
            threadStatus != isThreadDisabled ||
            awayStatus != isUserAway ||
            displayUserFcm != user.meta!.fcm) {
          shouldNotify = true;
        }

        if (shouldNotify) {
          displayName = user.meta!.name;
          displayUserFcm = user.meta!.fcm;
          displayPictureUrl = user.meta!.pictureURL;
          isThreadDisabled = threadStatus;
          isUserAway = awayStatus;
          onlineIndicator = user.online;
          lastOnline = user.lastOnline;
          if (displayPictureUrl == null || displayPictureUrl!.length < 3) {
            displayPictureUrl =
                'https://via.placeholder.com/68x60?text=${displayName![0]}';
          }
          notifyListeners();
        }
      }
    });
  }

  void unSubscribe() {
    if (_event != null) _event!.cancel();
  }

  void sortAndListMessagesAsync(
      Map<dynamic, dynamic>? messageMap,
      String? currentUserId,
      double? creationDate,
      double? deletedTimeStamp) async {
    List<Message> messageList = <Message>[];
    if (messageMap != null) {
      messageMap.forEach((key, value) {
        Message m = Message.fromJsonWithId(
          Map<String, dynamic>.from(value),
          key,
        );

        if (deletedTimeStamp != null && deletedTimeStamp > m.date!) return;

        if (m.from != currentUserId) {
          m.readLink!.forEach((element) {
            if (element.entityId == currentUserId &&
                element.status != ReadType.Seen) {
              if (unreadCount != null) unreadCount += 1;
              unreadMessages.add(m.entityID);
            }
          });
        }

        messageList.add(m);
      });
    }

    messageList.sort((a, b) => a.date!.compareTo(b.date!));
    messages = messageList;

    if (messages!.length < 1) {
      latestActivityTime = creationDate;
    } else {
      int? oldMessageType = messages![messages!.length - 1].type;
      int? messageType = messages![messages!.length - 1].meta?.type;
      latestActivityTime = messages![messages!.length - 1].date;

      if (oldMessageType != null && oldMessageType != -1) {
        if (oldMessageType == MessageType.TextV1) {
          lastMessage = messages![messages!.length - 1].meta?.text;
          return;
        } else if (oldMessageType == MessageType.VideoV1) {
          lastMessage = 'Video message';
          return;
        }
        if (messageType == MessageType.Text) {
          lastMessage = messages![messages!.length - 1].meta?.text;
          return;
        } else if (oldMessageType == MessageType.Audio) {
          lastMessage = 'Audio message';
          return;
        } else if (oldMessageType == MessageType.Video) {
          lastMessage = 'Video message';
          return;
        } else if (oldMessageType == MessageType.Image) {
          lastMessage = 'Image';
          return;
        } else {
          lastMessage = 'Unknown Old';
          return;
        }
      } else {
        if (messageType == MessageType.Text) {
          lastMessage = messages![messages!.length - 1].meta?.text;
          return;
        } else if (messageType == MessageType.Audio) {
          lastMessage = 'Audio message';
          return;
        } else if (messageType == MessageType.Video) {
          lastMessage = 'Video message';
          return;
        } else if (messageType == MessageType.Image) {
          lastMessage = 'Image';
          return;
        } else
          lastMessage = 'Unknown New';
      }
    }

    prettyTime = TimeUtils.getTimeInddMMMyyHHMM(latestActivityTime!);
    notifyListeners();
  }
}
