import 'package:fitnessapp/models/user/user.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:hive/hive.dart';

part 'video.g.dart';

@HiveType(typeId: 8)
class Video {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? videoUrl;
  @HiveField(2)
  var duration;
  @HiveField(3)
  String? title_en = '';
  @HiveField(4)
  String? title_ar = '';
  @HiveField(5)
  String? description_en = '';
  @HiveField(6)
  String? description_ar = '';
  @HiveField(7)
  String? createdAt;
  @HiveField(8)
  String? updatedAt;
  @HiveField(9)
  int? coachId;
  @HiveField(10)
  int? privateVideoGroupId;
  @HiveField(11)
  bool? notifySubscriber;
  @HiveField(12)
  User? user;
  @HiveField(13)
  String? thumbnail;
  @HiveField(14)
  int? isProcessed = 0;
  @HiveField(15)
  String? videoStreamUrl;
  @HiveField(16)
  int? video_id;

  Video({
    this.id,
    this.videoUrl,
    this.duration,
    this.title_en,
    this.title_ar,
    this.description_en,
    this.description_ar,
    this.createdAt,
    this.updatedAt,
    this.coachId,
    this.privateVideoGroupId,
    this.thumbnail,
    this.user,
    this.isProcessed,
    this.videoStreamUrl,
    this.video_id,
  });

  get title {
    final arabic = title_ar ?? '';
    final english = title_en ?? '';

    if (Utils.isRTL()) {
      return arabic.isEmpty ? english : arabic;
    } else {
      return english.isEmpty ? arabic : english;
    }
  }

  get description {
    final arabic = description_ar ?? '';
    final english = description_en ?? '';

    if (Utils.isRTL()) {
      return arabic.isEmpty ? english : arabic;
    } else {
      return english.isEmpty ? arabic : english;
    }
  }

  get formattedTime => Utils.formatDateTime(createdAt!);

  Video.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    video_id = json['video_id']?.toInt();
    videoUrl = json['video_url']?.toString();
    duration = json['duration'];
    if (json['description_en'] != null) {
      description_en = json['description_en']?.toString();
    }
    if (json['description_ar'] != null) {
      description_ar = json['description_ar']?.toString();
    }
    if (json['title_en'] != null || json['title'] != null) {
      title_en =
          json[json['title_en'] != null ? 'title_en' : 'title']?.toString();
    }
    if (json['title_ar'] != null) {
      title_ar = json['title_ar']?.toString();
    }
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    coachId = json['coach_id']?.toInt();
    notifySubscriber = json['notify_subscribers'];
    privateVideoGroupId = json['private_video_group_id'] is String
        ? int.tryParse(json['private_video_group_id'])
        : json['private_video_group_id']?.toInt();
    thumbnail = json['thumbnail_url']?.toString();
    user = (json['coach'] != null) ? User.fromJson(json['coach']) : null;
    isProcessed = json['is_processed']?.toInt();
    videoStreamUrl = json['streaming_url'];
  }
}
