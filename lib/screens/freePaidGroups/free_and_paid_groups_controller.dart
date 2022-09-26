import 'dart:convert';
import 'dart:io';

import 'package:fitnessapp/config/azure_blob_service.dart';
import 'package:fitnessapp/constants/data.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/base_response.dart';
import 'package:fitnessapp/models/main_group.dart';
import 'package:fitnessapp/models/reordered_video.dart';
import 'package:fitnessapp/models/sub_group.dart';
import 'package:fitnessapp/models/video.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/dialogs/general_message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/reordered_groups.dart';

class FreeAndPaidGroupController extends BaseController {
  final freeGroups = <MainGroup>[].obs;
  final paidGroups = <MainGroup>[].obs;
  final tempFreeGroups = <MainGroup>[].obs;
  final tempPaidGroups = <MainGroup>[].obs;
  final videos = <Video>[].obs;
  final tempVideos = <Video>[].obs;
  var latestResponse = BaseResponse();
  var apiLoading = false;
  var isReorderVideo = false.obs; //for save button of reordering video
  final String reorderVideoEndPoint = 'api/coach_group/update/video_position';
  final String reorderGroupEndPoint = 'api/coach_group/update/group_position';

  int initialPageIndex = 0;

  /// when this is true it means user want to multi select videos
  /// and want to delete or edit video
  var videoEditEnabled = false.obs;

  /// This list will hold objects of [Video]
  /// This list of videos will be shared in the selected [MainGroup] or [SubGroup]
  /// At the moment we are sharing 1 video at a time so anyway to make it more flexible
  /// i am going with a list so that in future if we have a requirement to share
  /// multiple videos then we don't have to change the basic implementation
  final videosToBeShared = <Video>[].obs;
  final String _notifySubscriberEndPoint = 'api/coach_group/notifySubscribers';
  final String _notifySubscriberVideoEndPoint =
      'api/coach_group/video/notifySubscribers';

  /// These objects will hold the multi selected relevant items on long press
  final selectedGroups = <MainGroup>[].obs;
  final selectedSubGroups = <SubGroup>[].obs;
  final selectedMultiVideos = <Video>[].obs;

  /// These vars will hold the selected groups, sub groups, video
  /// that user is selecting while navigating through app
  /// e.g MainGroup>SubGroup>Video
  MainGroup? userSelectedMainGroup;
  SubGroup? userSelectedSubGroup;
  Video? userSelectedVideo;

  /// Fetch sub groups
  final String fetchSubgroupsEP = 'api/coach_group/sub_groups';
  final subgroups = <SubGroup>[];
  final tempSubgroups = <SubGroup>[];

  /// Create Main Group
  final String createMainGroupEP = 'api/coach_group/';
  BaseResponse<MainGroup>? createMainGroupResponse;

  /// Create Sub Group
  BaseResponse<SubGroup>? createSubGroupResponse;

  /// List of pre selected videos of a subgroup
  final editSubGroupVideos = <int>[2, 3, 5, 7];

  /// this will contain videos that user will tap to remove on edit sub group screen
  final selectedVideos = <int>[];

  final storage = AzureStorage.parse(MyHive.azureConnectionString);

  /// Use this method to add or remove video from the selected video list
  /// for edit sub group
  void updateSubGroupVideoList(int indexOfVideo, {bool notify = true}) {
    if (editSubGroupVideos.contains(indexOfVideo)) {
      editSubGroupVideos.remove(indexOfVideo);
    } else {
      if (editSubGroupVideos.length > 5) {
        Get.rawSnackbar(message: 'You can only select 6 videos');
        return;
      }
      editSubGroupVideos.add(indexOfVideo);
    }
    if (notify) update();
  }

  void clearSubGroupVideoList({bool notify = true}) {
    editSubGroupVideos.clear();
    if (notify) update();
  }

  /// Use this to maintain a list of videos which are going to be removed on
  /// save click in edit sub group screen
  void updateSelectedVideos(int index) {
    if (selectedVideos.contains(index)) {
      selectedVideos.remove(index);
    } else {
      selectedVideos.add(index);
    }
    update();
  }

  void updateSelectedGroups(MainGroup mainGroup) {
    if (selectedGroups.contains(mainGroup)) {
      selectedGroups.remove(mainGroup);
    } else {
      selectedGroups.add(mainGroup);
    }
    update(['main_group_selection']);
  }

  void updateSelectedSubGroups(SubGroup subGroup) {
    if (selectedSubGroups.contains(subGroup)) {
      selectedSubGroups.remove(subGroup);
    } else {
      selectedSubGroups.add(subGroup);
    }
    update(['sub_group_selection']);
  }

  void updatedSelectedVideos(Video video) {
    if (selectedMultiVideos.contains(video)) {
      selectedMultiVideos.remove(video);
    } else {
      selectedMultiVideos.add(video);
    }
    update(['video_selection_builder']);
  }

  bool isGroupSelectionEnabled() {
    return selectedGroups.isNotEmpty;
  }

  bool isSubGroupSelectionEnabled() {
    return selectedSubGroups.isNotEmpty;
  }

  bool isVideoSelectionEnabled() {
    return selectedMultiVideos.isNotEmpty;
  }

  clearSelection() {
    selectedGroups.clear();
    selectedSubGroups.clear();
    selectedVideos.clear();
    selectedMultiVideos.clear();
    update();
    update(['main_group_selection']);
    update(['sub_group_selection']);
    update(['video_selection_builder']);
  }

  Future<bool> notifySubscriber(
      int id, String groupType, BuildContext context, bool isVideo) async {
    Map map = {};
    if (isVideo) {
      map['id'] = id;
    } else {
      map['group_id'] = id;
      map['group_type'] = groupType;
    }
    var response = await postReq(
        isVideo ? _notifySubscriberVideoEndPoint : _notifySubscriberEndPoint,
        map,
        (p0) => null);
    if (!response.error) {
      showDialog(
        context: context,
        builder: (context) => GeneralMessageDialog(
          message: 'your_subscribers_have_been_notified'.tr,
        ),
        useSafeArea: false,
      );
      return true;
    } else {
      return false;
    }
  }

  createGroup(Map body, File imageFile, bool isTypeMainGroup) async {
    FocusManager.instance.primaryFocus?.unfocus();
    Future.delayed(const Duration(milliseconds: 1400), () async {
      progressValue.value = 0;
      setLoading(true, isVideo: true);
      final name = imageFile.path.split('/');
      await storage.putBlob('${MyHive.azureContainer}${name.last}',
          body: imageFile.path,
          contentType: AzureStorage.getImgExtension(imageFile.path),
          bodyBytes: imageFile.readAsBytesSync(),
          onProgressChange: (d) => progressValue.value = d,
          onUploadComplete: (url) async {
            //setLoading(false);
            //setLoading(true);

            /// save url on our server with other details
            log(message: url);

            body['image'] = url;

            final result = await postReq(
              createMainGroupEP,
              body,
              (json) => isTypeMainGroup
                  ? MainGroup.fromJson(json)
                  : SubGroup.fromJson(json),
              singleObjectData: true,
            );
            if (!result.error && result.singleObjectData != null) {
              setLoading(false);
              if (isTypeMainGroup) {
                _updateMainGroupListing(result);
              } else {
                _updateSubGroupListing(result);
              }
              Get.back();
            }
            if (result.error) {
              if (result.message == 'Your free Group limit exceeded.') {
                DataUtils.errorMessage = 'group_limit_exceed_error_msg'.tr;
                Get.back(result: 'empty results');
              }
            }
            setLoading(false);
          },
          onUploadError: (e) {
            setLoading(false);
            setError(true);
            setMessage(e);
          });
    });
  }

  void _updateMainGroupListing(BaseResponse<dynamic> result) {
    final group = result.singleObjectData as MainGroup;
    group.updatedAt = DateTime.now().toString();
    if (group.isFree) {
      freeGroups.insert(0, group);
      tempFreeGroups.insert(0, group);
    } else {
      paidGroups.insert(0, group);
      tempPaidGroups.insert(0, group);
    }
  }

  void _updateSubGroupListing(BaseResponse<dynamic> result) {
    final group = result.singleObjectData as SubGroup;
    subgroups.insert(0, group);
    tempSubgroups.insert(0, group);
    update([fetchSubgroupsEP]);
  }

  void fetchSubGroups(String mainGroupId) async {
    apiLoading = true;
    subgroups.clear();
    Future.delayed(1.milliseconds, () async {
      final result = await getReq(
        fetchSubgroupsEP,
        (p0) => SubGroup.fromJson(p0),
        query: {'main_group_id': mainGroupId},
      );

      if (!result.error) {
        subgroups.clear();
        tempSubgroups.clear();
        subgroups.addAll([...?result.data]);
        tempSubgroups.addAll(subgroups);
        update([fetchSubgroupsEP]);
      }
      latestResponse = result;
      apiLoading = false;
    });
  }

  void fetchVideos({bool isMainGroup = false}) async {
    Future.delayed(1.milliseconds, () async {
      final result = await getReq(
          'api/coach_group/videos', (json) => Video.fromJson(json),
          query: {
            'type': isMainGroup ? 'MAIN_GROUP' : 'SUB_GROUP',
            'limit': '300',
            'id': isMainGroup
                ? userSelectedMainGroup!.id!.toString()
                : userSelectedSubGroup!.id!.toString(),
          });

      if (!result.error) {
        videos.clear();
        tempVideos.clear();
        videos.addAll([...?result.data]);
        tempVideos.addAll(videos);
      }
    });
  }

  void fetchFreeAndPaidGroups() async {
    Future.delayed(1.milliseconds, () async {
      final paidGroupResponse = await getReq(
          'api/coach_group/main_groups?group_plain=Paid&limit=200',
          (json) => MainGroup.fromJson(json));
      if (!paidGroupResponse.error) {
        paidGroups.clear();
        paidGroups.addAll([...?paidGroupResponse.data]);
        tempPaidGroups.clear();
        tempPaidGroups.addAll(paidGroups);
      }
    });

    Future.delayed(1.milliseconds, () async {
      final freeGroupResponse = await getReq(
          'api/coach_group/main_groups?group_plain=Free&limit=200',
          (json) => MainGroup.fromJson(json));
      if (!freeGroupResponse.error) {
        freeGroups.clear();
        freeGroups.addAll([...?freeGroupResponse.data]);
        tempFreeGroups.clear();
        tempFreeGroups.addAll(freeGroups);
      }
    });
  }

  void searchInGroups(String query) {
    searchFreeGroups(query);
    searchPaidGroups(query);
    update(['main_group_selection']);
  }

  void searchFreeGroups(String query) {
    tempFreeGroups.clear();
    if (query.isEmpty) {
      tempFreeGroups.addAll(freeGroups);
      return;
    }
    for (MainGroup g in freeGroups) {
      if ((g.titleEnglish ?? '').toLowerCase().contains(query) ||
          (g.description ?? '').toLowerCase().contains(query)) {
        tempFreeGroups.add(g);
      }
    }
  }

  void searchPaidGroups(String query) {
    tempPaidGroups.clear();
    if (query.isEmpty) {
      tempPaidGroups.addAll(paidGroups);
      return;
    }
    for (MainGroup g in paidGroups) {
      if ((g.titleEnglish ?? '').toLowerCase().contains(query) ||
          (g.description ?? '').toLowerCase().contains(query)) {
        tempPaidGroups.add(g);
      }
    }
  }

  void searchInSubGroups(String query) {
    tempSubgroups.clear();
    if (query.isEmpty) {
      tempSubgroups.addAll(subgroups);
      update([fetchSubgroupsEP]);
      return;
    }
    for (SubGroup g in subgroups) {
      if ((g.titleEnglish ?? '').toLowerCase().contains(query) ||
          (g.description ?? '').toLowerCase().contains(query)) {
        tempSubgroups.add(g);
      }
    }
    update([fetchSubgroupsEP]);
  }

  void searchInVideos(String query) {
    tempVideos.clear();
    if (query.isEmpty) {
      tempVideos.addAll(videos);
      return;
    }
    for (Video g in videos) {
      if ((g.title ?? '').toLowerCase().contains(query) ||
          (g.description ?? '').toLowerCase().contains(query)) {
        tempVideos.add(g);
      }
    }
  }

  void saveVideoOrder() async {
    var videosList = <ReorderedVideo>[];

    for (var i = 0; i < tempVideos.length; i++) {
      Video video = tempVideos[i];
      videosList.add(ReorderedVideo(video.id, i));
    }

    Map<dynamic, dynamic> body = {};
    body['videos'] = jsonEncode(videosList);
    body['group_id'] = userSelectedSubGroup?.id ?? userSelectedMainGroup?.id;
    body['group_type'] = 'SUB_GROUP';

    var result = await putReq(reorderVideoEndPoint, '', body, (p0) => null);
    if (!result.error) {
      isReorderVideo.value = false;
      showSnackBar('Success', message);
    }
  }

  void savePaidSubGroupOrder(List<SubGroup> list) async {
    var groupList = <ReorderedGroup>[];
    for (var i = 0; i < list.length; i++) {
      SubGroup group = list[i];
      groupList.add(ReorderedGroup(group.id, i));
    }

    Map<dynamic, dynamic> body = {};
    body['groups'] = jsonEncode(groupList);
    body['group_type'] = 'SUB_GROUP';

    var result = await putReq(reorderGroupEndPoint, '', body, (p0) => null);
    if (!result.error) {
      isReorderVideo.value = false;
      showSnackBar('Success', message);
    }
  }

  void saveMainGroupOrder(RxList<MainGroup> list) async {
    var groupList = <ReorderedGroup>[];
    for (var i = 0; i < list.length; i++) {
      MainGroup group = list[i];
      groupList.add(ReorderedGroup(group.id, i));
    }

    Map<dynamic, dynamic> body = {};
    body['groups'] = jsonEncode(groupList);
    body['group_type'] = 'MAIN_GROUP';

    var result = await putReq(reorderGroupEndPoint, '', body, (p0) => null);
    if (!result.error) {
      isReorderVideo.value = false;
      showSnackBar('Success', message);
    }
  }

  void shareVideosInSelectedGroup(Map<String, dynamic> body) async {
    final requestBody = {
      'group_type': userSelectedSubGroup != null ? 'SUB_GROUP' : 'MAIN_GROUP',
      'group_id': userSelectedSubGroup != null
          ? userSelectedSubGroup!.id
          : userSelectedMainGroup!.id,
      'videos': [body],
    };

    final result = await postReq(
      'api/coach_group/add_videos',
      requestBody,
      (json) => Video.fromJson(json),
    );

    if (!result.error) {
      videos.add(result.data!.last);
      tempVideos.add(result.data!.last);
      videosToBeShared.clear();
      Utils.backUntil(untilRoute: Routes.freePaidSubGroupScreen);
      showSnackBar('Success', 'Video is added successfully');
    } else {
      if (result.message == 'Your Free Group video limit is exceeded.') {
        DataUtils.errorMessage = 'video_limit_exceed_error_msg'.tr;
        Get.back(result: 'empty results');
      }
    }
  }

  deleteSelectedMainGroups() async {
    Get.back();
    var mainGroupIds = <int>[];
    for (MainGroup group in selectedGroups) {
      mainGroupIds.add(group.id!);
    }

    Map<String, dynamic> body = {};
    body['ids'] =
        mainGroupIds.toString().replaceAll('[', '').replaceAll(']', '');
    final response = await postReq('api/coach_group/delete/main_group', body,
        (json) => MainGroup.fromJson(json));
    if (!response.error) {
      showSnackBar('alert'.tr, response.message);
      for (MainGroup group in selectedGroups) {
        if (group.groupPlain!.toLowerCase() == 'free') {
          freeGroups.remove(group);
          tempFreeGroups.remove(group);
        } else {
          paidGroups.remove(group);
          tempPaidGroups.remove(group);
        }
      }
    }

    Utils.backUntil(untilRoute: Routes.freeAndPaidGroupsScreen);
    clearSelection();
    return !response.error;
  }

  deleteSelectedSubGroups() async {
    Get.back();
    var subGroupIds = <int>[];
    for (SubGroup group in selectedSubGroups) {
      subGroupIds.add(group.id!);
    }

    Map<String, dynamic> body = {};
    body['ids'] =
        subGroupIds.toString().replaceAll('[', '').replaceAll(']', '');
    final response = await postReq('api/coach_group/delete/sub_group', body,
        (json) => SubGroup.fromJson(json));
    if (!response.error) {
      showSnackBar('alert'.tr, response.message);
      for (SubGroup group in selectedSubGroups) {
        subgroups.remove(group);
        tempSubgroups.remove(group);
      }
    }
    Utils.backUntil(untilRoute: Routes.freePaidMainGroupScreen);
    clearSelection();
    return !response.error;
  }

  deleteSelectedVideo() async {
    Get.back();
    var videoIds = <int>[];
    for (Video video in selectedMultiVideos) {
      videoIds.add(video.id!);
    }

    Map<String, dynamic> body = {};
    body['ids'] = videoIds.toString().replaceAll('[', '').replaceAll(']', '');
    final response = await postReq(
        'api/coach_group/delete/videos', body, (json) => Video.fromJson(json));
    if (!response.error) {
      showSnackBar('alert'.tr, response.message);
      for (Video group in selectedMultiVideos) {
        videos.remove(group);
        tempVideos.remove(group);
      }
    }
    clearSelection();
    videoEditEnabled.value = false;
    Utils.backUntil(untilRoute: Routes.freePaidSubGroupScreen);
    return !response.error;
  }

  void editMainGroupDetails(Map<String, dynamic> body, MainGroup group,
      {File? imageFile}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    Future.delayed(const Duration(milliseconds: 1400), () async {
      /// if no image, then just uppdate the details on our server
      if (imageFile == null) {
        _editMainGroup(body, group);
        return;
      }
      progressValue.value = 0;
      setLoading(true, isVideo: true);
      final name = imageFile.path.split('/');
      await storage.putBlob('${MyHive.azureContainer}${name.last}',
          body: imageFile.path,
          contentType: AzureStorage.getImgExtension(imageFile.path),
          bodyBytes: imageFile.readAsBytesSync(),
          onProgressChange: (d) => progressValue.value = d,
          onUploadComplete: (url) async {
            //setLoading(false);
            //setLoading(true);

            /// save url on our server with other details
            log(message: url);

            body['image'] = url;

            _editMainGroup(body, group);
          },
          onUploadError: (e) {
            setLoading(false);
            setError(true);
            setMessage(e);
          });
    });
  }

  /// edit main group at our server
  void _editMainGroup(Map<String, dynamic> body, MainGroup group) async {
    FocusManager.instance.primaryFocus?.unfocus();
    Future.delayed(const Duration(milliseconds: 10), () async {
      /// if no image, then just uppdate the details on our server
      try {
        final result = await putReq(
          'api/coach_group/edit_group/' + group.id.toString(),
          '',
          body,
          (json) => MainGroup.fromJson(json),
          singleObjectData: true,
        );

        if (!result.error) {
          if (result.singleObjectData != null) {
            final updatedObj = result.singleObjectData as MainGroup;

            if (freeGroups.contains(group)) {
              freeGroups.remove(group);
              tempFreeGroups.remove(group);
            } else {
              paidGroups.remove(group);
              tempPaidGroups.remove(group);
            }

            if (updatedObj.groupPlain!.toLowerCase() == 'free') {
              freeGroups.add(updatedObj);
              tempFreeGroups.add(updatedObj);
            } else {
              paidGroups.add(updatedObj);
              tempPaidGroups.add(updatedObj);
            }
          }
          setLoading(false);
          clearSelection();
          Get.until(
              (route) => Get.currentRoute == Routes.freeAndPaidGroupsScreen);
          Utils.showSnack('success'.tr, 'Group is updated successfully');
        } else {
          setLoading(false);
        }
      } catch (error) {
        setLoading(false);
      }
    });
  }

  void editSubGroupDetails(Map<String, dynamic> body, SubGroup group,
      {File? imageFile}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    Future.delayed(const Duration(milliseconds: 1400), () async {
      /// if no image, then just uppdate the details on our server
      if (imageFile == null) {
        _editSubGroup(body, group);
        return;
      }
      progressValue.value = 0;
      setLoading(true, isVideo: true);
      final name = imageFile.path.split('/');
      await storage.putBlob('${MyHive.azureContainer}${name.last}',
          body: imageFile.path,
          contentType: AzureStorage.getImgExtension(imageFile.path),
          bodyBytes: imageFile.readAsBytesSync(),
          onProgressChange: (d) => progressValue.value = d,
          onUploadComplete: (url) async {
            //setLoading(false);
            //setLoading(true);

            /// save url on our server with other details
            log(message: url);

            body['image'] = url;

            _editSubGroup(body, group);
          },
          onUploadError: (e) {
            setLoading(false);
            setError(true);
            setMessage(e);
          });
    });
  }

  /// edit sub group at our server
  void _editSubGroup(Map<String, dynamic> body, SubGroup group) async {
    FocusManager.instance.primaryFocus?.unfocus();
    Future.delayed(const Duration(milliseconds: 10), () async {
      /// if no image, then just uppdate the details on our server
      //setLoading(true);
      try {
        final result = await putReq(
          'api/coach_group/edit_group/' + group.id.toString(),
          '',
          body,
          (json) => SubGroup.fromJson(json),
          singleObjectData: true,
        );

        if (!result.error) {
          if (result.singleObjectData != null) {
            subgroups.remove(group);
            tempSubgroups.remove(group);
            tempSubgroups.add(result.singleObjectData);
            subgroups.add(result.singleObjectData);
          }

          setLoading(false);
          clearSelection();
          Get.until(
              (route) => Get.currentRoute == Routes.freePaidMainGroupScreen);
          Utils.showSnack('success'.tr, 'Group is updated successfully');
        } else {
          setLoading(false);
        }
      } catch (error) {
        setLoading(false);
      }
    });
  }

  void editVideoDetails(Map<String, dynamic> body, Video video) async {
    final result = await putReq(
      'api/coach_group/edit_video/' + video.id.toString(),
      '',
      body,
      (json) => Video.fromJson(json),
      singleObjectData: true,
    );

    if (!result.error) {
      videosToBeShared.clear();
      if (result.singleObjectData != null) {
        int index = videos.indexOf(video);
        videos.remove(video);
        tempVideos.remove(video);
        videos.insert(index, result.singleObjectData);
        tempVideos.insert(index, result.singleObjectData);
      }

      clearSelection();
      Get.back();
      Utils.showSnack('success'.tr, 'Video is updated successfully');
    }
  }
}
