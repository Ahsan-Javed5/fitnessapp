// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MessageMetaValue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageMetaValue _$MessageMetaValueFromJson(Map<String, dynamic> json) =>
    MessageMetaValue(
      key: json['key'] as String?,
      value: json['value'] as String?,
      messageId: (json['messageId'] as num?)?.toDouble(),
      message: json['message'] == null
          ? null
          : Message.fromJson(json['message'] as Map<String, dynamic>?),
      text: json['text'] as String?,
      videoUrl: json['videoUrl'] as String?,
      duration: json['duration'] as String?,
      fileUrl: json['fileUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      extraMap: json['extraMap'] as Map<String, dynamic>?,
      type: json['type'] as int?,
    );

Map<String, dynamic> _$MessageMetaValueToJson(MessageMetaValue instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'messageId': instance.messageId,
      'message': instance.message,
      'text': instance.text,
      'videoUrl': instance.videoUrl,
      'fileUrl': instance.fileUrl,
      'duration': instance.duration,
      'audioUrl': instance.audioUrl,
      'extraMap': instance.extraMap,
      'type': instance.type,
    };
