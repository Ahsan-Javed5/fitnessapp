import 'dart:async';
import 'dart:developer';

import 'package:fitnessapp/config/app_state_observer.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/screens/chat/controllers/audio_controller.dart';
import 'package:fitnessapp/screens/chat/controllers/chat_api_controller.dart';
import 'package:fitnessapp/screens/chat/handlers/incoming_image_view_handler.dart';
import 'package:fitnessapp/screens/chat/handlers/incoming_video_message_handler.dart';
import 'package:fitnessapp/screens/chat/handlers/incoming_voice_message_handler.dart';
import 'package:fitnessapp/screens/chat/handlers/outgoing_image_view_handler.dart';
import 'package:fitnessapp/screens/chat/handlers/outgoing_video_message_handler.dart';
import 'package:fitnessapp/screens/chat/handlers/outgoing_voice_message_handler.dart';
import 'package:fitnessapp/screens/chat/message_input_layout.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/chat/reply_messge_widget.dart';
import 'package:fitnessapp/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:messenger/config/Glob.dart';
import 'package:messenger/controllers/threads_controller.dart';
import 'package:messenger/model/Message.dart';
import 'package:messenger/model/MessageType.dart';
import 'package:messenger/model/Thread.dart';
import 'package:messenger/utils/time_utils.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:sizer/sizer.dart';

import 'handlers/incoming_text_message_handler.dart';
import 'handlers/outgoing_text_message_handler.dart';

class ChatViewScreen extends StatefulWidget {
  final int? position;
  final Thread thread;
  final String currentUserId;
  final Map<String, dynamic>? arguments;

  const ChatViewScreen({
    Key? key,
    this.position,
    required this.thread,
    required this.currentUserId,
    this.arguments,
  }) : super(key: key);

  @override
  _ChatViewScreenState createState() => _ChatViewScreenState();
}

class _ChatViewScreenState extends State<ChatViewScreen> {
  double _deletedTimeStamp = -1;
  FocusNode chatFocusNode = FocusNode();
  final _messages = <Message>[];
  final _scrollController = ScrollController();
  late final StreamSubscription _messagesSubscription;
  late final PausableTimer timer;
  Message? rMessage;

  final appStateController = Get.find<AppStateObserver>();
  final subscriptionController = Get.put(ChatApiController());
  AudioController controller = Get.put(AudioController());

  @override
  void initState() {
    super.initState();
    subscriptionController
        .checkSubscriptionStatus(widget.thread.receiverUserId ?? '');

    //disable other data observers
    Glob().setThreadItemListener(false);
    ThreadsController.updateTypingState(
        widget.thread.entityId ?? '', widget.currentUserId, 'active');

    ///if something changes in the display params of the thread
    ///like online state then this method will be called
    widget.thread.addListener(() {
      if (mounted) setState(() {});
    });

    ///get deleted time stamp
    ///if this user has deleted this thread then get the deleted timestamp from
    ///thread object and only show messages after that deleted timestamp
    widget.thread.users?.forEach((element) {
      if (element.entityID == widget.currentUserId) {
        _deletedTimeStamp = element.deleted ?? -1;
      }
    });

    timer = PausableTimer(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          SchedulerBinding.instance?.addPostFrameCallback((_) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent + 200,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
            );
          });
        });
      }
    });

    ThreadsController.listenChatBySingleMessage(widget.thread.entityId!,
            widget.currentUserId, _newMessageAdded, _deletedTimeStamp)
        .then((StreamSubscription s) => _messagesSubscription = s);
    Future.delayed(1.seconds, () {
      //scrollToBottom();
    });
  }

  @override
  void deactivate() {
    widget.thread.removeListener(() {});
    Glob().setThreadItemListener(true);
    ThreadsController.updateTypingState(
        widget.thread.entityId!, widget.currentUserId, 'inactive');
    super.deactivate();
  }

  void scrollToBottom() {
    final bottomOffset = _scrollController.position.maxScrollExtent + 200;
    _scrollController.animateTo(
      bottomOffset,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 6.0.h,
          ),

          /// Top Row
          /// Thread Info back button, name, display picture
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 2.0.h,
              ),

              //back button
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: SvgPicture.asset(
                  'assets/svgs/ic_arrow.svg',
                  matchTextDirection: true,
                ),
                onPressed: () {
                  if (controller.isRecording) {
                    controller.stopRecording();
                  }
                  Navigator.pop(context);
                },
              ),

              SizedBox(
                width: 7.0.w,
              ),

              //display picture
              ClipOval(
                child: SizedBox(
                  height: 7.0.h,
                  width: 7.0.h,
                  child: CustomNetworkImage(
                    imageUrl: '${widget.thread.displayPictureUrl}',
                    fit: BoxFit.cover,
                    useDefaultBaseUrl:
                        !(widget.thread.displayPictureUrl?.contains('http') ??
                            false),
                  ),
                ),
              ),

              SizedBox(
                width: 4.0.w,
              ),

              //display thread name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///display name  of the thread
                    Text(
                      widget.thread.displayName ?? 'No Name',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14.5.sp,
                        fontFamily: FontConstants.montserratSemiBold,
                        color: ColorConstants.appBlack,
                      ),
                    ),

                    Text(
                      widget.thread.onlineIndicator != null
                          ? 'Online'
                          : (widget.thread.lastOnline != null)
                              ? 'last online ${TimeUtils.getAgoTimeLong(widget.thread.lastOnline!)}'
                              : '',
                      style: TextStyle(
                          color: ColorConstants.grayLight, fontSize: 12.0.sp),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: 0.5.h,
              ),
            ],
          ),

          SizedBox(
            height: 3.0.h,
          ),

          ///Message list
          Expanded(
            child: ScrollConfiguration(
              behavior: MyScrollBehavior(),
              child: ListView.builder(
                reverse: true,
                shrinkWrap: false,
                //controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, position) {
                  bool isOld = _messages[position].type !=
                              MessageType.ChatMessageHandler &&
                          _messages[position].type != null
                      ? true
                      : false;
                  return isOld
                      ? _oldMessageHandler(_messages[position])
                      : _newMessageHandler(
                          _messages[position],
                          position,
                        );
                },
              ),
            ),
          ),

          Container(
            //color: Colors.red,
            height: 1.0.h,
          ),

          Obx(() {
            /// if this user is disabled from admin then do this
            if (appStateController.isChatEnabled.isFalse &&
                widget.thread.receiverUserId != MyHive.adminFBEntityKey) {
              Get.back();
              Future.delayed(1.seconds,
                  () => Utils.showSnack('alert', 'chats_disabled_note'));
            } else if (appStateController.coachPrivateChatsEnabled.isTrue ||
                widget.thread.receiverUserId == MyHive.adminFBEntityKey) {
              return

                  /// If the receiver is disabled from admin side then go with this
                  (widget.thread.isThreadDisabled ||
                              widget.thread.isUserAway) &&
                          widget.thread.receiverUserId !=
                              MyHive.adminFBEntityKey
                      ? Container(
                          width: double.infinity,
                          color: ColorConstants.veryLightBlue,
                          padding: EdgeInsets.all(4.w),
                          child: SafeArea(
                              top: false,
                              child: Center(
                                child: Text(
                                  widget.thread.isThreadDisabled
                                      ? 'messaging_disabled_note'.tr
                                      : 'this_user_has_disabled_chat'.tr,
                                  textAlign: TextAlign.center,
                                ),
                              )),
                        )
                      : Obx(
                          () {
                            /// else check if user is subscribed then show input layout otherwise dont
                            return subscriptionController.isAPILoading.isTrue
                                ? const SizedBox()
                                : (subscriptionController.isSubscribed.isTrue
                                    ? Column(
                                        children: [
                                          if (rMessage != null) buildReply(),
                                          MessageInputLayout(
                                            widget.thread,
                                            widget.currentUserId,
                                            () {
                                              return rMessage;
                                            },
                                            chatFocusNode,
                                            widget.arguments ?? {},
                                            isOnline:
                                                widget.thread.onlineIndicator ??
                                                    false,
                                            fcm: widget.thread.displayUserFcm ??
                                                '',
                                            onMessageSend: () {
                                              cancelReply();
                                            },
                                          ),
                                        ],
                                      )
                                    : Container(
                                        width: double.infinity,
                                        color: ColorConstants.veryLightBlue,
                                        padding: EdgeInsets.all(4.w),
                                        child: Text(
                                          'chat_is_unavailable_for_unsubscribed_users'
                                              .tr,
                                          textAlign: TextAlign.center,
                                        ),
                                      ));
                          },
                        );
            } else if (appStateController.coachPrivateChatsEnabled.isFalse) {
              return Container(
                width: double.infinity,
                color: ColorConstants.veryLightBlue,
                padding: EdgeInsets.all(4.w),
                child: SafeArea(
                  top: false,
                  child: Center(
                    child: Text(
                      'you_have_disabled_private_chat'.tr,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }

  Widget _newMessageHandler(Message message, int position) {
    bool isOutgoing = message.from == widget.currentUserId;
    switch (message.meta!.type) {
      case MessageType.Text:
        return isOutgoing
            ? OutgoingTextMessageHandler(
                message: message,
                onSwipedMessage: (message) {
                  addSwipeMessageToRMessage(message);
                },
                position: position,
              )
            : IncomingTextMessageHandler(
                message: message,
                onSwipedMessage: (message) {
                  addSwipeMessageToRMessage(message);
                },
                position: position,
              );

      ///this will handle old message of text Type
      case MessageType.TextV1:
        return isOutgoing
            ? OutgoingTextMessageHandler(
                message: message,
                onSwipedMessage: (message) {
                  addSwipeMessageToRMessage(message);
                },
                position: position,
              )
            : IncomingTextMessageHandler(
                message: message,
                onSwipedMessage: (message) {
                  addSwipeMessageToRMessage(message);
                },
                position: position,
              );
      case MessageType.Video:
        return isOutgoing
            ? OutgoingVideoMessageHandler(
                onSwipedMessage: (message) {
                  addSwipeMessageToRMessage(message);
                },
                position: position,
                message: message,
              )
            : IncomingVideoMessageHandler(
                message: message,
                onSwipedMessage: (message) {
                  addSwipeMessageToRMessage(message);
                },
                position: position,
              );
      case MessageType.Audio:
        return isOutgoing
            ? OutgoingVoiceMessageHandler(
                message: message,
                position: position,
                onSwipedMessage: (message) {
                  addSwipeMessageToRMessage(message);
                },
              )
            : IncomingVoiceMessageHandler(
                message: message,
                position: position,
                onSwipedMessage: (message) {
                  addSwipeMessageToRMessage(message);
                });
      case MessageType.Image:
        return isOutgoing
            ? OutGoingImageViewHandler(
                message: message,
                position: position,
                onSwipedMessage: (message) {
                  addSwipeMessageToRMessage(message);
                })
            : IncomingImageViewHandler(
                message: message,
                position: position,
                onSwipedMessage: (message) {
                  addSwipeMessageToRMessage(message);
                },
              );
      default:
        return Container(
          color: Colors.white,
          child: Text(
            'Unknown message type',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0.sp,
            ),
          ),
        );
    }
  }

  Widget _oldMessageHandler(Message message) {
    bool isOutgoing = message.from == widget.currentUserId;
    switch (message.type) {
      case MessageType.TextV1:
        return isOutgoing
            ? OutgoingTextMessageHandler(
                message: message,
                onSwipedMessage: (message) {
                  addSwipeMessageToRMessage(message);
                },
              )
            : IncomingTextMessageHandler(
                message: message,
                onSwipedMessage: (message) {
                  addSwipeMessageToRMessage(message);
                },
              );
      case MessageType.VideoV1:
        return isOutgoing
            ? OutgoingVideoMessageHandler(
                onSwipedMessage: (message) {
                  addSwipeMessageToRMessage(message);
                },
                message: message,
              )
            : IncomingVideoMessageHandler(
                message: message,
                onSwipedMessage: (message) {
                  addSwipeMessageToRMessage(message);
                },
              );
      default:
        return Container(
          color: Colors.white,
          child: Text(
            'Unknown message type',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0.sp,
            ),
          ),
        );
    }
  }

  void _newMessageAdded(Message messages) {
    timer.reset();
    //_messages.insert(0, messages);
    _messages.add(messages);
    _messages.sort((b, a) => a.date!.compareTo(b.date!));

    timer.start();
  }

  void addSwipeMessageToRMessage(Message message) {
    chatFocusNode.requestFocus();
    setState(() {
      rMessage = message;
    });
    log(message.meta?.text ?? 'Text Null');
    log(message.meta?.audioUrl ?? 'Audio URl');
    log(message.meta?.videoUrl ?? 'Video Null');
  }

  void cancelReply() {
    setState(() {
      rMessage = null;
    });
  }

  Widget buildReply() => Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: ColorConstants.whiteColor,
          boxShadow: [
            BoxShadow(
              color: ColorConstants.gray.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(-2, -0),
            )
          ],
        ),

        ///if [_isReplaying] is true then the message will never be null so just add !
        child: ReplyMessageWidget(
          message: rMessage,
          onCancelReply: cancelReply,
        ),
      );

  @override
  void dispose() {
    if (_messagesSubscription != null) {
      _messagesSubscription.cancel();
      widget.thread.removeListener(() {});
      widget.thread.unSubscribe();
    }
    chatFocusNode.dispose();
    super.dispose();
  }
}

class MyScrollBehavior extends ScrollBehavior {
  ///This behaviour removes the scroll glow

  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

///reply feature layout
