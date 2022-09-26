// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      json['entityID'] as String?,
      (json['date'] as num?)?.toDouble(),
      json['type'] as int?,
      json['status'] as int?,
      (json['senderId'] as num?)?.toDouble(),
      (json['nextMessageId'] as num?)?.toDouble(),
      (json['previousMessageId'] as num?)?.toDouble(),
      json['sender'] == null
          ? null
          : User.fromJson(json['sender'] as Map<String, dynamic>?),
      json['thread'] == null
          ? null
          : Thread.fromJson(json['thread'] as Map<String, dynamic>?),
      json['nextMessage'] == null
          ? null
          : Message.fromJson(json['nextMessage'] as Map<String, dynamic>?),
      json['previousMessage'] == null
          ? null
          : Message.fromJson(json['previousMessage'] as Map<String, dynamic>?),
      json['user_firebase_id'] as String?,
      json['from'] as String?,
      json['meta'] == null
          ? null
          : MessageMetaValue.fromJson(json['meta'] as Map<String, dynamic>?),
      json['replyConversation'] == null
          ? null
          : ReplyConversation.fromJson(
              json['replyConversation'] as Map<String, dynamic>?),
      json['replayedMessage'] == null
          ? null
          : Message.fromJson(json['replayedMessage'] as Map<String, dynamic>?),
    )
      ..threadEntityId = json['threadEntityId'] as String
      ..to = json['to'] as List<dynamic>?
      ..readLink = (json['read'] as List<dynamic>?)
          ?.map((e) => Read.fromJson(e as Map<String, dynamic>))
          .toList()
      ..prettyTime = json['prettyTime'] as String?
      ..isError = json['isError'] as bool
      ..message = json['message'] as String;

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'entityID': instance.entityID,
      'date': instance.date,
      'type': instance.type,
      'status': instance.status,
      'senderId': instance.senderId,
      'nextMessageId': instance.nextMessageId,
      'previousMessageId': instance.previousMessageId,
      'sender': instance.sender,
      'thread': instance.thread,
      'threadEntityId': instance.threadEntityId,
      'nextMessage': instance.nextMessage,
      'previousMessage': instance.previousMessage,
      'to': instance.to,
      'user_firebase_id': instance.userFirebaseId,
      'from': instance.from,
      'meta': instance.meta,
      'read': instance.readLink,
      'prettyTime': instance.prettyTime,
      'replyConversation': instance.replyConversation,
      'replayedMessage': instance.replayedMessage,
      'isError': instance.isError,
      'message': instance.message,
    };
