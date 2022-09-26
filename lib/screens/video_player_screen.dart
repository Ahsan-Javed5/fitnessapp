import 'dart:io';
import 'dart:ui';

import 'package:better_player/better_player.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/screens/video_player_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;
  final int processStatus;
  final int videoId;
  final String videoStreamUrl;
  final String? ifCoachIntroVideoThenId;
  final File? fileFromGalleryView;

  const VideoPlayerScreen({
    Key? key,
    required this.url,
    required this.processStatus,
    required this.videoId,
    required this.videoStreamUrl,
    this.ifCoachIntroVideoThenId,
    this.fileFromGalleryView,
  }) : super(key: key);

  @override
  _VideoPlayerScreenState2 createState() => _VideoPlayerScreenState2();
}

class _VideoPlayerScreenState2 extends State<VideoPlayerScreen> {
  final controller = Get.isRegistered<VideoPlayerController>()
      ? Get.find<VideoPlayerController>()
      : Get.put(VideoPlayerController());

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
    ));
    super.initState();
    controller.processUrl(
      rawUrl: widget.url,
      processStatus: widget.processStatus,
      videoId: widget.videoId,
      streamUrl: widget.videoStreamUrl,
      ifCoachIntroVideoThenId: widget.ifCoachIntroVideoThenId,
      localFileFromSaveGallery: widget.fileFromGalleryView,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: false,
        child: Scaffold(
          backgroundColor: ColorConstants.appBlack,
          body: SafeArea(
            child: GetBuilder<VideoPlayerController>(
                id: 'videoPlayerScreen',
                builder: (c) {
                  return c.isApiLoading
                      ? const Center(
                          child: CupertinoActivityIndicator(),
                        )
                      : c.isPlayerInitialized
                          ? Stack(
                              children: [
                                Column(
                                  children: [
                                    Expanded(
                                      child: BetterPlayer(
                                        controller: c.betterPlayerController,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Get.back();
                                    })
                              ],
                            )
                          : Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(c.errorMessage),
                                  FloatingActionButton.small(
                                    child: const Icon(
                                      Icons.arrow_back_rounded,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => Get.back(),
                                  ),
                                ],
                              ),
                            );
                }),
          ),
        ));
  }

  @override
  void dispose() {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    //   statusBarColor: Colors.transparent,
    //   statusBarBrightness: Brightness.light,
    // ));
    controller.betterPlayerController.dispose(forceDispose: true);
    super.dispose();
  }
}

/*class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  late ChewieController chewieController;

  @override
  void initState() {
    String url = widget.url;
    final parts = url.split('manifest');

    if (parts.length == 1) {
      Utils.showSnack('Info'.tr, 'media_services'.tr);
      Get.back();
      return;
    }

    if (Platform.isIOS) {
      url = '${parts[0]}manifest(format=m3u8-cmaf).m3u8';
    } else {
      url = '${parts[0]}manifest(format=mpd-time-cmaf).mpd';
    }

    if (Platform.isAndroid) {
      FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _controller = VideoPlayerController.network(url);
    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    if (Platform.isAndroid) {
      FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarBrightness:
            Brightness.light // Dark == white status bar -- for IOS.
        ));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    // Set portrait orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    _controller.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: false,
      child: Scaffold(
        backgroundColor: ColorConstants.primaryColorVariant,
        body: Stack(
          children: [
            Center(
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    chewieController = ChewieController(
                      videoPlayerController: _controller,
                      autoPlay: true,
                      looping: true,
                      allowFullScreen: true,
                      allowMuting: true,
                      allowPlaybackSpeedChanging: true,
                      showControls: true,
                      showOptions: true,
                      aspectRatio: _controller.value.aspectRatio,
                      deviceOrientationsAfterFullScreen: [
                        DeviceOrientation.portraitUp,
                      ],
                      additionalOptions: (context) {
                        return <OptionItem>[
                          OptionItem(
                            onTap: () {
                              Get.back();
                              Get.back();
                            },
                            iconData: Icons.arrow_back_rounded,
                            title: 'Go Back',
                          ),
                        ];
                      },
                    );
                    return SafeArea(
                      child: Chewie(
                        controller: chewieController,
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                },
              ),
            ),
            if (Platform.isIOS)
              Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    margin:
                        EdgeInsets.only(top: (window.viewPadding.top / 3) + 8),
                    padding:
                        EdgeInsets.symmetric(vertical: 2.5.w, horizontal: 5.w),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: SvgPicture.asset(
                      'assets/svgs/ic_close.svg',
                      height: 1.2.h,
                      width: 1.2.h,
                      color: Colors.white60,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}*/
