// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Read.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Read _$ReadFromJson(Map<String, dynamic> json) => Read(
      json['status'] as int?,
      (json['date'] as num?)?.toDouble(),
      json['entityId'] as String?,
    );

Map<String, dynamic> _$ReadToJson(Read instance) => <String, dynamic>{
      'status': instance.status,
      'date': instance.date,
      'entityId': instance.entityId,
    };
