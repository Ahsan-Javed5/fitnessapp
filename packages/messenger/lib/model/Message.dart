import 'package:json_annotation/json_annotation.dart';
import 'package:messenger/controllers/json_controller.dart';
import 'package:messenger/model/Read.dart';
import 'package:messenger/model/ReplyConversation.dart';

import './MessageMetaValue.dart';
import './Thread.dart';
import './User.dart';

part 'Message.g.dart';

@JsonSerializable()
class Message {
  String? entityID;
  double? date;
  int? type;
  int? status;
  double? senderId;
  double? nextMessageId;
  double? previousMessageId;
  User? sender;
  Thread? thread;
  late String threadEntityId;
  Message? nextMessage;
  Message? previousMessage;
  List<dynamic>? to;
  @JsonKey(name: 'user_firebase_id')
  String? userFirebaseId;
  @JsonKey(name: 'from')
  String? from;
  MessageMetaValue? meta;
  @JsonKey(name: 'read')
  List<Read>? readLink = <Read>[];
  String? prettyTime;
  ReplyConversation? replyConversation;
  Message? replayedMessage;

  Message(
      this.entityID,
      this.date,
      this.type,
      this.status,
      this.senderId,
      this.nextMessageId,
      this.previousMessageId,
      this.sender,
      this.thread,
      this.nextMessage,
      this.previousMessage,
      this.userFirebaseId,
      this.from,
      this.meta,
      this.replyConversation,
      this.replayedMessage);

  /// response attributes
  bool isError = false;
  String message = '';

  Message.fromError(this.isError, this.message);

  factory Message.fromJson(Map<String, dynamic>? json) =>
      _$MessageFromJson(JsonController.convertToJson(json));

  Message.fromJsonWithId(Map<String, dynamic> json, String? entityId) {
    var metaMap = json['meta'];
    var readMap = json['read'];
    var replyMap = json['replyConversation'];

    entityID = entityId; // this is the current message id
    date = json['date'] + 0.0;
    userFirebaseId = json['user_firebase_id'];
    from = json['from'];
    type = json['type'];
    to = json['to'];
    if (replyMap != null) {
      replyConversation = ReplyConversation.fromJson(
          Map<String, dynamic>.from(json['replyConversation']));
      // if (replyConversation?.isReply == true &&
      //     replyConversation?.messageId != null &&
      //     threadEntityId != null) {
      //   ThreadsController.getSpecificMessage(
      //     messageId: replyConversation!.messageId!,
      //     threadKey: threadEntityId,
      //   ).then((rMessage) {
      //     replayedMessage = rMessage;
      //   });
      // }
    }
    if (metaMap != null) {
      meta = MessageMetaValue.fromJson(Map<String, dynamic>.from(json['meta']));
    }
    if (readMap != null) {
      readMap.forEach((key, value) {
        Read r = Read.fromJsonWithId(Map<String, dynamic>.from(value), key);
        readLink!.add(r);
      });
    }
  }

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  /// default Message Object
  factory Message.defaultValue() {
    return Message(
      '', //entityID
      0, //date
      0, //type
      0, //status
      0, //senderId
      0, //nextMessageId
      0, //previousMessageId
      null, //User? sender,
      null, //Thread? thread,
      null, //Message? nextMessage,
      null, //Message? previousMessage,
      '', //String? userFirebaseId,
      '', //String? from
      null, //MessageMetaValue? meta,
      null, //ReplyConversation? replyConversation
      null, //Replayed Message
    );
  }
}
