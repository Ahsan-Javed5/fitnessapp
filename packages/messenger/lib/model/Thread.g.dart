// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Thread _$ThreadFromJson(Map<String, dynamic> json) => Thread(
      json['meta'] == null
          ? null
          : ThreadMetaValue.fromJson(json['meta'] as Map<String, dynamic>),
    )
      ..users = (json['users'] as List<dynamic>?)
          ?.map((e) => UserThreadLink.fromJson(e as Map<String, dynamic>))
          .toList()
      ..messages = (json['messages'] as List<dynamic>?)
          ?.map((e) => Message.fromJson(e as Map<String, dynamic>?))
          .toList()
      ..threadDetails = json['details'] == null
          ? null
          : ThreadMetaValue.fromJson(json['details'] as Map<String, dynamic>)
      ..entityId = json['entityId'] as String?
      ..isError = json['isError'] as bool
      ..message = json['message'] as String
      ..displayName = json['displayName'] as String?
      ..displayUserFcm = json['displayUserFcm'] as String?
      ..displayPictureUrl = json['displayPictureUrl'] as String?
      ..prettyTime = json['prettyTime'] as String?
      ..lastMessage = json['lastMessage'] as String?
      ..unreadCount = json['unreadCount'] as int
      ..onlineIndicator = json['onlineIndicator'] as bool?
      ..lastOnline = (json['lastOnline'] as num?)?.toDouble()
      ..latestActivityTime = (json['latestActivityTime'] as num?)?.toDouble()
      ..unreadMessages = (json['unreadMessages'] as List<dynamic>)
          .map((e) => e as String?)
          .toList()
      ..isThreadDisabled = json['isThreadDisabled'] as bool
      ..isUserAway = json['isUserAway'] as bool
      ..receiverUserId = json['receiverUserId'] as String?;

Map<String, dynamic> _$ThreadToJson(Thread instance) => <String, dynamic>{
      'meta': instance.meta,
      'users': instance.users,
      'messages': instance.messages,
      'details': instance.threadDetails,
      'entityId': instance.entityId,
      'isError': instance.isError,
      'message': instance.message,
      'displayName': instance.displayName,
      'displayUserFcm': instance.displayUserFcm,
      'displayPictureUrl': instance.displayPictureUrl,
      'prettyTime': instance.prettyTime,
      'lastMessage': instance.lastMessage,
      'unreadCount': instance.unreadCount,
      'onlineIndicator': instance.onlineIndicator,
      'lastOnline': instance.lastOnline,
      'latestActivityTime': instance.latestActivityTime,
      'unreadMessages': instance.unreadMessages,
      'isThreadDisabled': instance.isThreadDisabled,
      'isUserAway': instance.isUserAway,
      'receiverUserId': instance.receiverUserId,
    };
