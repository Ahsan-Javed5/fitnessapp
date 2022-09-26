import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:fitnessapp/config/azure_blob_service.dart';
import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/private_group.dart';
import 'package:fitnessapp/models/video.dart' as model;
import 'package:fitnessapp/models/video.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/dialogs/general_message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class VideoLibraryController extends BaseController {
  final String _addPrivateVideoEndPoint =
      'api/coach_private_video_group/add_private_video/';
  final String _editPrivateVideoEndPoint =
      'api/coach_private_video_group/edit_private_video/';
  final String editPrivateGroupEndPoint =
      'api/coach_private_video_group/edit_private_group/';
  final String _getAllPrivateVideosEP =
      'api/coach_private_video_group/get_all_private_videos';
  final String _createPrivateGroupEP =
      'api/coach_private_video_group/add_private_group/';
  final String _getAllPrivateGroupsEP = 'api/coach_private_video_group/';
  final String getVideosOfPrivateGroupEP =
      'api/coach_private_video_group/get_private_group_videos/';
  final String _deletePrivateVideoEndPoint =
      'api/coach_private_video_group/delete_video/';
  final String _deletePrivateGroupEndPoint =
      'api/coach_private_video_group/delete_group_multiple';

  final selectedPrivateVideos = <model.Video>[].obs;
  final selectedPrivateGroups = <PrivateGroup>[].obs;
  final allPrivateVideos = <model.Video>[].obs;
  final allPrivateGroups = <PrivateGroup>[].obs;
  final videosOfPrivateGroup = <model.Video>[].obs;
  final storage = AzureStorage.parse(MyHive.azureConnectionString);

  /// temp data holders across views of this controller
  PrivateGroup? userSelectedPrivateGroup;

  /// this list will hold the list of [PrivateGroup] that we want to show on the screen
  final tempGroups = <PrivateGroup>[].obs;

  /// this list will hold the list of [Video] of a private group that we want to show on the screen
  final tempVideosOfPrivateGroup = <Video>[].obs;

  /// this list will contain the locally picked videos [File] which are going to be uploaded
  final selectedVideoFiles = <PlatformFile>[].obs;
  final selectedVideoAndThumbnails = <PlatformFile, Uint8List>{};
  double startMarginFactor = 0.0;

  /// upload multi videos params
  int index = 1;
  final doneToTotal = '1/1'.obs;
  final status = 'loading'.obs;
  final mProgressValue = 0.0.obs;

  void updateSelectedVideo(model.Video video) {
    if (selectedPrivateVideos.contains(video)) {
      selectedPrivateVideos.remove(video);
    } else {
      selectedPrivateVideos.add(video);
    }
    update([getVideosOfPrivateGroupEP]);
  }

  void updateSelectedPrivateGroup(PrivateGroup group) {
    if (selectedPrivateGroups.contains(group)) {
      selectedPrivateGroups.remove(group);
    } else {
      selectedPrivateGroups.add(group);
    }
  }

  bool isVideoSelectionEnabled() {
    return selectedPrivateVideos.isNotEmpty;
  }

  bool isPrivateGroupSelectionEnabled() {
    return selectedPrivateGroups.isNotEmpty;
  }

  void clearVideoSelection() {
    selectedPrivateVideos.clear();
    update([getVideosOfPrivateGroupEP]);
  }

  void clearGroupSelection() {
    selectedPrivateGroups.clear();
  }

  getVideosOfPrivateGroup() async {
    Get.closeAllSnackbars();
    setLoading(false);
    try {
      await Future.delayed(500.milliseconds, () async {
        setLoading(true);
        final result = await getReq(
            '$getVideosOfPrivateGroupEP${userSelectedPrivateGroup?.id}',
            (json) => model.Video.fromJson(json),
            showLoadingDialog: false);

        log(
            message:
                '$getVideosOfPrivateGroupEP${userSelectedPrivateGroup?.id}');

        if (!result.error) {
          videosOfPrivateGroup.clear();
          tempVideosOfPrivateGroup.clear();
          if (result.data?.isNotEmpty ?? false) {
            videosOfPrivateGroup.addAll([...?result.data]);
            tempVideosOfPrivateGroup.addAll(videosOfPrivateGroup);
          }
          update([getVideosOfPrivateGroupEP]);
        }
        setLoading(false);
        if ((Get.isDialogOpen ?? false) || (Get.isSnackbarOpen)) {
          Get.back();
        }
      });
    } finally {
      Future.delayed(1.seconds, () => setLoading(false));
    }
  }

  void getAllPrivateGroups() async {
    setLoading(false);
    await Future.delayed(10.milliseconds, () async {
      setLoading(true);
      final result = await getReq(
          _getAllPrivateGroupsEP, (json) => PrivateGroup.fromJson(json),
          showLoadingDialog: false);

      if (!result.error) {
        allPrivateGroups.clear();
        allPrivateGroups.addAll([...?result.data]);
        tempGroups.clear();
        tempGroups.addAll(allPrivateGroups);
      }
    });
    setLoading(false);
    setLoading(false);
  }

  void getAllPrivateVideos() async {
    Future.delayed(300.milliseconds, () async {
      allPrivateVideos.clear();
      final result = await getReq(
          _getAllPrivateVideosEP, (json) => model.Video.fromJson(json));

      if (!result.error) {
        allPrivateVideos.addAll([...?result.data]);
      }
    });
  }

  void createPrivateGroup(Map body, {File? imageFile}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    Future.delayed(const Duration(milliseconds: 1400), () async {
      progressValue.value = 0;
      setLoading(true, isVideo: true);
      final name = imageFile!.path.split('/');
      await storage.putBlob(
          '${MyHive.azureContainer}${DateTime.now()}${name.last}',
          body: imageFile.path,
          contentType: AzureStorage.getImgExtension(imageFile.path),
          bodyBytes: imageFile.readAsBytesSync(),
          onProgressChange: (d) => progressValue.value = d,
          onUploadComplete: (url) async {
            //setLoading(false);
            //setLoading(true);

            /// save url on our server with other details

            try {
              log(message: url);

              final requestBody = {...body, 'image': url};

              final result = await postReq(
                _createPrivateGroupEP,
                requestBody,
                (json) => PrivateGroup.fromJson(json),
                singleObjectData: true,
              );

              if (!result.error) {
                allPrivateGroups.add(result.singleObjectData);
                tempGroups.add(result.singleObjectData);
                userSelectedPrivateGroup = result.singleObjectData;
                setLoading(false);
                Get.back();
                Utils.showSnack(
                    'success'.tr, 'Private group is created successfully');
              } else {
                setLoading(false);
              }
            } catch (error) {
              setLoading(false);
            }
          },
          onUploadError: (e) {
            setLoading(false);
            setError(true);
            setMessage(e);
          });
    });
  }

  void updatePrivateGroup(Map body, PrivateGroup group,
      {File? imageFile}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    Future.delayed(const Duration(milliseconds: 1400), () async {
      progressValue.value = 0;
      setLoading(true, isVideo: true);
      if (imageFile == null) {
        final map = {...body};
        map['image'] = group.imageUrl;
        _updatePrivateGroup(map, group);
        return;
      }
      final name = imageFile.path.split('/');
      await storage.putBlob(
          '${MyHive.azureContainer}${DateTime.now()}_${name.last}',
          body: imageFile.path,
          contentType: AzureStorage.getImgExtension(imageFile.path),
          bodyBytes: imageFile.readAsBytesSync(),
          onProgressChange: (d) => progressValue.value = d,
          onUploadComplete: (url) async {
            //setLoading(false);
            //setLoading(true);

            /// save url on our server with other details
            log(message: url);

            final map = {...body};
            map['image'] = url;

            _updatePrivateGroup(map, group);
          },
          onUploadError: (e) {
            setLoading(false);
            setError(true);
            setMessage(e);
          });
    });
  }

  Future<bool> deleteSelectedVideos(videoIdsList) async {
    Map<String, dynamic> body = {};
    body['ids'] =
        videoIdsList.toString().replaceAll('[', '').replaceAll(']', '');
    final response =
        await postReq(_deletePrivateVideoEndPoint, body, (p0) => null);
    if (!response.error) {
      showSnackBar('alert'.tr, response.message);
      for (Video v in selectedPrivateVideos) {
        videosOfPrivateGroup.remove(v);
      }
    }

    return !response.error;
  }

  Future<bool> deleteSelectedGroups(groupIds) async {
    Map<String, dynamic> body = {};
    body['ids'] = groupIds.toString().replaceAll('[', '').replaceAll(']', '');
    final response =
        await postReq(_deletePrivateGroupEndPoint, body, (p0) => null);
    showSnackBar('alert'.tr, response.message);
    return !response.error;
  }

  editVideo(Map body, File? video, int videoId, Video oldVideo) async {
    FocusManager.instance.primaryFocus?.unfocus();
    Future.delayed(const Duration(milliseconds: 1400), () async {
      if (video == null) {
        body['video'] = oldVideo.videoUrl;
        body['thumbnail_url'] = oldVideo.thumbnail;
        setLoading(true);
        _editPrivateVideoOnOurServer(body, oldVideo);
        return;
      }

      /// Create Thumbnail and upload
      final uInt8List = await Utils.getThumbnailFromVideoFile(video.path);
      final imageFile = await Utils.uInt8ListToTempImageFile(uInt8List);
      String thumbnailUrl = await _uploadImage(
        imageFile!,
        '${DateTime.now()}_thumbnail.png',
      );
      progressValue.value = 0;
      setLoading(true, isVideo: true);
      await storage.putBlob('${MyHive.azureContainer}${body['title']}',
          bodyBytes: video.readAsBytesSync(),
          body: video.path,
          contentType: 'video/mp4',
          onProgressChange: (d) => progressValue.value = d,
          onUploadComplete: (s) async {
            //setLoading(false);
            body['video'] = s;
            body['thumbnail_url'] = thumbnailUrl;
            _editPrivateVideoOnOurServer(body, oldVideo);
          },
          onUploadError: (e) {
            setLoading(false);
            setError(true);
            setMessage(e);
          });
    });
  }

  addVideo(Map body, File videoFile, String path) async {
    //keep screen on while video uploading
    FocusManager.instance.primaryFocus?.unfocus();
    Future.delayed(const Duration(milliseconds: 1400), () async {
      progressValue.value = 0;
      setLoading(true, isVideo: true);
      await storage.putBlob('${MyHive.azureContainer}${body['title']}',
          bodyBytes: videoFile.readAsBytesSync(),
          body: path,
          contentType: 'video/mp4',
          onProgressChange: (d) => progressValue.value = d,
          onUploadComplete: (s) async {
            //setLoading(false);
            //setLoading(true);

            /// save url on our server with other details
            try {
              body['video'] = s;
              final response = await putReq(
                _addPrivateVideoEndPoint,
                '',
                body,
                (video) => model.Video.fromJson(video),
                singleObjectData: true,
              );

              setMessage(response.message);

              if (!response.error && response.singleObjectData != null) {
                setLoading(false);
                if (!videosOfPrivateGroup.contains(response.singleObjectData)) {
                  videosOfPrivateGroup.add(response.singleObjectData);
                  tempVideosOfPrivateGroup.add(response.singleObjectData);
                  update([getVideosOfPrivateGroupEP]);
                }
                Get.back();
              } else {
                setLoading(false);
              }
            } catch (error) {
              setLoading(false);
            }
          },
          onUploadError: (e) {
            setLoading(false);
            setError(true);
            setMessage(e);
          });
    });
  }

  /// This method will upload the image on Azure and will return the url
  /// of that image on azure
  _uploadImage(File imageFile, String name) async {
    Completer completer = Completer<String>();
    await storage.putBlob('${MyHive.azureContainer}$name',
        body: imageFile.path,
        contentType: AzureStorage.getImgExtension(imageFile.path),
        bodyBytes: imageFile.readAsBytesSync(),
        onProgressChange: (d) {}, onUploadComplete: (url) async {
      /// save url on our server with other details
      log(message: url);

      completer.complete(url);
    }, onUploadError: (e) {
      setError(true);
      completer.complete('');
      setMessage(e);
    });

    return completer.future;
  }

  void searchPrivateGroups(String query) {
    tempGroups.clear();
    if (query.isEmpty) {
      tempGroups.addAll(allPrivateGroups);
      return;
    }
    for (PrivateGroup g in allPrivateGroups) {
      if (g.title!.toLowerCase().contains(query)) {
        tempGroups.add(g);
      }
    }
  }

  void searchPrivateVideos(String query) {
    tempVideosOfPrivateGroup.clear();
    if (query.isEmpty) {
      tempVideosOfPrivateGroup.addAll(videosOfPrivateGroup);
      update([getVideosOfPrivateGroupEP]);
      return;
    }
    for (Video g in videosOfPrivateGroup) {
      if (g.title_en!.toLowerCase().contains(query) ||
          (g.title_ar?.toLowerCase().contains(query) ?? false) ||
          (g.description_en?.toLowerCase().contains(query) ?? false) ||
          (g.description_ar?.toLowerCase().contains(query) ?? false)) {
        tempVideosOfPrivateGroup.add(g);
      }
    }
    update([getVideosOfPrivateGroupEP]);
  }

  openMultiVideoPicker() async {
    selectedVideoFiles.clear();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowCompression: true,
        dialogTitle: 'upload_videos'.tr,
        type: FileType.video,
        onFileLoading: (s) {
          if (s == FilePickerStatus.picking) {
            setLoading(true);
          } else if (s == FilePickerStatus.done) {
            setLoading(false);
          }
        });

    if (result != null) {
      if (result.files.length > 3) {
        Future.delayed(
            500.milliseconds,
            () => Get.dialog(
                  GeneralMessageDialog(
                    message: 'You can only select 3 files at a time',
                    onPositiveButtonClick: () {
                      result.files.length = 0;
                      Get.back();
                      openMultiVideoPicker();
                    },
                  ),
                  useSafeArea: false,
                ));
      } else {
        for (var f in result.files) {
          final thumbnail = await Utils.getThumbnailFromVideoFile(f.path!);
          selectedVideoAndThumbnails[f] = thumbnail;
        }
        selectedVideoFiles.addAll(result.files);
        startMarginFactor = Spaces.normX(80) / result.files.length;
      }
    } else {
      // User canceled the picker
    }
  }

  uploadVideoFiles() async {
    try {
      if (selectedVideoFiles.isEmpty) {
        Utils.showSnack('alert', 'Please select at least one video');
        return;
      }
      index = 0;

      Get.defaultDialog(
          title: '',
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          barrierDismissible: false,
          radius: Spaces.normX(2),
          onWillPop: () {
            VideoCompress.cancelCompression();
            storage.uploader.cancelAll();
            storage.uploader.clearUploads();
            return Future.value(true);
          },
          content: Column(
            children: [
              Obx(() {
                return Text(
                  status.value.tr,
                  style: TextStyles.headingAppBlackBold,
                );
              }),
              Spaces.y2,
              Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(value: mProgressValue.value),
                    Text(
                      '${((mProgressValue.value) * 100).toInt()}/100',
                      style: TextStyles.normalGrayBodyText.copyWith(
                        fontSize: Spaces.normSP(8),
                      ),
                    ),
                  ],
                );
              }),
              Spaces.y2,
              Obx(() {
                return Text(doneToTotal.value);
              }),
              Spaces.y2,
            ],
          ));
      ignoreLoadingCalls = true;
      for (PlatformFile f in selectedVideoFiles) {
        /// reset values
        index++;
        doneToTotal.value = '$index/${selectedVideoFiles.length}';
        mProgressValue.value = 0;
        status.value = 'loading';
        status.value = 'compressing';
        await VideoCompress.setLogLevel(0);
        Subscription subscription =
            VideoCompress.compressProgress$.subscribe((progress) {
          mProgressValue.value = progress / 100;
        });

        File? renamedFile;
        if (Platform.isIOS && f.path!.contains(' ')) {
          renamedFile = await Utils.changeFileNameOnly(
              File.fromUri(Uri.parse(f.path!)),
              '${DateTime.now().microsecondsSinceEpoch}newVideo.mov');
        }

        final MediaInfo? info = await VideoCompress.compressVideo(
          renamedFile?.path ?? f.path!,
          quality: VideoQuality.HighestQuality,
          deleteOrigin: false,
          includeAudio: true,
        );
        subscription.unsubscribe();
        File file = File(info!.path!);
        await uploadVideoAndWait(file, f);
        mProgressValue.value = 0;
        doneToTotal.value = '$index/${selectedVideoFiles.length}';
      }
      ignoreLoadingCalls = false;
      update([getVideosOfPrivateGroupEP]);
      Get.back();
      Get.back();
      Utils.showSnack(
          'Alert',
          index == selectedVideoFiles.length
              ? 'Videos uploaded successfully'
              : 'Video upload process ended');
    } catch (e) {
      log(message: e.toString());
    }
  }

  uploadVideoAndWait(File file, PlatformFile f) async {
    Completer completer = Completer();
    status.value = 'Thumbnailing...';

    /// Upload thumbnail
    var tempFile =
        await Utils.uInt8ListToTempImageFile(selectedVideoAndThumbnails[f]!);
    String thumbnailUrl = await _uploadImage(
      tempFile!,
      '${f.name}thumbnail.png',
    );

    /// Upload Video
    status.value = 'uploading';
    await storage.putBlob(
        '${MyHive.azureContainer}${DateTime.now().microsecondsSinceEpoch}.mp4',
        //await storage.putBlob('${MyHive.azureContainer}${DateTime.now()}_${f.name}',
        bodyBytes: file.readAsBytesSync(),
        body: file.path,
        contentType: 'application/octet-stream',
        onProgressChange: (d) => mProgressValue.value = d,
        onUploadComplete: (s) async {
          /// save url and other video data on our server with other details
          VideoPlayerController controller = VideoPlayerController.file(file);
          await controller.initialize();
          final duration = controller.value.duration;
          String time = duration.toString().contains('.')
              ? duration.toString().split('.')[0]
              : duration.toString();
          await controller.dispose();
          final body = {
            'video': s,
            'title': f.name,
            'duration': time,
            'group_id': userSelectedPrivateGroup?.id,
            'thumbnail_url': thumbnailUrl,
            'description': ''
          };
          final response = await putReq(
            _addPrivateVideoEndPoint,
            '',
            body,
            (video) => model.Video.fromJson(video),
            singleObjectData: true,
            autoHandleLoadingIndicator: false,
          );

          if (!response.error && response.singleObjectData != null) {
            if (!videosOfPrivateGroup.contains(response.singleObjectData)) {
              videosOfPrivateGroup.add(response.singleObjectData);
              tempVideosOfPrivateGroup.add(response.singleObjectData);
            }
          }
          completer.complete();
        },
        onUploadError: (e) {
          completer.complete();
          setMessage(e);
        });

    return completer.future;
  }

  void _editPrivateVideoOnOurServer(Map body, Video video) async {
    //setLoading(true);

    /// save url on our server with other details
    final response = await putReq(
      _editPrivateVideoEndPoint,
      video.id,
      body,
      (video) => model.Video.fromJson(video),
      singleObjectData: true,
    );

    setMessage(response.message);
    setLoading(false);

    if (!response.error && response.singleObjectData != null) {
      if (!videosOfPrivateGroup.contains(response.singleObjectData)) {
        int index = videosOfPrivateGroup.indexOf(video);
        videosOfPrivateGroup.remove(video);
        tempVideosOfPrivateGroup.remove(video);
        videosOfPrivateGroup.insert(index, response.singleObjectData);
        tempVideosOfPrivateGroup.insert(index, response.singleObjectData);
        update([getVideosOfPrivateGroupEP]);
      }
      Get.back();
    }
  }

  void _updatePrivateGroup(Map body, PrivateGroup group) async {
    try {
      final result = await putReq(
        editPrivateGroupEndPoint + group.id.toString(),
        '',
        body,
        (json) => PrivateGroup.fromJson(json),
        singleObjectData: true,
      );

      if (!result.error) {
        int index = 0;
        index = allPrivateGroups.indexOf(group);
        allPrivateGroups.remove(group);
        tempGroups.remove(group);
        allPrivateGroups.insert(index, result.singleObjectData);
        tempGroups.insert(index, result.singleObjectData);
        setLoading(false);
        clearGroupSelection();
        Get.back();
        Utils.showSnack('success'.tr, 'Private group is updated successfully');
      } else {
        setLoading(false);
      }
    } catch (error) {
      setLoading(false);
    }
  }
}
