import 'package:fitnessapp/models/video.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:hive/hive.dart';

part 'sub_group.g.dart';

@HiveType(typeId: 7)
class SubGroup {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? titleEnglish = '';
  @HiveField(2)
  String? titleArabic = '';
  @HiveField(3)
  String? descriptionEnglish = '';
  @HiveField(4)
  String? descriptionArabic = '';
  @HiveField(5)
  String? groupThumbnail;
  @HiveField(6)
  bool? notifySubscribers;
  @HiveField(7)
  String? createdAt;
  @HiveField(8)
  String? updatedAt;
  @HiveField(9)
  String? mainGroupId;
  @HiveField(10)
  List<Video?>? videos;

  get title {
    final arabic = titleArabic ?? '';
    final english = titleEnglish ?? '';

    if (Utils.isRTL()) {
      return arabic.isEmpty ? english : arabic;
    } else {
      return english.isEmpty ? arabic : english;
    }
  }

  get description {
    final arabic = descriptionArabic ?? '';
    final english = descriptionEnglish ?? '';

    if (Utils.isRTL()) {
      return arabic.isEmpty ? english : arabic;
    } else {
      return english.isEmpty ? arabic : english;
    }
  }

  get formattedTime =>
      Utils.formatDateTime(createdAt ?? DateTime.now().toString());

  SubGroup({
    this.id,
    this.titleEnglish,
    this.titleArabic,
    this.descriptionEnglish,
    this.descriptionArabic,
    this.groupThumbnail,
    this.notifySubscribers,
    this.createdAt,
    this.updatedAt,
    this.mainGroupId,
    this.videos,
  });

  SubGroup.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    if (json['title_en'] != null) {
      titleEnglish = json['title_en']?.toString();
    }
    if (json['title_ar'] != null) {
      titleArabic = json['title_ar']?.toString();
    }
    if (json['description_en'] != null) {
      descriptionEnglish = json['description_en']?.toString();
    }
    if (json['description_ar'] != null) {
      descriptionArabic = json['description_ar']?.toString();
    }
    groupThumbnail = json['group_thumbnail']?.toString();
    notifySubscribers = json['notify_subscribers'];
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    mainGroupId = json['main_group_id']?.toString();
    if (json['CoachGroupVideos'] != null) {
      final v = json['CoachGroupVideos'];
      final arr0 = <Video>[];
      v.forEach((v) {
        arr0.add(Video.fromJson(v));
      });
      videos = arr0;
    }
  }
}
