import 'package:json_annotation/json_annotation.dart';
import 'package:messenger/controllers/json_controller.dart';

part 'ThreadUserLink.g.dart';

///
///
/// This class will hold thread information and this will be a child of user object
///
///
@JsonSerializable()
class ThreadUserLink {
  String? invitedBy;
  String? key;

  ///This variable is for local use only
  ///This variable will hold a Firebase time value by which we will decide
  ///the order of the threads in thread view screen
  // double lastActivityTime = 0;

  // its for local use only, it has no use in online db
  // using this variable as identifier to check if this thread is selected on not
  // bool isSelected = false;

  ThreadUserLink(this.invitedBy, this.key);

  factory ThreadUserLink.fromJson(Map<String, dynamic> json) =>
      _$ThreadUserLinkFromJson(JsonController.convertToJson(json));

  factory ThreadUserLink.fromJsonWithId(
      Map<String, dynamic> json, String entityId) {
    json['key'] = entityId;
    return _$ThreadUserLinkFromJson(JsonController.convertToJson(json));
  }

  Map<String, dynamic> toJson() => _$ThreadUserLinkToJson(this);
}
