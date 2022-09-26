import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:fitnessapp/config/fcm_controller.dart';
import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/screens/chat/controllers/audio_controller.dart';
import 'package:fitnessapp/screens/chat/controllers/chat_api_controller.dart';
import 'package:fitnessapp/utils/my_image_picker.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/chat/voice_recorder_widget.dart';
import 'package:fitnessapp/widgets/custom_network_video.dart';
import 'package:fitnessapp/widgets/dialogs/add_video_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:media_info/media_info.dart';
import 'package:messenger/controllers/threads_controller.dart';
import 'package:messenger/model/Keys.dart';
import 'package:messenger/model/Message.dart';
import 'package:messenger/model/MessageMetaValue.dart';
import 'package:messenger/model/MessageType.dart';
import 'package:messenger/model/ReplyConversation.dart';
import 'package:messenger/model/Thread.dart';
import 'package:messenger/utils/view_utils.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/chat/voice_message_player_widget.dart';

class MessageInputLayout extends StatefulWidget {
  final Thread _thread;
  final String _currentUserId;
  final Map<String, dynamic> arguments;
  final bool isOnline;
  final String fcm;
  final FocusNode foucsNode;
  final Message? Function() onMessageChange;
  final VoidCallback onMessageSend;

  const MessageInputLayout(
    this._thread,
    this._currentUserId,
    this.onMessageChange,
    this.foucsNode,
    this.arguments, {
    Key? key,
    this.isOnline = false,
    this.fcm = '',
    required this.onMessageSend,
  }) : super(key: key);

  @override
  _MessageInputLayoutState createState() =>
      _MessageInputLayoutState(_thread, _currentUserId);
}

class _MessageInputLayoutState extends State<MessageInputLayout> {
  /// This variable will hold info of receiver if he is active in this thread or not
  List<String> receiverList = <String>[];
  final Thread _thread;
  final String _currentUserId;
  final TextEditingController _messageTextController = TextEditingController();
  late final StreamSubscription receiverTypingStatusSubscription;
  String typingIndication = '';

  final _outlinedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.w)),
    borderSide:
        const BorderSide(width: 1.0, color: ColorConstants.bodyTextColor),
  );
  final chatApiController = Get.find<ChatApiController>();
  final audioController = Get.find<AudioController>();
  _MessageInputLayoutState(this._thread, this._currentUserId);

  @override
  void initState() {
    textEditFieldListener();
    _thread.users?.forEach((element) {
      if (element.entityID != _currentUserId) {
        receiverList.add(element.entityID!);
      }
    });
    super.initState();

    ThreadsController.observerTypingStatus(
        _thread.entityId!, _thread.receiverUserId!, (s) {
      typingIndication = s;
    }).then((StreamSubscription s) => receiverTypingStatusSubscription = s);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstants.whiteColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          children: [
            /// Attachment layout
            if (widget.arguments.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Spaces.normX(2), vertical: Spaces.normY(1.4)),
                decoration: BoxDecoration(
                  color: ColorConstants.grayVeryLight.withOpacity(0.8),
                  border: Border.all(color: ColorConstants.veryLightBlue),
                  borderRadius: BorderRadius.circular(Spaces.normX(1)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2.w),
                      child: SizedBox(
                        height: 10.h,
                        width: 10.h,
                        child: CustomNetworkVideo(
                          width: 10.h,
                          height: 10.h,
                          url: widget.arguments['video_url'],
                          thumbnail: widget.arguments['video_thumbnail'],
                        ),
                      ),
                    ),
                    Spaces.x3,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 63.w,
                          child: Text(
                            Utils.isRTL()
                                ? widget.arguments['title_ar']
                                : widget.arguments['title_en'],
                            style: TextStyles.subHeadingBlackMedium
                                .copyWith(fontSize: 12.sp),
                          ),
                        ),
                        Spaces.y0,
                        SizedBox(
                          width: 63.w,
                          child: Text(
                            widget.arguments['nav_path'],
                            style: TextStyles.normalGrayBodyText
                                .copyWith(fontSize: 10.sp),
                            maxLines: 3,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            if (widget.arguments.isNotEmpty) Spaces.y1,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                ///for showing recording text
                MixinBuilder<AudioController>(
                  builder: (audioC) {
                    return audioC.isRecording
                        ? Text(audioC.recorderTxt)
                        : ClipOval(
                            child: Container(
                              color: ColorConstants.appBlue,
                              child: IconButton(
                                icon: SvgPicture.asset(
                                  'assets/svgs/ic_chat_attach.svg',
                                  matchTextDirection: true,
                                ),
                                padding: EdgeInsets.zero,
                                color: ColorConstants.appBlue,
                                highlightColor: ColorConstants.appBlue,
                                onPressed: () => _showAttachOption(),
                              ),
                            ),
                          );
                  },
                  id: 'timer_handler',
                ),

                SizedBox(
                  width: 4.w,
                ),
                Flexible(
                  child: TextField(
                    controller: _messageTextController,
                    maxLines: 3,
                    autofocus: false,
                    minLines: 1,
                    focusNode: widget.foucsNode,
                    enableSuggestions: true,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (text) => _sendMessage(
                        messageType: MessageType.Text,
                        dataToSend: _messageTextController.text),
                    decoration: InputDecoration(
                      hintText: 'type_message_here'.tr,
                      fillColor: Colors.transparent,
                      disabledBorder: _outlinedBorder,
                      enabledBorder: _outlinedBorder,
                      focusedBorder: _outlinedBorder,
                      errorBorder: _outlinedBorder,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 2.0.w, vertical: 1.0.h),
                      hintStyle: const TextStyle(
                        color: ColorConstants.grayLight,
                      ),
                    ),
                    style: TextStyle(
                      color: ColorConstants.appBlack,
                      fontSize: 12.0.sp,
                    ),
                  ),
                ),
                SizedBox(
                  width: 4.w,
                ),
                if (isTyping) ...[
                  ClipOval(
                    child: Container(
                      color: ColorConstants.appBlue,
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'assets/svgs/ic_send.svg',
                          matchTextDirection: true,
                        ),
                        padding: EdgeInsets.zero,
                        color: ColorConstants.appBlue,
                        highlightColor: ColorConstants.appBlue,
                        onPressed: () => _sendMessage(
                          messageType: MessageType.Text,
                          dataToSend: _messageTextController.text,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          chatApiController.selectImage(
                            source: ImageSource.camera,
                            onImageUploadedDone: (String? url) {
                              if (url?.isNotEmpty ?? false) {
                                //log('Image uploaded url: $url');
                                _sendMessage(
                                  messageType: MessageType.Image,
                                  dataToSend: url,
                                );
                              }
                            },
                          );
                        },
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: ColorConstants.appBlue,
                        ),
                      ),
                      SizedBox(
                        width: 1.w,
                      ),
                      RecorderWidget(
                        onStartRecording: () {
                          //  log('Recording has been started');
                        },
                        onRecordingEnd: (value) {
                          if (value?.isNotEmpty ?? false) {
                            File recFile = File(value!);
                            chatApiController.uploadAudioFile(
                              file: recFile,
                              onFileUploaded: (url) {
                                if (url != null) {
                                  _sendMessage(
                                    dataToSend: url,
                                    messageType: MessageType.Audio,
                                  );
                                }
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// [resource] coule be a single text message , audio file , video file , voice message
  getMessageMeta({int? messageType, String? resource, String? duration}) {
    switch (messageType) {
      case MessageType.Text:
        return MessageMetaValue(text: resource, type: messageType);
      case MessageType.Image:
        return MessageMetaValue(fileUrl: resource, type: messageType);
      case MessageType.Audio:
        return MessageMetaValue(
          audioUrl: resource,
          type: messageType,
          duration: duration,
        );
      case MessageType.Video:
        return MessageMetaValue(videoUrl: resource, type: messageType);
      default:
        break;
    }
  }

  ///live send messagae function
  ///[dataToSend] could be anything , message , audio url , video url
  ///[thumbUrl] this will be not null only if sending video
  ///[widget.arguments.isNotEmpty] if this will be empty then its else section will be added
  void _sendMessage(
      {int? messageType, String? dataToSend, String? thumbUrl}) async {
    if (messageType == MessageType.Text) {
      if (_messageTextController.text.trim().isEmpty) return;
    }
    _messageTextController.clear();
    Message? rMessage = widget.onMessageChange();
    MessageMetaValue meta = getMessageMeta(
      messageType:
          widget.arguments.isNotEmpty ? MessageType.Video : messageType,
      resource: widget.arguments.isNotEmpty
          ? widget.arguments['video_url']
          : dataToSend,
    );
    if (widget.arguments.isNotEmpty) {
      ///if the argus are not empty then textEditing controller text will be the reason
      widget.arguments['reason'] = _messageTextController.text;
      meta.extraMap = widget.arguments;
    } else if (messageType == MessageType.Video) {
      meta.extraMap = {
        'nav_path': '',
        'title_en': '',
        'title_ar': '',
        'video_id': '',
        'video_thumbnail': thumbUrl,
        Keys.MessageVideoURL: dataToSend!,
      };
    }
    ReplyConversation? replyConversation;
    if (rMessage != null) {
      replyConversation = ReplyConversation(
        isReply: true,
        messageId: rMessage.entityID,
        userId: rMessage.from,
        message: rMessage.meta?.type == MessageType.Text
            ? rMessage.meta?.text
            : rMessage.meta?.type == MessageType.Audio
                ? rMessage.meta?.audioUrl
                : rMessage.meta?.type == MessageType.Video
                    ? rMessage.meta?.extraMap!['video_url'] ??
                        rMessage.meta?.fileUrl
                    : rMessage.meta?.fileUrl,
        type: rMessage.meta?.type,
        video_thumbnail: rMessage.meta?.type == MessageType.Video
            ? rMessage.meta?.extraMap!['video_thumbnail']
            : '',
      );
    } else {
      replyConversation =
          ReplyConversation(isReply: false, messageId: '', userId: '');
    }
    /**
     *   add duration to meta
     *   when type is audio
     *
     */

    if (messageType == MessageType.Audio) {
      // var duration = getAudioDuration(dataToSend!);
      var url = ViewUtils.getSasUrl(dataToSend!);
      final _audioPlayer = AudioPlayer();
      Duration duration = await _audioPlayer.setUrl(url) as Duration;
      String formattedDuration = formatDuration(duration);
      print("Audio File Duration is " + formattedDuration.toString());
      meta.duration = formattedDuration;
    }

    print("Meta Data : " + meta.toString());

    Message msg = Message(
      '',
      0.0,
      -1, // as per discussion we have decided to remove this type from the message type now this will help to handle old messages types
      0,
      0.0,
      0.0,
      0.0,
      null,
      null,
      null,
      null,
      _currentUserId,
      _currentUserId,
      meta,
      replyConversation,
      null,
    );
    msg.threadEntityId = _thread.entityId!;
    msg.to = receiverList;

    /**
     *     send  message to Firebase Db
     *     Update
     */

    ThreadsController.sendMessage(msg).then((value) {
      if (value.isError) {
        Utils.showSnack('Error', '${value.message}: Message is not delivered',
            isError: true);
        return;
      }
      if (widget.foucsNode.hasFocus) {
        widget.foucsNode.unfocus();
      }

      ///removing the overlay from the input layout
      widget.onMessageSend();

      /// if user is offline then send push notification
      if (typingIndication != 'active' || !widget.isOnline) {
        String title = 'Chat Message';
        String body = '${MyHive.getUser()?.getFullName()}: $dataToSend';
        FCMController().sendPushNotification(
            widget.fcm, title, body, {'senderId': widget._currentUserId});
      }
      return;
    }).onError((error, stackTrace) {});
    setState(() {
      widget.arguments.clear();
    });
  }

  ///help to build recorder ui
  bool isTyping = false;
  void textEditFieldListener() {
    _messageTextController.addListener(() {
      if (_messageTextController.text.isNotEmpty) {
        isTyping = true;
      } else {
        isTyping = false;
      }
      setState(() {});
    });
  }

  /// Add intro video dialog
  void _showAddIntroVideoDialog({
    required BuildContext context,
    required void Function(String, String) onFileUploadingDone,
  }) {
    showDialog(
      context: context,
      useRootNavigator: true,
      useSafeArea: false,
      barrierDismissible: false,
      builder: (context) {
        return AddVideoDialog(
          onSavedClick: (File file) {
            chatApiController.uploadVideoFile(
              videoFile: file,
              videoPath: file.path,
              onFileUploaded: (url, thumbUrl) {
                if (Get.isDialogOpen ?? false) {
                  Get.back();
                }
                onFileUploadingDone.call(url, thumbUrl);
              },
            );
          },
          backgroundColor: ColorConstants.transparent,
          saveBtnTitle: 'send',
        );
      },
    );
  }

  void _showAttachOption() {
    Get.bottomSheet(Container(
      decoration: const BoxDecoration(
        color: ColorConstants.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      alignment: Alignment.center,
      height: 15.h,
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
              onTap: () {
                Get.back();
                Future.delayed(10.milliseconds, () {
                  chatApiController.selectImage(
                    source: ImageSource.gallery,
                    onImageUploadedDone: (String? url) {
                      if (url?.isNotEmpty ?? false) {
                        //log('Image uploaded url: $url');
                        _sendMessage(
                          messageType: MessageType.Image,
                          dataToSend: url,
                        );
                      }
                    },
                  );
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.image,
                    color: ColorConstants.appBlue,
                  ),
                  Spaces.x4,
                  const Text('Upload an image')
                ],
              )),
          Spaces.y5,
          InkWell(
            onTap: () {
              Get.back();
              _showAddIntroVideoDialog(
                context: context,
                onFileUploadingDone: (url, thumbUrl) {
                  _sendMessage(
                    messageType: MessageType.Video,
                    dataToSend: url,
                    thumbUrl: thumbUrl,
                  );
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.slow_motion_video_outlined,
                  color: ColorConstants.appBlue,
                ),
                Spaces.x4,
                const Text('Upload a video')
              ],
            ),
          ),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    receiverTypingStatusSubscription.cancel();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    var microseconds = duration.inMicroseconds;

    var hours = microseconds ~/ Duration.microsecondsPerHour;
    microseconds = microseconds.remainder(Duration.microsecondsPerHour);

    if (microseconds < 0) microseconds = -microseconds;

    var minutes = microseconds ~/ Duration.microsecondsPerMinute;
    microseconds = microseconds.remainder(Duration.microsecondsPerMinute);

    var minutesPadding = minutes < 10 ? "0" : "";

    var seconds = microseconds ~/ Duration.microsecondsPerSecond;
    microseconds = microseconds.remainder(Duration.microsecondsPerSecond);

    var secondsPadding = seconds < 10 ? "0" : "";

    String finalTime = "$hours:"
        "$minutesPadding$minutes:"
        "$secondsPadding$seconds";
    String finalFormattedTime = finalTime.padLeft(8, "0");
    return finalFormattedTime;
  }
}

getAudioDuration(String fileUrl) async {
  var url = ViewUtils.getSasUrl(fileUrl);
  final _audioPlayer = AudioPlayer();
  Duration _duration = await _audioPlayer.setUrl(url) as Duration;
  return _duration;
}
