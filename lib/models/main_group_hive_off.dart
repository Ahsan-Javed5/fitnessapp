

import 'package:fitnessapp/models/user/user.dart';

class MainGroupHiveOff {
  int? id;
  String? titleEn;
  String? titleAr;
  String? descriptionEn;
  String? descriptionAr;
  String? groupThumbnail;
  String? groupPlain;
  String? forGender;
  bool? notifySubscribers;
  String? createdAt;
  String? updatedAt;
  int? coachId;
  User? user;

  MainGroupHiveOff(
      {this.id,
        this.titleEn,
        this.titleAr,
        this.descriptionEn,
        this.descriptionAr,
        this.groupThumbnail,
        this.groupPlain,
        this.forGender,
        this.notifySubscribers,
        this.createdAt,
        this.updatedAt,
        this.coachId,
        this.user});

  MainGroupHiveOff.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titleEn = json['title_en'];
    titleAr = json['title_ar'];
    descriptionEn = json['description_en'];
    descriptionAr = json['description_ar'];
    groupThumbnail = json['group_thumbnail'];
    groupPlain = json['group_plain'];
    forGender = json['for_gender'];
    notifySubscribers = json['notify_subscribers'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    coachId = json['coach_id'];
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
  }
}