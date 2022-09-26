// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserThreadLink.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserThreadLink _$UserThreadLinkFromJson(Map<String, dynamic> json) =>
    UserThreadLink(
      json['entityID'] as String?,
      json['lastOnline'] as String?,
      json['isOnline'] as bool?,
      json['name'] as String?,
      (json['deleted'] as num?)?.toDouble(),
      json['status'] as String?,
      json['typing'] as String?,
    );

Map<String, dynamic> _$UserThreadLinkToJson(UserThreadLink instance) =>
    <String, dynamic>{
      'entityID': instance.entityID,
      'lastOnline': instance.lastOnline,
      'isOnline': instance.isOnline,
      'name': instance.name,
      'deleted': instance.deleted,
      'status': instance.status,
      'typing': instance.typing,
    };
