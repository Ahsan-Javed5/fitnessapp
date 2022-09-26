import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:dio/dio.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/video.dart';
import 'package:fitnessapp/screens/video_player_screen.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class VideoPlayerController extends BaseController {
  String url = '';
  bool isMp4 = false;
  Dio dio = Dio();
  bool isApiLoading = true;
  bool isApiCrashed = false;
  bool isPlayerInitialized = false;
  String errorMessage = 'Something went wrong';
  BetterPlayerConfiguration betterPlayerConfiguration =
      BetterPlayerConfiguration(
    allowedScreenSleep: false,
    autoDetectFullscreenAspectRatio: true,
    autoDetectFullscreenDeviceOrientation: true,
    autoPlay: true,
    autoDispose: false,
    expandToFill: false,
    controlsConfiguration: BetterPlayerControlsConfiguration(
      enablePlaybackSpeed: true,
      enableFullscreen: false,
      enableRetry: true,
      enablePip: true,
      overflowMenuCustomItems: [
        BetterPlayerOverflowMenuItem(
          Icons.arrow_back_rounded,
          'Back'.tr,
          () => Get.back(),
        )
      ],
    ),
    deviceOrientationsAfterFullScreen: [
      DeviceOrientation.portraitUp,
    ],
    fit: BoxFit.contain,
  );
  late BetterPlayerController betterPlayerController;

  processUrl({
    String? rawUrl,
    int? processStatus,
    int? videoId,
    String? streamUrl,
    String? ifCoachIntroVideoThenId,
    File? localFileFromSaveGallery,
  }) async {
    isPlayerInitialized = false;
    isApiLoading = true;
    update(['videoPlayerScreen']);
    File? fileUrl;

    /// [isStreamingVideo] will return is url is streaming or not
    bool isStream =
        localFileFromSaveGallery != null ? false : isStreamingVideo(streamUrl!);
    if (localFileFromSaveGallery != null) {
      fileUrl = localFileFromSaveGallery;
    }

    if (isStream) {
      ///if its streaming url then play with stream
      url = getParsedUrl(rawUrl!, streamUrl);
    } else if (!isStream && localFileFromSaveGallery == null) {
      ///if its not streaming url then
      ///play with local file
      await isFileExists(
        url: rawUrl!,
        exists: (v) {
          if (Platform.isIOS) {
            String iosFilePath = 'file://${v.path}';
            fileUrl = v;
          } else {
            fileUrl = v;
          }
        },
      );
    }

    ///if streaming then pass [BetterPlayerDataSourceType.network] and
    ///if the file then [BetterPlayerDataSourceType.file]
    final isDone = await initializeBetterPlayerController(
      type: isStream
          ? BetterPlayerDataSourceType.network
          : BetterPlayerDataSourceType.file,
      urlV2: isStream ? url : fileUrl!.path,
    );
    if (!isDone) {
      isApiCrashed = true;
      isApiLoading = false;
      isPlayerInitialized = false;
      errorMessage = 'Unable to initialize video, please try again';
      update(['videoPlayerScreen']);
    } else {
      isPlayerInitialized = true;
      isApiLoading = false;
      update(['videoPlayerScreen']);
    }
  }

  getVideoUrl(int videoId, String? ifCoachIntroVideoThenId) async {
    if (videoId == -1) return;
    isApiLoading = true;

    final result = await getReq(
      ifCoachIntroVideoThenId != null
          ? 'api/coach/get_intro_video/$ifCoachIntroVideoThenId'
          : 'api/coach_private_video_group/video_details/$videoId',
      (json) => Video.fromJson(json),
      singleObjectData: true,
      showLoadingDialog: false,
    );

    if (!result.error) {
      isApiLoading = false;
      Video video = result.singleObjectData;
      return video.videoStreamUrl;
    } else {
      isApiLoading = false;
      errorMessage = result.message;
    }

    return '';
  }

  String getParsedUrl(String rawUrl, String streamUrl) {
    /* 0 Scheduled

      1 Processed

      2 Failed

      3 Processing */
    isMp4 = true;
    String url = rawUrl;

    if (rawUrl.isEmpty) {
      Utils.showSnack('Error', 'Invalid url', isError: true);
      return '';
    }

    if (streamUrl.isNotEmpty && streamUrl.contains('manifest')) {
      isMp4 = false;
      final parts = streamUrl.split('manifest');
      url = '${parts[0]}manifest(format=mpd-time-cmaf).mpd';
    }
    if (Platform.isIOS && streamUrl.isNotEmpty) {
      //+",audio-only=false"
      url = url.replaceAll(
          '(format=mpd-time-cmaf).mpd', '(format=m3u8-cmaf,audio-only=false)');
    }
    if (!url.contains(MyHive.sasKey)) {
      if (isMp4) url += MyHive.sasKey;
    } else {
      if (isMp4) url;
    }
    return url;
  }

  late BetterPlayerDataSource dataSource;
  initializeBetterPlayerController(
      {BetterPlayerDataSourceType? type, String? urlV2}) async {
    betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    if (Platform.isIOS) {
      dataSource = BetterPlayerDataSource(
        type ?? BetterPlayerDataSourceType.network,
        urlV2 ?? url,
        bufferingConfiguration: const BetterPlayerBufferingConfiguration(
          minBufferMs: 300,
          bufferForPlaybackAfterRebufferMs: 200,
        ),
        // cacheConfiguration: const BetterPlayerCacheConfiguration(
        //   useCache: true,
        //   preCacheSize: 100 * 1024 * 1024,
        //   maxCacheSize: 100 * 1024 * 1024,
        //   maxCacheFileSize: 100 * 1024 * 1024,
        // ),
      );
    } else {
      log(message: 'Android');
      dataSource = BetterPlayerDataSource(
        type ?? BetterPlayerDataSourceType.network,
        urlV2 ?? url,
        bufferingConfiguration: const BetterPlayerBufferingConfiguration(
          minBufferMs: 4000,
          bufferForPlaybackAfterRebufferMs: 3000,
        ),
        cacheConfiguration: const BetterPlayerCacheConfiguration(
          useCache: true,
          preCacheSize: 100 * 1024 * 1024,
          maxCacheSize: 100 * 1024 * 1024,
          maxCacheFileSize: 100 * 1024 * 1024,
        ),
      );
    }
    await betterPlayerController
        .setupDataSource(dataSource)
        .catchError((error) {
      isApiCrashed = true;
      isApiLoading = false;
      isPlayerInitialized = false;
      errorMessage = error.toString();
      update(['videoPlayerScreen']);
    });

    return (betterPlayerController.isVideoInitialized() ?? false);
  }

  /// saving video to Gallery
  Future saveVideoToGallery({
    required String url,
    required ValueChanged<String> onDownloadingStarted,
    required VoidCallback onDone,
  }) async {
    late File file;
    bool isE = await isFileExists(
      url: url,
      exists: (v) {
        file = v;
      },
    );
    if (!isE) {
      File? tempFile = await _downloadFile(
        url: url,
        onDownloadingStarted: onDownloadingStarted,
      );
      String? path = tempFile?.path;
      log(message: 'Temporary path : $path');
      if (path != null) {
        if (Platform.isAndroid) {
          GallerySaver.saveVideo(path, albumName: 'Fitness', toDcim: true).then(
            (isSuccess) async => {
              if (isSuccess ?? false)
                {
                  if (await isFileExists(url: url))
                    {
                      onDone.call(),
                    },
                  tempFile!.delete(),
                }
            },
          );
        } else {
          String? fileName = tempFile?.path.split('/').last;
          if (await isFileExists(url: url)) {
            onDone.call();
          }
        }
      }
    } else {
      showVideoDialog(file: file);
    }
  }

  void showVideoDialog({required File file}) {
    showDialog(
      context: Get.context!,
      builder: (context) => VideoPlayerScreen(
        url: ' ',
        fileFromGalleryView: file,
        // url: '${message.meta?.extraMap!['video_url']}',
        videoId: -1,
        processStatus: 1,
        videoStreamUrl: '',
      ),
      useSafeArea: false,
    );
  }

  ///this will return downloaded path of video
  Future<File?> _downloadFile({
    required String url,
    required ValueChanged<String> onDownloadingStarted,
  }) async {
    try {
      String? path = (Platform.isAndroid)
          ? await _getDirectory(url: url)
          : await createFolderInAppDocDir(url: url);
      if (!url.contains('?sv=')) {
        url += MyHive.sasKey;
      }
      log(message: 'Path where file is going to store : $path');
      await dio.download(
        url,
        path,
        onReceiveProgress: (rec, total) {
          String progress = (rec / total * 100).toStringAsFixed(0) + '%';
          onDownloadingStarted(progress);
          log(message: 'Rec: $rec , Total: $total');
        },
      );
      return File(path);
    } catch (e) {
      log(message: e.toString());
      return null;
    }
  }

  Future<String> _getDirectory({required String url}) async {
    String videoId = url.split('/').last;
    String dir = (await getTemporaryDirectory()).path;
    return '$dir/$videoId';
  }

  ///return true only if the exists and if the url is streaming url
  Future<bool> isFileExists(
      {required String url, ValueChanged<File>? exists}) async {
    String videoID;
    if (!url.contains(MyHive.sasKey)) {
      videoID = url.split('/').last;
    } else {
      String temp = url.split('/').last;
      videoID = temp.split('?').first;
    }
    String savePath = Platform.isIOS
        ? await createFolderInAppDocDir(url: url)
        : '${Routes.storagePath}/$videoID';
    bool isStreaming = isStreamingVideo(url);
    File file = File(savePath);
    bool isSaved = file.existsSync();
    if (isStreaming) {
      return true;
    } else if (isSaved) {
      exists?.call(file);
      return true;
    } else {
      return false;
    }
  }

  Future<String> createFolderInAppDocDir(
      {String? folderName, required String url}) async {
    folderName = 'Fitness';
    String videoId = url.split('/').last;
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    final Directory _appDocDirFolder =
        Directory('${_appDocDir.path}/$folderName');
    if (await _appDocDirFolder.exists()) {
      return '${_appDocDirFolder.path}/$videoId';
    } else {
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      return '${_appDocDirNewFolder.path}/$videoId';
    }
  }

  bool isStreamingVideo(String url) {
    if (url.contains('streaming')) {
      return true;
    } else {
      return false;
    }
  }
}
