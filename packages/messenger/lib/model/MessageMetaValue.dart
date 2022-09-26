import 'package:json_annotation/json_annotation.dart';
import 'package:messenger/controllers/json_controller.dart';

import './Message.dart';

part 'MessageMetaValue.g.dart';

@JsonSerializable()
class MessageMetaValue {
  String? key;
  String? value;
  double? messageId;
  Message? message;
  String? text;
  String? videoUrl;
  String? fileUrl;
  String? duration;
  String? audioUrl;
  Map<String, dynamic>? extraMap;
  int? type;
  @override
  String toString() => "$text $audioUrl $duration ";
  MessageMetaValue({
    this.key,
    this.value,
    this.messageId,
    this.message,
    this.text,
    this.videoUrl,
    this.fileUrl,
    this.duration,
    this.audioUrl,
    this.extraMap,
    this.type,
  });

  factory MessageMetaValue.fromJson(Map<String, dynamic>? json) =>
      _$MessageMetaValueFromJson(JsonController.convertToJson(json));

  Map<String, dynamic> toJson() => _$MessageMetaValueToJson(this);
}
