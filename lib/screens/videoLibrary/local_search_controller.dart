import 'package:fitnessapp/models/main_group.dart';
import 'package:fitnessapp/models/private_group.dart';
import 'package:fitnessapp/models/sub_group.dart';
import 'package:fitnessapp/models/subscription.dart';
import 'package:fitnessapp/models/video.dart';
import 'package:get/get.dart';

class LocalSearchController extends GetxController {
  /// Private Video Group
  List<PrivateGroup>? allGroups;
  final tempGroups = <PrivateGroup>[];

  /// Private Videos
  List<Video>? allVideos;
  final tempVideos = <Video>[];

  /// Main Group
  List<MainGroup>? allMainGroups;
  final tempMainGroups = <MainGroup>[];

  /// Sub Group
  List<SubGroup>? allSubGroups;
  final tempSubGroups = <SubGroup>[];

  /// Subscriptions
  List<Subscription>? allSubs;
  final tempSubs = <Subscription>[];

  void searchPrivateGroups(String query) {
    tempGroups.clear();
    for (PrivateGroup g in allGroups!) {
      if (g.title!.toLowerCase().contains(query)) {
        tempGroups.add(g);
      }
    }
    update(['local_builder']);
  }

  void searchPrivateVideos(String query) {
    tempVideos.clear();
    for (Video g in allVideos!) {
      if (g.title_en!.toLowerCase().contains(query) ||
          (g.title_ar?.toLowerCase().contains(query) ?? false) ||
          (g.description_en?.toLowerCase().contains(query) ?? false) ||
          (g.description_ar?.toLowerCase().contains(query) ?? false)) {
        tempVideos.add(g);
      }
    }
    update(['local_builder']);
  }

  void searchMainGroups(String query) {
    tempMainGroups.clear();
    if (allMainGroups != null) {
      for (MainGroup g in allMainGroups!) {
        if (g.titleEnglish!.toLowerCase().contains(query) ||
            (g.titleArabic?.toLowerCase().contains(query) ?? false) ||
            (g.descriptionEnglish?.toLowerCase().contains(query) ?? false) ||
            (g.descriptionArabic?.toLowerCase().contains(query) ?? false)) {
          tempMainGroups.add(g);
        }
      }
    }

    update(['local_builder']);
  }

  void searchSubGroups(String query) {
    tempSubGroups.clear();
    if (allSubGroups != null) {
      for (SubGroup g in allSubGroups!) {
        if (g.titleEnglish!.toLowerCase().contains(query) ||
            (g.titleArabic?.toLowerCase().contains(query) ?? false) ||
            (g.descriptionEnglish?.toLowerCase().contains(query) ?? false) ||
            (g.descriptionArabic?.toLowerCase().contains(query) ?? false)) {
          tempSubGroups.add(g);
        }
      }
    }

    update(['local_builder']);
  }

  void searchSubscriptions(String query) {
    tempSubs.clear();
    if (allSubs != null) {
      for (Subscription g in allSubs!) {
        if (g.user!.getFullName().toLowerCase().contains(query) ||
            (g.amountPaid?.toString().toLowerCase().contains(query) ?? false)) {
          tempSubs.add(g);
        }
      }
    }

    update(['local_builder']);
  }
}
