import 'package:json_annotation/json_annotation.dart';
import 'package:messenger/controllers/json_controller.dart';
import 'package:messenger/model/User.dart';

part 'Chat.g.dart';

@JsonSerializable()
class Chat {
  static const String TEXT = 'text';
  String? type;
  dynamic content;
  User? from, to;
  bool? isSeen;
  DateTime? publishedAt;
  String? groupId;
  Chat(
      {this.content,
      this.from,
      this.to,
      this.isSeen,
      this.publishedAt,
      this.type,
      this.groupId});

  factory Chat.fromJson(Map<String, dynamic> json) =>
      _$ChatFromJson(JsonController.convertToJson(json));

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$ChatToJson`.
  Map<String, dynamic> toJson() => _$ChatToJson(this);
}
