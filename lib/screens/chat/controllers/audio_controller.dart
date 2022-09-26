import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:fitnessapp/utils/utils.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum RecordingState {
  unSet,
  set,
  recording,
  stopped,
}

class AudioController extends GetxController {
  String recorderTxt = '';
  FlutterAudioRecorder2? audioRecorder;
  RecordingState recordingState = RecordingState.unSet;
  final RxBool _isRecording = false.obs;
  final RxBool _isStopped = false.obs;

  get isRecording => _isRecording.value;
  get isStopped => _isStopped.value;

  @override
  void onInit() {
    askPermission();
    FlutterAudioRecorder2.hasPermissions.then((hasPermission) {
      if (hasPermission!) {
        recordingState = RecordingState.set;
      }
    });
    super.onInit();
  }

  initRecorder() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String filePath = appDirectory.path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.aac';

    audioRecorder =
        FlutterAudioRecorder2(filePath, audioFormat: AudioFormat.AAC);
    await audioRecorder?.initialized;
  }

  startRecording() async {
    startTimer();
    await audioRecorder?.start();
    _isRecording.value = true;
  }

  Future<Recording?> stopRecording({bool wantToDelFile = false}) async {
    Recording? recording = await audioRecorder?.stop();
    stopTimer();
    if (wantToDelFile) {
      deleteFile(recording?.path);
    }
    _isStopped.value = true;
    _isRecording.value = false;
    return recording;
  }

  Future<void> recordVoice() async {
    final hasPermission = await FlutterAudioRecorder2.hasPermissions;
    if (hasPermission ?? false) {
      await initRecorder();
      await startRecording();
      recordingState = RecordingState.recording;
    } else {
      Utils.showSnack('Alert', 'Please allow recording from settings.');
    }
  }

  void deleteFile(String? path) {
    try {
      log('Deleting File');
      if (path != null) {
        File f = File(path);
        if (f.existsSync()) {
          f.deleteSync();
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void dispose() {
    recordingState = RecordingState.unSet;
    super.dispose();
  }

  void askPermission() async {
    PermissionStatus mic = await Permission.microphone.status;
    PermissionStatus sto = await Permission.storage.status;
    PermissionStatus iosPhoto = await Permission.photos.status;
    if (mic.isDenied && sto.isDenied && iosPhoto.isDenied) {
      await [Permission.microphone, Permission.storage, Permission.photos]
          .request();
    } else if (mic.isDenied) {
      await Permission.microphone.request();
    } else if (sto.isDenied) {
      await Permission.storage.request();
    } else if (iosPhoto.isDenied) {
      await Permission.photos.request();
    }
  }

  Future<bool> isPermissionAllowed() async {
    bool isAllowed = await Permission.storage.isGranted &&
        await Permission.microphone.isGranted;
    return isAllowed;
  }

  String timeFormatter(int time) {
    Duration duration = Duration(seconds: time);
    return [duration.inHours, duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  stopTimer() {
    if (timer.isActive) {
      timer.cancel();
      recorderTxt = timeFormatter(0);
      start.value = 0;
      update(['timer_handler']);
    }
  }

  late Timer timer;
  RxInt start = 0.obs;
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        int t = start.value++;
        recorderTxt = timeFormatter(t.toInt());
        update(['timer_handler']);
      },
    );
  }
}
