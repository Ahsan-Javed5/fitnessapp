import 'package:json_annotation/json_annotation.dart';
import 'package:messenger/controllers/json_controller.dart';

import 'Keys.dart';

part 'UserMetaValue.g.dart';

@JsonSerializable()
class UserMetaValue {
  @JsonKey(name: Keys.Phone)
  String? phone;
  @JsonKey(name: Keys.Name)
  String? name;
  @JsonKey(name: Keys.NameLowercase)
  String? nameLowerCase;
  @JsonKey(name: Keys.Availability)
  String? availability;
  @JsonKey(name: Keys.AvatarURL)
  String? pictureURL;
  @JsonKey(name: Keys.UserType)
  String? userType;
  @JsonKey(name: Keys.Email)
  String? email;
  @JsonKey(name: Keys.hasChatAccess)
  bool? hasChatAccess;
  @JsonKey(name: 'fcm')
  String? fcm;

  UserMetaValue(this.phone, this.name, this.nameLowerCase, this.availability,
      this.pictureURL, this.userType, this.email, this.hasChatAccess, this.fcm);

  factory UserMetaValue.fromJson(Map<String, dynamic>? json) =>
      _$UserMetaValueFromJson(JsonController.convertToJson(json));

  Map<String, dynamic> toJson() => _$UserMetaValueToJson(this);
}
