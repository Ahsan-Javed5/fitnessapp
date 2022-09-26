import 'dart:developer';

import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/screens/video_player_controller.dart';
import 'package:fitnessapp/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CustomNetworkVideo extends StatefulWidget {
  final double width;
  final double height;
  final String url;
  final String thumbnail;
  final BoxFit? fit;
  final bool inChat;
  final VoidCallback? onPlayButtonClick;

  const CustomNetworkVideo({
    Key? key,
    required this.width,
    required this.height,
    required this.url,
    this.inChat = false,
    this.onPlayButtonClick,
    this.thumbnail = '',
    this.fit,
  }) : super(key: key);

  @override
  _CustomNetworkVideoState createState() => _CustomNetworkVideoState();
}

class _CustomNetworkVideoState extends State<CustomNetworkVideo> {
  VideoPlayerController controller = Get.isRegistered<VideoPlayerController>()
      ? Get.find<VideoPlayerController>()
      : Get.put(VideoPlayerController());

  String? downProgress;
  bool isFileExists = false;

  @override
  void initState() {
    super.initState();
    checkFile();
  }

  checkFile() async {
    isFileExists = await controller.isFileExists(url: widget.url);
    setState(() {});
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: (widget.url.isNotEmpty || widget.thumbnail.isNotEmpty)
          ? (widget.thumbnail.isNotEmpty
              ? Stack(
                  children: [
                    SizedBox(
                      height: widget.height,
                      width: widget.width,
                      child: CustomNetworkImage(
                        key: widget.key,
                        imageUrl: widget.thumbnail,
                        fit: widget.fit ?? BoxFit.cover,
                      ),
                    ),
                    PositionedDirectional(
                      top: 0,
                      bottom: 0,
                      start: 0,
                      end: 0,
                      child: widget.inChat
                          ? isFileExists
                              ? IconButton(
                                  icon: SvgPicture.asset(
                                    'assets/svgs/ic_video_play.svg',
                                    matchTextDirection: false,
                                    fit: BoxFit.scaleDown,
                                    height: widget.height / 3,
                                    width: widget.height / 3,
                                  ),
                                  onPressed: widget.onPlayButtonClick,
                                )
                              : GestureDetector(
                                  onTap: () {
                                    log('Start downloading file');
                                    controller.saveVideoToGallery(
                                      url: widget.url,
                                      onDownloadingStarted: (String progress) {
                                        downProgress = progress;
                                        setState(() {});
                                      },
                                      onDone: () {
                                        isFileExists = true;
                                        setState(() {});
                                      },
                                    );
                                  },
                                  child: Transform.scale(
                                    scale: 0.3,
                                    child: CircleAvatar(
                                      backgroundColor: ColorConstants.appBlue,
                                      child: (downProgress?.trim().isEmpty ??
                                              true)
                                          ? Icon(
                                              Icons.download_outlined,
                                              color: ColorConstants.whiteColor,
                                              size: 10.h,
                                            )
                                          : Text(
                                              '$downProgress',
                                              style: TextStyle(
                                                color:
                                                    ColorConstants.whiteColor,
                                                fontSize: 25.sp,
                                              ),
                                            ),
                                    ),
                                  ),
                                )
                          : IconButton(
                              icon: SvgPicture.asset(
                                'assets/svgs/ic_video_play.svg',
                                matchTextDirection: false,
                                fit: BoxFit.scaleDown,
                                height: widget.height / 3,
                                width: widget.height / 3,
                              ),
                              onPressed: widget.onPlayButtonClick,
                            ),
                    ),
                  ],
                )
              : const Center(
                  child: Text('Thumbnail not available'),
                ))
          : const Center(
              child: Text('no_file_found'),
            ),
    );
  }
}
