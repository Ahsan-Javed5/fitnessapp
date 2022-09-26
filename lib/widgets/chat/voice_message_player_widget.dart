import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/widgets/chat/background_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messenger/model/Message.dart';
import 'package:sizer/sizer.dart';

///i needs to make this widget stateful because if i use stateless with getxController
///then the state was maintained at once place so every player was handling that state
///i also try added GetBuilder by assigning a separate id's and then update them on that id
///still it didn't work so thats why i keep its state in its Class
class AudioPlayerWidget extends StatefulWidget {
  final Message message;
  final Color? backgroundCardColor;
  final Color playBtnBackgroundColor;
  final Color playBtnColor;
  final Color? seekBarColor;
  final Color? thumbColor;
  final Color? durationTextColor;
  final int? position;
  final String? playUrl;

  const AudioPlayerWidget(
      {this.backgroundCardColor,
      required this.thumbColor,
      required this.playBtnBackgroundColor,
      required this.playBtnColor,
      this.seekBarColor,
      required this.durationTextColor,
      this.position,
      required this.message,
      required this.playUrl,
      Key? key})
      : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget>
    with AutomaticKeepAliveClientMixin {
  AudioPlayer? audioPlayer;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  AudioCache? audioCache;
  bool isPlaying = false;
  bool isPlayed = false;
  //bool isFirstLoading = false;
  int? itemDuration;
  String? url;

  String timeFormatter(int time) {
    Duration duration = Duration(seconds: time);
    return [duration.inHours, duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  ///this will help to not to rebuild the while widget
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioCache = AudioCache();
    listenToState();
    getItemDuration();
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer?.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void resume() async {
    await audioPlayer?.resume();
  }

  Future pause() async {
    isPlayed = !isPlayed;
    await audioPlayer?.pause();
  }

  listenToState() {
    //isPlayed = !isPlayed;
    audioPlayer?.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });

    audioPlayer?.onDurationChanged.listen((d) {
      setState(() {
        duration = d;
      });
      itemDuration = d.inSeconds;
      setState(() {});
      print('max duration: ${d.inSeconds}');
    });
    audioPlayer?.onAudioPositionChanged.listen((p) {
      setState(() => position = p);
    });

    audioPlayer?.onPlayerCompletion.listen((event) {
      setState(() {
        isPlaying = false;

        ///NOTE: for now lets check this by commenting these 2 lines
        // position = Duration.zero;
        // duration = Duration.zero;
      });
    });
    audioPlayer?.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        isPlaying = false;
        duration = Duration.zero;
        position = Duration.zero;
      });
    });
  }

  String getAudioUrlWithSas(String url) {
    if (!url.contains(MyHive.sasKey)) {
      url = '$url${MyHive.sasKey}';
      return url;
    } else {
      return url;
    }
  }

  Future play({required String playUrl}) async {
    try {
      if (playUrl.isNotEmpty) {
        playUrl = getAudioUrlWithSas(playUrl);

        ///[audioPlayer?.setUrl] will return 1 in => success case
        // int? i = await audioPlayer?.setUrl(playUrl, isLocal: false);
        int? i = await audioPlayer?.play(playUrl, isLocal: false);
        // if (i != null && i == 1) {
        //   ///[audioPlayer?.play] will return 1 in => success case
        //
        // } else {
        //   Utils.showSnack('Error', 'Can\'t play this Audio');
        // }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void getItemDuration() async {
    String playUrl = getAudioUrlWithSas(widget.playUrl!);
    int? i = await audioPlayer?.setUrl(playUrl, isLocal: false);
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundCard(
      margin: EdgeInsets.only(top: 5, bottom: 1.h),
      color: widget.backgroundCardColor ?? Colors.white,
      height: 11.5.h,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                if (isPlaying) {
                  pause();
                } else {
                  play(playUrl: widget.playUrl!);
                }
              },
              child: Container(
                height: 8.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.playBtnBackgroundColor,
                ),
                child: Center(
                  child: isPlaying
                      ? Icon(
                          Icons.pause,
                          size: 32.0,
                          color: widget.playBtnColor,
                        )
                      : Icon(
                          Icons.play_arrow,
                          size: 32.0,
                          color: widget.playBtnColor,
                        ),
                ),
              ),
            ),
          ),

          ///slider and the text widget
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Slider(
                  value: position.inMilliseconds.toDouble(),
                  activeColor: widget.seekBarColor,
                  thumbColor: widget.thumbColor,
                  inactiveColor: ColorConstants.bodyGradientEndColor,
                  onChanged: (double value) async {
                    int a = await audioPlayer!
                        .seek(Duration(seconds: (value / 1000).round()));
                    await audioPlayer?.resume();
                  },
                  min: 0,
                  max: duration.inMilliseconds.toDouble(),
                ),
                Positioned(
                  child: isPlaying
                      ? Text(
                          timeFormatter(position.inSeconds),
                          style: TextStyle(color: widget.durationTextColor),
                        )
                      : Text(
                          isPlayed
                              ? timeFormatter(itemDuration ?? 0)
                              : widget.message.meta!.duration.toString(),
                          style: TextStyle(color: widget.durationTextColor),
                        ),
                  top: 3.5,
                  right: 28.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
