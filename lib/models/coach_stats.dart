import 'package:fitnessapp/models/main_group.dart';
import 'package:fitnessapp/models/monthly_statement.dart';
import 'package:fitnessapp/models/video.dart';

import 'subscriber.dart';

class CoachStats {
  List<Subscriber?>? activeSubscribers;
  List<Subscriber?>? expiredSubscribers;
  List<MainGroup?>? freeGroups;
  List<MainGroup?>? paidGroups;
  List<Video?>? videoLibrary;
  List<MonthlyStatement?>? monthlyStatements;

  CoachStats({
    this.activeSubscribers,
    this.expiredSubscribers,
    this.freeGroups,
    this.paidGroups,
    this.videoLibrary,
    this.monthlyStatements,
  });

  CoachStats.fromJson(Map<String, dynamic> json) {
    if (json['active_subscribers'] != null &&
        (json['active_subscribers'] is List)) {
      final v = json['active_subscribers'];
      final arr0 = <Subscriber>[];
      v.forEach((v) {
        arr0.add(Subscriber.fromJson(v));
      });
      activeSubscribers = arr0;
    }
    if (json['expired_subscribers'] != null &&
        (json['expired_subscribers'] is List)) {
      final v = json['expired_subscribers'];
      final arr0 = <Subscriber>[];
      v.forEach((v) {
        arr0.add(Subscriber.fromJson(v));
      });
      expiredSubscribers = arr0;
    }
    if (json['free_groups'] != null && (json['free_groups'] is List)) {
      final v = json['free_groups'];
      final arr0 = <MainGroup>[];
      v.forEach((v) {
        arr0.add(MainGroup.fromJson(v));
      });
      freeGroups = arr0;
    }
    if (json['paid_groups'] != null && (json['paid_groups'] is List)) {
      final v = json['paid_groups'];
      final arr0 = <MainGroup>[];
      v.forEach((v) {
        arr0.add(MainGroup.fromJson(v));
      });
      paidGroups = arr0;
    }
    if (json['video_library'] != null && (json['video_library'] is List)) {
      final v = json['video_library'];
      final arr0 = <Video>[];
      v.forEach((v) {
        arr0.add(Video.fromJson(v));
      });
      videoLibrary = arr0;
    }
    if (json['monthly_statements'] != null &&
        (json['monthly_statements'] is List)) {
      final v = json['monthly_statements'];
      final arr0 = <MonthlyStatement>[];
      v.forEach((v) {
        arr0.add(MonthlyStatement.fromJson(v));
      });
      monthlyStatements = arr0;
    }
  }
}
