import 'package:fitnessapp/models/video.dart';
import 'package:fitnessapp/utils/utils.dart';

class PrivateGroup {
  int? id;
  String? title;
  int? coachId;
  String? updatedAt;
  String? createdAt;
  String? imageUrl;
  List<Video?>? videos;

  get formattedCreatedAtTime => Utils.formatDateTime(createdAt ?? '');

  PrivateGroup(
      {this.id,
      this.title,
      this.coachId,
      this.updatedAt,
      this.createdAt,
      this.imageUrl,
      this.videos});

  PrivateGroup.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    title = json['title']?.toString();
    coachId = json['coach_id']?.toInt();
    updatedAt = json['updatedAt']?.toString();
    createdAt = json['createdAt']?.toString();
    imageUrl = json['image_url']?.toString();
    if (json['CoachPrivateGroupVideos'] != null) {
      final v = json['CoachPrivateGroupVideos'];
      final arr0 = <Video>[];
      v.forEach((v) {
        arr0.add(Video.fromJson(v));
      });
      videos = arr0;
    }
  }
}
