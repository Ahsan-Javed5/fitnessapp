// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      content: json['content'],
      from: json['from'] == null
          ? null
          : User.fromJson(json['from'] as Map<String, dynamic>?),
      to: json['to'] == null
          ? null
          : User.fromJson(json['to'] as Map<String, dynamic>?),
      isSeen: json['isSeen'] as bool?,
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
      type: json['type'] as String?,
      groupId: json['groupId'] as String?,
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'type': instance.type,
      'content': instance.content,
      'from': instance.from,
      'to': instance.to,
      'isSeen': instance.isSeen,
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'groupId': instance.groupId,
    };
