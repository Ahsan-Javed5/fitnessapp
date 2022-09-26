// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ReplyConversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyConversation _$ReplyConversationFromJson(Map<String, dynamic> json) =>
    ReplyConversation(
      isReply: json['isReply'] as bool? ?? false,
      messageId: json['messageId'] as String?,
      userId: json['userId'] as String?,
      message: json['message'] as String?,
      type: json['type'] as int?,
      video_thumbnail: json['video_thumbnail'] as String?,
    );

Map<String, dynamic> _$ReplyConversationToJson(ReplyConversation instance) =>
    <String, dynamic>{
      'isReply': instance.isReply,
      'messageId': instance.messageId,
      'userId': instance.userId,
      'message': instance.message,
      'type': instance.type,
      'video_thumbnail': instance.video_thumbnail,
    };
