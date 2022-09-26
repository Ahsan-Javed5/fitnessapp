import 'package:json_annotation/json_annotation.dart';
import 'package:messenger/controllers/json_controller.dart';

part 'UserThreadLink.g.dart';

///
///
/// This class will hold the user object that will be a child of thread object
///
///
@JsonSerializable()
class UserThreadLink {
  String? entityID;
  String? lastOnline;
  bool? isOnline;
  String? name;
  double? deleted;
  String? status;
  String? typing;

  UserThreadLink(
    this.entityID,
    this.lastOnline,
    this.isOnline,
    this.name,
    this.deleted,
    this.status,
    this.typing,
  );

  factory UserThreadLink.fromJson(Map<String, dynamic> json) =>
      _$UserThreadLinkFromJson(JsonController.convertToJson(json));

  ///These type of constructors are special constructor
  ///these are not auto generated
  ///i created these, in simple fromJson constructor we only get the details we dont get the id
  ///because id is used as key in Map<String, dynamic> and fromJson only parse the values
  factory UserThreadLink.fromJsonWithId(
      Map<String, dynamic> json, String entityId) {
    json['entityID'] = entityId;
    return _$UserThreadLinkFromJson(JsonController.convertToJson(json));
  }

  Map<String, dynamic> toJson() => _$UserThreadLinkToJson(this);
}
