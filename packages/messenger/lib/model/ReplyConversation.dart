import 'package:json_annotation/json_annotation.dart';
import 'package:messenger/controllers/json_controller.dart';

part 'ReplyConversation.g.dart';

@JsonSerializable()
class ReplyConversation {
  @JsonKey(defaultValue: false)
  bool isReply;
  String? messageId;
  String? userId;
  String? message;
  int? type;
  String? video_thumbnail;

  ReplyConversation(
      {this.isReply = false,
      this.messageId,
      this.userId,
      this.message,
      this.type,
      this.video_thumbnail});

  factory ReplyConversation.fromJson(Map<String, dynamic>? json) =>
      _$ReplyConversationFromJson(JsonController.convertToJson(json));

  Map<String, dynamic> toJson() => _$ReplyConversationToJson(this);
}
