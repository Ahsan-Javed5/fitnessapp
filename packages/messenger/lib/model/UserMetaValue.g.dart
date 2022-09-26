// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserMetaValue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMetaValue _$UserMetaValueFromJson(Map<String, dynamic> json) =>
    UserMetaValue(
      json['phone'] as String?,
      json['name'] as String?,
      json['name_lowercase'] as String?,
      json['availability'] as String?,
      json['pictureURL'] as String?,
      json['userType'] as String?,
      json['email'] as String?,
      json['isChatAccess'] as bool?,
      json['fcm'] as String?,
    );

Map<String, dynamic> _$UserMetaValueToJson(UserMetaValue instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'name': instance.name,
      'name_lowercase': instance.nameLowerCase,
      'availability': instance.availability,
      'pictureURL': instance.pictureURL,
      'userType': instance.userType,
      'email': instance.email,
      'isChatAccess': instance.hasChatAccess,
      'fcm': instance.fcm,
    };
