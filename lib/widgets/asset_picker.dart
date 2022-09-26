import 'dart:io';

import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/utils/my_image_picker.dart';
import 'package:fitnessapp/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'formFieldBuilders/custom_label_field.dart';

/// This class is being used to pick image or videos
/// [isImagePicker] if true it will open image picker else it will open video picker
/// if [isImagePicker] is true then the min and max height will be [height] or default height
/// of [Spaces.normY(25)]
/// But in case of video the min height of the view will be [height] and max height will be [double.infinity]
/// to properly scale the video
/// [video] when selected will be played automatically

class AssetPicker extends StatefulWidget {
  final String label;
  final bool isImagePicker;
  final double? height;
  final Function(File, String duration, String filename)? onAssetSelected;
  final String setSelectedVideo;
  final double? maxVideoHeight;
  final String previousAssetUrl;

  const AssetPicker({
    Key? key,
    required this.label,
    this.isImagePicker = true,
    this.height,
    this.onAssetSelected,
    this.setSelectedVideo = 'Add Video',
    this.maxVideoHeight,
    this.previousAssetUrl = '',
  }) : super(key: key);

  @override
  _AssetPickerState createState() => _AssetPickerState();
}

class _AssetPickerState extends State<AssetPicker> {
  XFile? selectedAsset;
  VideoPlayerController? _controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomLabelField(labelText: widget.label),
        Container(
          margin: EdgeInsets.only(top: Spaces.normY(2)),
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: widget.height ?? Spaces.normY(25),
            maxHeight: widget.isImagePicker
                ? widget.height ?? Spaces.normY(25)
                : widget.maxVideoHeight ?? double.infinity,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Spaces.normX(1)),
            color: ColorConstants.veryVeryLightGray,
            boxShadow: const [
              BoxShadow(
                color: ColorConstants.veryVeryLightGray,
                offset: Offset(0, 1.5),
                blurRadius: 1.5,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Ink(
              child: InkWell(
                borderRadius: BorderRadius.circular(Spaces.normX(2)),
                onTap: () async {
                  final MyImagePicker _picker = MyImagePicker();

                  if (widget.isImagePicker) {
                    selectedAsset =
                        await _picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      if (widget.onAssetSelected != null) {
                        widget.onAssetSelected!(
                            File(selectedAsset!.path), '', '');
                      }
                    });
                  } else {
                    selectedAsset =
                        await _picker.pickVideo(source: ImageSource.gallery);
                    _controller =
                        VideoPlayerController.file(File(selectedAsset!.path));
                    await _controller!.initialize();
                    setState(() {
                      if (widget.onAssetSelected != null) {
                        var duration = _controller?.value.duration;
                        String time = duration.toString().contains('.')
                            ? duration.toString().split('.')[0]
                            : duration.toString();

                        widget.onAssetSelected!(File(selectedAsset!.path), time,
                            selectedAsset!.name);
                      }
                    });
                  }
                },
                child: widget.previousAssetUrl.isEmpty || selectedAsset != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // show icons nothing is selected yet
                          if (selectedAsset == null)
                            SvgPicture.asset(widget.isImagePicker
                                ? 'assets/svgs/ic_camera.svg'
                                : 'assets/svgs/ic_video.svg')
                          else // show preview, image or video is selected
                            ClipRRect(
                              child: widget.isImagePicker
                                  ? Image.file(File(selectedAsset!.path),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: widget.height ?? Spaces.normY(25))
                                  : SizedBox(
                                      height: widget.maxVideoHeight,
                                      child: MyVideoPlayer(
                                          width: double.infinity,
                                          height:
                                              widget.height ?? Spaces.normY(25),
                                          controller: _controller!),
                                    ),
                              borderRadius:
                                  BorderRadius.circular(Spaces.normX(2)),
                            ),
                          if (selectedAsset == null) Spaces.y1_0,
                          if (selectedAsset == null)
                            Text(
                              widget.isImagePicker
                                  ? 'add_image'.tr
                                  : widget.setSelectedVideo,
                              style: TextStyles.normalBlueBodyText,
                            ),
                        ],
                      )
                    : CustomNetworkImage(
                        imageUrl: widget.previousAssetUrl,
                      ),
              ),
            ),
          ),
        ),
        Spaces.y1,
        const Divider(
          color: ColorConstants.appBlack,
          thickness: 1.1,
        ),
      ],
    );
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller!.setVolume(0.0);
      _controller!.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) _controller!.dispose();
  }
}

class MyVideoPlayer extends StatefulWidget {
  final double width;
  final double height;
  final VideoPlayerController controller;

  const MyVideoPlayer({
    Key? key,
    required this.width,
    required this.height,
    required this.controller,
  }) : super(key: key);

  @override
  _MyVideoPlayerState createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    if (widget.controller.value.isInitialized) {
      widget.controller.setVolume(0);
      widget.controller.play();
    }
    return widget.controller.value.isInitialized
        ? SizedBox(
            width: widget.width,
            child: AspectRatio(
                aspectRatio: 1 / 1, child: VideoPlayer(widget.controller)),
          )
        : const SizedBox();
  }
}
