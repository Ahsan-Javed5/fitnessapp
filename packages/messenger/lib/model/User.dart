import 'package:json_annotation/json_annotation.dart';
import 'package:messenger/controllers/json_controller.dart';

import 'Keys.dart';
import 'ThreadUserLink.dart';
import 'UserMetaValue.dart';

part 'User.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'meta')
  UserMetaValue? meta;
  @JsonKey(name: 'threads')
  List<ThreadUserLink>? threads;
  @JsonKey(name: 'last_online')
  double? lastOnline;
  @JsonKey(name: 'online')
  bool? online;
  String? entityId;

  User(this.meta, this.threads, this.lastOnline, this.online);

  User.rawMap(Map<dynamic, dynamic> map) {
    var meta = map['meta'];
    var threadsMap = map['threads'];

    if (map[Keys.LastOnline] != null)
      this.lastOnline = map['last_online'] + 0.0;

    online = map['online'];

    List<ThreadUserLink> threadList = <ThreadUserLink>[];

    if (meta != null) {
      this.meta =
          UserMetaValue.fromJson(Map<String, dynamic>.from(map['meta']));
    }
    if (threadsMap != null) {
      //message list
      threadsMap.forEach((key, value) {
        threadList.add(ThreadUserLink(value['invitedBy'], key));
      });

      this.threads = threadList;
    }
  }

  User.rawMapWithId(Map<dynamic, dynamic> map, String entityId) {
    this.entityId = entityId;
    var meta = map['meta'];
    var threadsMap = map['threads'];

    if (map[Keys.LastOnline] != null)
      this.lastOnline = map['last_online'] + 0.0;

    online = map['online'];

    List<ThreadUserLink> threadList = <ThreadUserLink>[];

    if (meta != null) {
      this.meta =
          UserMetaValue.fromJson(Map<String, dynamic>.from(map['meta']));
    }
    if (threadsMap != null) {
      //message list
      threadsMap.forEach((key, value) {
        threadList.add(ThreadUserLink(value['invitedBy'], key));
      });

      this.threads = threadList;
    }
  }

  factory User.fromJson(Map<String, dynamic>? json) =>
      _$UserFromJson(JsonController.convertToJson(json));

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
