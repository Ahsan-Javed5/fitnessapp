// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ThreadMetaValue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadMetaValue _$ThreadMetaValueFromJson(Map<String, dynamic> json) =>
    ThreadMetaValue(
      json['creator_entity_id'] as String?,
      json['type'] as int?,
      json['creator'] as String?,
      (json['creation_date'] as num?)?.toDouble(),
      json['state'] as String?,
    );

Map<String, dynamic> _$ThreadMetaValueToJson(ThreadMetaValue instance) =>
    <String, dynamic>{
      'creator_entity_id': instance.creatorEntityId,
      'type': instance.type,
      'creator': instance.creator,
      'creation_date': instance.creationDate,
      'state': instance.state,
    };
