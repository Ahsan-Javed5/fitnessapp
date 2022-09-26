import 'package:fitnessapp/models/sub_group.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:hive/hive.dart';

part 'main_group.g.dart';

@HiveType(typeId: 6)
class MainGroup {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? titleEnglish;
  @HiveField(2)
  String? titleArabic;
  @HiveField(3)
  String? descriptionEnglish;
  @HiveField(4)
  String? descriptionArabic;
  @HiveField(5)
  String? groupThumbnail;
  @HiveField(6)
  String? groupPlain;
  @HiveField(7)
  String? forGender;
  @HiveField(8)
  bool? notifySubscribers;
  @HiveField(9)
  String? createdAt;
  @HiveField(10)
  String? updatedAt;
  @HiveField(11)
  int? coachId;
  @HiveField(12)
  bool isFree = false;
  @HiveField(13)
  List<SubGroup?>? subGroups;

  MainGroup({
    this.id,
    this.titleEnglish,
    this.titleArabic,
    this.descriptionEnglish,
    this.descriptionArabic,
    this.groupThumbnail,
    this.groupPlain,
    this.forGender,
    this.notifySubscribers,
    this.createdAt,
    this.updatedAt,
    this.coachId,
    this.isFree = false,
    this.subGroups,
  });

  MainGroup.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    titleEnglish = json['title_en']?.toString();
    titleArabic = json['title_ar']?.toString();
    descriptionEnglish = json['description_en']?.toString();
    descriptionArabic = json['description_ar']?.toString();
    groupThumbnail = json['group_thumbnail']?.toString();
    groupPlain = json['group_plain']?.toString();
    forGender = json['for_gender']?.toString();
    notifySubscribers = json['notify_subscribers'];
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    coachId = json['coach_id']?.toInt();
    isFree = json['group_plain'] == 'Free' ? true : false;
    if (json['CoachSubGroups'] != null) {
      final v = json['CoachSubGroups'];
      final arr0 = <SubGroup>[];
      v.forEach((v) {
        arr0.add(SubGroup.fromJson(v));
      });
      subGroups = arr0;
    }
  }

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

  get formattedCreatedAtTime => Utils.formatDateTime(createdAt ?? '');

  get formattedUpOrCreatedAtTime =>
      Utils.formatDateTime(updatedAt ?? (createdAt ?? ''));
}
