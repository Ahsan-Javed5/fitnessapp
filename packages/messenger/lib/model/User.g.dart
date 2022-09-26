// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['meta'] == null
          ? null
          : UserMetaValue.fromJson(json['meta'] as Map<String, dynamic>?),
      (json['threads'] as List<dynamic>?)
          ?.map((e) => ThreadUserLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['last_online'] as num?)?.toDouble(),
      json['online'] as bool?,
    )..entityId = json['entityId'] as String?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'meta': instance.meta,
      'threads': instance.threads,
      'last_online': instance.lastOnline,
      'online': instance.online,
      'entityId': instance.entityId,
    };
