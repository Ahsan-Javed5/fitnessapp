import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/screens/chat/controllers/chat_api_controller.dart';
import 'package:fitnessapp/screens/chat/handlers/outgoing_reply_message_handler.dart';
import 'package:fitnessapp/widgets/chat/chat_swipe_widget.dart';
import 'package:fitnessapp/widgets/custom_network_video.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:messenger/model/Message.dart';
import 'package:messenger/utils/time_utils.dart';
import 'package:sizer/sizer.dart';

import '../../video_player_screen.dart';

class OutgoingVideoMessageHandler extends GetWidget<ChatApiController> {
  final Message message;
  final ValueChanged<Message>? onSwipedMessage;
  final int? position;

  const OutgoingVideoMessageHandler({
    this.onSwipedMessage,
    this.position,
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwipeMessage(
      ///will return swiped message
      onLeftSwipe: () => onSwipedMessage?.call(message),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ///start margin
          SizedBox(
            width: 12.w,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                ///main content
                Container(
                  decoration: BoxDecoration(
                    color: ColorConstants.grayVeryLight,
                    borderRadius: BorderRadius.circular(2.0.w),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 1.0.h, horizontal: 1.0.h),
                    child: Column(
                      children: [
                        if (message.replyConversation?.isReply ?? false) ...[
                          OutgoingReplyMessageHandler(
                            message: message,
                          ),
                        ] else ...[
                          OutGoingChildVideoWidget(
                            extraMap: message.meta!.extraMap!,
                            isReply: false,
                            color: ColorConstants.grayVeryLight,
                            thumbURl:
                                message.meta?.extraMap?['video_thumbnail'] ??
                                    '',
                            videoUrlV2: message.meta?.extraMap?['video_url'] ??
                                message.meta?.fileUrl,
                          )
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.5.h,
                ),

                ///Time view
                Container(
                  margin: EdgeInsets.only(right: 1.0.h),
                  child: Text(
                    TimeUtils.getTimeInddMMMyyHHMM(message.date ?? 0),
                    style: TextStyle(
                      color: ColorConstants.appBlack,
                      fontSize: 9.0.sp,
                    ),
                  ),
                ),

                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          ),

          ///end margin
          SizedBox(
            width: 1.5.h,
          ),
        ],
      ),
    );
  }
}

class OutGoingChildVideoWidget extends StatelessWidget {
  final String thumbURl;
  final String videoUrlV2;
  final bool isReply;
  final Map? extraMap;
  final Color? color;
  const OutGoingChildVideoWidget({
    Key? key,
    required this.thumbURl,
    required this.videoUrlV2,
    required this.isReply,
    required this.extraMap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? videoUrl = videoUrlV2;
    String? vThumb = thumbURl;
    String navKey = extraMap?['nav_path'] ?? '';
    bool isHavePathKeys = navKey.isEmpty ? false : true;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2.w),
          child: SizedBox(
            width: double.infinity,
            height: isReply ? 17.h : 27.h,
            child: CustomNetworkVideo(
              url: videoUrl,
              thumbnail: vThumb,
              inChat: true,
              width: double.infinity,
              height: isReply ? 17.h : 27.h,
              onPlayButtonClick: () {
                showDialog(
                  context: context,
                  builder: (context) => VideoPlayerScreen(
                    url: videoUrl,
                    videoId: -1,
                    processStatus: 1,
                    videoStreamUrl: videoUrl,
                  ),
                  useSafeArea: false,
                );
              },
            ),
          ),
        ),
        if (isHavePathKeys) ...[
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              extraMap?['reason'] ?? '',
              softWrap: true,
              style: TextStyle(
                color: ColorConstants.appBlack,
                fontSize: 12.0.sp,
              ),
            ),
          ),
          SizedBox(height: isHavePathKeys ? 1.0.h : 0),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              extraMap?['nav_path'].toString().toUpperCase() ?? '',
              softWrap: true,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: ColorConstants.bodyTextColor,
                fontSize: 10.0.sp,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
