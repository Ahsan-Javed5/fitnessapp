import 'dart:developer';

import 'package:file/local.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/screens/chat/controllers/audio_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

///recorder mic
class RecorderWidget extends StatefulWidget {
  final Function onStartRecording;
  final ValueChanged<String?> onRecordingEnd;

  const RecorderWidget({
    Key? key,
    required this.onStartRecording,
    required this.onRecordingEnd,
  }) : super(key: key);

  @override
  _RecorderWidgetState createState() => _RecorderWidgetState();
}

class _RecorderWidgetState extends State<RecorderWidget>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  late LocalFileSystem localFileSystem;
  bool isRecording = false;
  final audioController = Get.find<AudioController>();

  final Tween<double> _tween = Tween(
    begin: 1.2,
    end: 2.5,
  );

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        log('Recorder Resumed');

        break;
      case AppLifecycleState.inactive:
        log('Recorder Inactive');
        // _controller.stop();
        // controller.stopRecording(wantToDelFile: true);
        if (audioController.isRecording) {
          endRecording();
        }
        //setState(() {});
        break;
      case AppLifecycleState.paused:
        log('Recorder Paused');
        if (audioController.isRecording) {
          endRecording();
        }
        // _controller.stop();
        // controller.stopRecording(wantToDelFile: true);
        //
        // setState(() {});
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  ///Controller
  AudioController controller = Get.find<AudioController>();
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _tween.animate(
          CurvedAnimation(parent: _controller, curve: Curves.decelerate)),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: () {
          if (!_controller.isAnimating) {
            _controller.repeat(reverse: true);
          }
          controller.recordVoice();
          isRecording = true;
          widget.onStartRecording();
          setState(() {});
        },
        onLongPressEnd: (value) {
          endRecording();
        },
        onSecondaryTap: () {
          endRecording();
        },
        child: CircleAvatar(
          backgroundColor:
              isRecording ? ColorConstants.appBlue : ColorConstants.transparent,
          radius: 20.0,
          child: SizedBox(
            height: 10.h,
            width: 10.w,
            child: Icon(
              Icons.mic_none_outlined,
              color: isRecording
                  ? ColorConstants.whiteColor
                  : ColorConstants.appBlue.withOpacity(0.8),
              size: 26.0,
            ),
          ),
        ),
      ),
    );
  }

  void endRecording() async {
    if (_controller.isAnimating) {
      _controller.reset();
    }
    // String? recPath = await
    Recording? recording = await controller.stopRecording();
    isRecording = false;
    widget.onRecordingEnd(recording?.path);
    setState(() {});
  }
}
